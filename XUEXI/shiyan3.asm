;x-|y|+|z|
;9-6+5=8
data segment
  x dw 9
  y dw -6
  z dw 5
  result dw ?
data ends
stack segment
  dw 16 dup(0)
stack ends
assume cs:code,ds:data,ss:stack 
code segment
absolute:
sub ax,0
jns ok
neg ax
ok:
ret 
input :
push bx
mov ah,01h
int 21h
aaa
mov bl,al
int 21h
aaa

mov ah,0
mov bh,0
mov cx,10
shi:add ax,bx
loop shi
;mov ax,bx
pop bx
mov word ptr[bx],ax
nop
ret 
start:



mov ax,data
mov ds,ax
lea bx,x
call input
mov ax,0200h
mov dx,word ptr[bx]
add dx,30h
int 21h

lea bx,z
call input
mov ax,0200h
mov dx,word ptr[bx]
add dx,30h
int 21h

mov ax,y
call absolute 
mov bx,ax
mov ax,z
call absolute
mov bp,ax
mov ax,x
nop
sub ax,bx
add ax,bp
mov dx,ax
nop
mov bp,10
mov ax,dx
mov bx,1
imul bx
aam
add ax,3030h
mov bx,ax
mov dx,0
mov dl,bh
mov ah,2
int 21h
mov dl,bl
int 21h
mov ax,4c00h
int 21h
code ends
end start