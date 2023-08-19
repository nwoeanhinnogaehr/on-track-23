bits 32
org 0x10034
    inc esi ; increment time
    mov edx,esi
    sub edx,0x400000
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


    rcr edx,cl
    and ecx,edx

    ror ecx,16
    add cl,ch
    or ch,cl
    ror ecx,16
    add cl,ch
    or ch,cl
    push ecx
