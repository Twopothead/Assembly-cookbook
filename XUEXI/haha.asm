data segment
Alen dw 0
Blen dw 0
chuanlen dw 0
huanchong db 49,?,49 dup(0),'$'
data ends
assume ds:data,es:extra,ss:stack,cs:code
stack segment
 dw 50 dup(0)
stack ends
extra segment
 A db 20 dup(0),'$'
 B db 20 dup(0),'$'
extra ends
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
start:
mov ax,data
mov ds,ax
mov ax,stack
mov ss,ax
mov sp,100
mov ax,extra
mov es,ax
mov ah,10
lea dx,huanchong
int 21h
enter

xor ax,ax
mov al,byte ptr huanchong[1]
mov chuanlen,ax 

mov cx,chuanlen
lea si,huanchong[2]
xunhuan:cmp byte ptr [si],30h
		jb tiaochu
loop xunhuan
tiaochu:
mov ax,chuanlen
sub ax,cx
mov Alen,ax


xor ax,ax
mov al,byte ptr huanchong[1]
mov Alen,ax

mov cx,Alen
mov bx,Alen
inc bx
lea si,huanchong[bx]
lea di,A
again:mov al,byte ptr ds:[si]
mov byte ptr es:[di],al
dec si
inc di
loop again
enter
mov bx,0
mov cx,20
mov ah,2
s:mov dl,byte ptr es:A[bx]
int 21h
inc bx
loop s
enter
mov ax,4c00h
int 21h
code ends
end start