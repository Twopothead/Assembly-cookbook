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
start:
mov ax,data
mov ds,ax
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
mov ax,0200h
add dx,30h
int 21h
mov ax,4c00h
int 21h
code ends
end start