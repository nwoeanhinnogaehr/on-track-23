print("in patches.py")

set_base("octalizer.asm", 0x10000)
set_out_file("octalizer")
make_label("main", 0x34)
add_patch("patches/2.asm", "main", 2)
add_patch("patches/3.asm", "main", 3)
add_patch("patches/4.asm", "main", 4)
