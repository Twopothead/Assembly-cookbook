data segment
;A dw 20 dup(0)
A db 7,1,2,3
B db 9,5,4,7
;B dw 20 dup(0)
data ends
assume cs:code,ds:data,ss:stack
stack segment
 dw  40 dup(0)
stack ends
code segment
changecf macro
push ax
mov al,255
add al,255
pop ax
endm
start :
mov  ax,data
mov  ds,ax
mov  ax,stack
mov  ss,ax
mov  sp,80
lea si,A
lea di,B
sub ax,ax
mov cx,4
s:mov al,byte ptr [si]
adc al,byte ptr [di]
cmp al,10
jb bujinwei
sub al,10
changecf
jmp biaozhi
bujinwei:
sub bp,bp
biaozhi:
mov byte ptr [si],al
inc si
inc di
loop s
lea si,A
xor dx,dx
mov cx,4
nixucun:mov dl,byte ptr [si]
add dl,30h
push dx
inc si
loop nixucun
mov ah,2
mov cx,4
again:
pop dx
int 21h
loop again

mov ax,4c00h
int 21h


code ends
end start