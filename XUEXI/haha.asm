data segment
buf db  80,?,20 dup(1,2,3),'$'
data ends
stack segment
   db 16 dup(0)
stack ends
assume cs:code,ds:data,ss:stack
code segment
start:mov ax,data
mov ds,ax
mov si,4
lea si,buf

mov al,6
add si,2
mov ds:[si],al
nop
nop
nop
mov ax,4c00h
int 21h
code ends
end start
