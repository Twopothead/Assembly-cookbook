push di
lea si,huanchong
add si,2
mov cx,bp
cld
repz cmpsb
cmp cx,0
jz success
pop di
add di,16
push di
success:
pop di
mov ah,2
mov bx,di
mov dl,bl
add dl,30h
int 21h
