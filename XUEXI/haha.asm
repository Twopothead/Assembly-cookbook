data segment 
  A db 20 dup(0)
  Alen dw 0
  B db 20 dup(0)
  Blen dw 0
  op db '?'
  huanchong  db 40,?,40 dup(0),'$'
data ends
assume cs:code,ds:data,ss:stack
stack segment
 dw 50 dup(0)
stack ends
code segment
enter macro 
mov ah,2
mov dl,0ah
int 21h
endm
showch macro ch
mov ah,2
mov dl,ch
add dl,30h
int 21h
endm
showchar macro char
mov ah,2
mov dl,char
int 21h
endm
start:
mov ax,stack
mov ss,ax
mov sp,100
mov ax,data
mov ds,ax
mov ah,10
lea dx,huanchong
int 21h
enter
enter
xor ax,ax
mov al,byte ptr huanchong[1]
push ax
add ax,2
mov si,ax
mov huanchong[si],'$'
mov bx,si
showch bl
enter
enter
mov ah,9
lea dx,huanchong[2]
int 21h
enter
enter
xor ax,ax
pop ax
test al,01h
jz oushu

showchar 'Y'
oushu:
mov ax,4c00h
int 21h
code ends
end start