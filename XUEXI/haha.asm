data segment
Alen dw 0
Blen dw 0
ABmaxlen dw 0
chuanlen dw 0
opresultpos dw 0
Bresultpos dw 1
Aresultpos dw ?
flag db 0
huanchong db 49,?,49 dup(0),'$'
data ends
assume ds:data,es:extra,ss:stack,cs:code
stack segment
 dw 50 dup(0)
stack ends
extra segment
 result db 20 dup(0),'$'
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
showchar macro char
mov ah,2
mov dl,char
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
mov bx,chuanlen
inc bx
lea si,huanchong[bx]
lea di,result
again:mov al,byte ptr ds:[si]
mov byte ptr es:[di],al
dec si
inc di
loop again
enter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov bx,0
mov cx,20
mov ah,2
s:mov dl,byte ptr es:result[bx]
int 21h
inc bx
loop s
enter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov bx,1
xor cx,cx
mov cx,chuanlen
xunhuan:mov dl,byte ptr es:result[bx]
cmp dl,30h
jb tiaochu
inc bx
loop xunhuan
tiaochu:
mov ax,chuanlen
sub al,cl
mov Blen,ax
showch al
enter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ax,chuanlen
sub ax,Blen
sub ax,2
mov Alen,ax
showch al
enter
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;mov ax,Blen
;showch al
mov si,Blen
inc si
mov al,byte ptr es:result[si]
mov opresultpos,si
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inc si 
mov Aresultpos,si
showchar al
enter
;;;;;;;;;;;;;;;;;;;;;;;;;;
mov si,opresultpos
mov byte ptr es:result[si],0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;mov ax,Alen
;cmp ax,Blen
;jb ok
;mov flag,1
;ok:
;;;;;;;;;;;;;;;;;
;怕的就是A的长度B的长度长
;例如678909+999=809976
mov ax,Alen
cmp ax,Blen
ja findmax
mov ax,Blen
findmax:
mov ABmaxlen,ax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov si,Bresultpos
mov di,Aresultpos
;mov cx,Blen
mov cx,ABmaxlen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ax,si
showch al
mov ax,di
showch al
mov ax,cx
inc cx
showch al
enter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov flag,0
addplus:mov al,byte ptr es:result[si]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmp flag,1
jz zhiling
cmp al,30h
jnb notoperator
mov flag,1
zhiling:
mov al,'0'
notoperator:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
and al,11001111b
and byte ptr es:result[di],11001111b
popf
;;;;;;;;;;;;;;

;;;;;;;;;;;;;
adc al,byte ptr es:result[di]
cmp al,10
jb bujinwei
sub al,10
stc
pushf
jmp biaozhi
bujinwei:
clc
pushf
biaozhi:
or  al,00110000b
mov byte ptr es:result[si],al
showchar al
inc si
inc di
loop addplus
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
enter
;mov cx,Blen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;加一个结束符号
mov bx,ABmaxlen+1
mov byte ptr es:result[bx],'$'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov cx,ABmaxlen+2
mov bx,0
mov ah,2
showresult:
mov dl,es:result[bx]
;add dl,30h
int 21h
inc bx
loop showresult
;;;;;;;;;;;;;;;;;;;;;
;;;;;;;mov ABmaxlen ,5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;把=号改为$
mov es:result[0],'$'
;;;;;;;;;;;;;;;;;;;;;;;;
enter
mov si,2
mov di,ABmaxlen
mov cx,ABmaxlen+1
chuansong:mov al,es:result[di]
		 mov huanchong[si],al
		inc si
		dec di
loop chuansong
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ah,9
lea dx,huanchong[2]
int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ax,4c00h
int 21h
code ends
end start