data segment
 source db 20 dup(-1)
data ends
assume cs:code,ds:data
code segment
start:
mov ax,data
mov ax,ds
mov ax,-1
cmp ax,0
js ok
mov ah,2
mov dl,'z'
int 21h
jmp jieshu
ok:
mov ah,2
mov dl,'f'
int 21h
jieshu:
mov ax,4c00h
int 21h
code ends
end start