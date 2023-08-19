org 0x100
entry:
mov al,0x13
int 0x10
push 0xa000
pop ds

main:
xor dx,dx
mov ax,di
mov bp,320
div bp
; ax=y, dx=x
mov cl,0xf
xor si,si
march:
xchg ax,dx
add dx,bx
sub ax,bx
add dx,dx
add [bx+si],ax ;db 0x01,0x00, effectively NOP
test dl,al
jno try2; jump if hit
loop march ; goto next layer
try2:
cmp si,si
jne done
cmp cl,0xd
jl done
mov cl,0xc
inc si
mov bp,dx
jmp march ; will get patched later
add dx,ax
sub ax,bp
jmp march
done:
imul ax,si,17
add ax,cx
add al,0x10
mov [di],al
; test di,0x80
; jne skip
; out 0x61,al
; skip:
inc di
jnz main
inc bx
mov si,bx
shr si,7
and si,0b00011110
cs mov ax,word [patchtab+si]
movzx si,al
cs mov byte [entry+si],ah
jmp main
patchtab:
db 0x20,0x7c 
db 0x33,0x00 
db 0x1e,0x38 
db 0x20,0x70 
db 0x1d,0xd8
db 0x20,0x78
db 0x1d,0xc0
db 0x20,0x72
db 0x33,0xe2
db 0x23,0xf2
db 0x33,0xe1
db 0x33,0x00 
db 0x20,0x78
db 0x1b,0x00
db 0x16,0x29
db 0x15,0xc3
