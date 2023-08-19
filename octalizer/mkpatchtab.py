# read patch list
# compile patches
# diff patches and build patch table
# write patch table

# patch list format, something like
# label1: addr1
# label2: addr2
# ...
#
# filename label time
# filename label time
# ...

# can assemble a patch by adding an org statement (from the label)

# make it easy to change table building function, to experiment with different layouts

import sys
import os

base_file = None
entry_addr = None
def set_base(filename, addr):
    global base_file, entry_addr
    assert(base_file == None and entry_addr == None)
    base_file = filename
    entry_addr = addr

out_file = None
def set_out_file(filename):
    global out_file
    out_file = filename

labels = {}
def make_label(label, addr):
    labels[label] = addr

class Patch:
    pass
patches = []
def add_patch(filename, label, time):
    p = Patch()
    p.filename = filename
    p.label = label
    p.time = time
    patches.append(p)

cmdfile = open(sys.argv[1], 'r')
exec(cmdfile.read())
cmdfile.close()

os.system("rm -r .patchtmp")
os.system("mkdir .patchtmp")
os.system("nasm {} -o .patchtmp/base.bin".format(base_file))
# os.system("hexyl .patchtmp/base.bin")
f = open(".patchtmp/base.bin", "rb")
current = list(f.read())[0x2d:] # skip the bash loader and header
f.close()
bytepatches = []
for i in range(len(patches)):
    patch = patches[i]
    offset = labels[patch.label]
    pf = open(patch.filename, "r")
    ptxt = pf.read()
    pf.close()
    ptxt = "bits 32\norg {}\n".format(hex(entry_addr + offset)) + ptxt
    pf = open(".patchtmp/{}.asm".format(str(i)), "w")
    pf.write(ptxt)
    pf.close()
    os.system("nasm .patchtmp/{}.asm -o .patchtmp/{}.bin".format(str(i), str(i)))
    f = open(".patchtmp/{}.bin".format(str(i)), "rb")
    patchdat = list(f.read())
    f.close()
    for i in range(len(patchdat)):
        if patchdat[i] != current[i+offset]:
            bytepatches.append((i+offset, patchdat[i], patch.time))
            print("patch", hex(patchdat[i]),
                    "at address", hex(i+offset),
                    "at time", patch.time,
                    "(was {})".format(hex(current[i+offset])))
            current[i+offset] = patchdat[i]
f = open(base_file, "r")
source = f.read()
f.close()
for (offset, data, time) in bytepatches:
    source += "db {}, {}, {}\n".format(offset, data, time)
f = open(".patchtmp/source.asm", "w")
f.write(source)
f.close()
os.system("nasm .patchtmp/source.asm -o {}".format(out_file))
os.system("hexyl {}".format(out_file))
os.system("chmod +x {}".format(out_file))
