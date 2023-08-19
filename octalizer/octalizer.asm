bits 32
db "cp $0 /tmp;sed -i 1d $_/$0;$_|aplay -c4 -r60",10
org $00010000-($-$$)
top:
    db $7F,"ELF" ; e_ident
    dd 1 ; p_type
    dd 0 ; p_offset
    dd top ; p_vaddr
    dw 2 ; e_type, p_paddr
    dw 3 ; e_machine
    dd entry ; e_version, p_filesz
    dd entry ; e_entry, p_memsz
    dd 4
entry:
    mov al,0x7d ; mprotect
    mov ch,0x10 ; number of bytes to change
    mov dl,7 ; new permissions
    nop ; nop nop nop nop nop nop ;; nop nop nop nop nop nop
    nop ; I have nothing to put here
    nop
    ;mov ebx,0x10000 ; start address to change permissions for
    mov ebx,entry ; skips part of ELF header and loads 0x10020 as a bonus
    mov bl,0
    int 0x80
    mov ebp,ebx
main:
    inc esi ; increment time
    mov edx,esi
    add edx,0x300000
    pop ecx

    shr edx,3
    rcr edx,2
    and ecx,edx
    rcr edx,7
    or ecx,edx
    rcr edx,7
    or ecx,edx
    rcr edx,7
    sub ecx,edx
    rcl edx,cl
    and ecx,edx

    ror ecx,16
    add cl,ch
    or ch,cl
    ror ecx,16
    add cl,ch
    or ch,cl
    push ecx
    
    mov dl,4
    mov eax,ecx
loopy:
    rol eax,cl
    or eax,ecx
    dec dl
    jnz loopy
    test eax,4
    je main

    mov ecx,esp ; pointer to audio data (the top byte of the stack)
    xor eax,eax
    mov al,4 ; write syscall
    xor ebx,ebx
    inc ebx
    mov edx,eax
    int 0x80

    ; do the binary patching
    mov edi,esi
    shr edi,22
nextpatch:
    mov eax,dword [table-3+ebx*3]
    inc ebx
    test eax,eax
    je main
    mov edx,eax
    shr edx,16
    mov dh,0
    cmp edi,edx
    jne nextpatch
    xor ecx,ecx
    mov cl,al
    mov byte [ebp+ecx],ah
    jmp nextpatch

table:
