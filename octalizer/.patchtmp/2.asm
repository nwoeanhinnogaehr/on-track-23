bits 32
org 0x10034
    inc esi ; increment time
    mov edx,esi
    sub edx,0xc00000
    pop ecx

    shr edx,4
    rcr edx,8
    or ecx,edx
    rcr edx,8
    or ecx,edx
    rcr edx,8
    add ecx,edx

    db 0xb8,0xda,0x07,0x29,0xd1
    ; rcr edx,7
    ; sub ecx,edx

    rcl edx,cl
    and ecx,edx

    ; ror ecx,16
    ; or ch,cl
    ; and cl,ch
    ; ror ecx,16
    ; or cl,ch
    ; and ch,cl
    ; push ecx

    ror ecx,16
    add cl,ch
    or ch,cl
    ror ecx,16
    add cl,ch
    or ch,cl
    push ecx
