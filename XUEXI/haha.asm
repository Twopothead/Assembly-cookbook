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
hong macro num
if num lt 100
mov ax,ax
else
mov ax,ax
endif
endm
start:
mov ax,data
mov ds,ax
mov ax,stack
mov ss,ax
mov sp,100
mov ax,extra
mov es,ax

;;;;;;
;hong ax
;;;;;;;;;

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
mov ax,Alen
cmp ax,Blen
jb ok
mov flag,1
ok:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov si,Bresultpos
mov di,Aresultpos
mov cx,Blen
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


addplus:mov al,byte ptr es:result[si]
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
mov cx,6
mov bx,0
mov ah,2
showresult:
mov dl,es:result[bx]
;add dl,30h
int 21h
inc bx
loop showresult
;;;;;;;;;;;;;;;;;;;;;
mov ABmaxlen ,5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov es:result[0],'$'
mov cx,ABmaxlen











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ax,4c00h
int 21h
code ends
end start