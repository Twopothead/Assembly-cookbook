data segment
buf db  80,?,40 dup('$')
score db 80 dup('$')
x dw 0
msg db 'The score between 90 and 100:',0ah,0dh,'$'
minmsg db 'Min is :',0ah,0dh,'$'
maxmsg db 'Max is :',0ah,0dh,'$'
midmsg db 'The middle score is: ',0ah,0dh,'$'
rankmsg db 'Rank ordering:',0ah,0dh,'$'
data ends
stack segment
   db 16 dup(0)
stack ends
assume cs:code,ds:data,ss:stack
code segment
huanhang:
mov ah,02h
mov dl,0ah
int 21h
ret
showstring:
mov ah,09h
int 21h
ret
transf:
push cx
mov cx,2

mov x,0
getnum:
mov al,[si]
and ax,000fh
xchg ax,x
mov dx,10
mul dx
add x,ax
inc si
loop getnum
mov ax,x
mov word ptr score[di],ax
mov x,0
add di,2

pop cx
ret
xianshi:

mov cx,20
mov di,0
show:
mov ah,2
mov bx,word ptr score[di]
mov dl,bl
add dl,30h
int 21h
add di,2
loop show
call huanhang
ret
huanchong:
mov ah,9
lea dx,buf+2
int 21h

ret
bin2dec:
mov ax,bp
mov bl,1
imul bl
aam
add ax,3030h
mov bx,ax
mov ah,2
mov dl,bh
int 21h
mov dl,bl
int 21h
ret
start:
;mov ax,stack
;mov ss,ax
;mov sp,20h
mov ax,data
mov ds,ax
mov  dx, offset buf
mov ah,10
int 21h

      ;MOV AH,2
      ;mov dl,0dh
      ;INT 21H
call huanhang





lea si,buf
add si,2
mov cx,11
mov di,0
shu:call transf
loop shu
exit:


mov bx,0
mov cx,10;循环次数：11-1=10（次）
daxunhuan:mov dx,cx
          mov di,0
       xiaos:
       mov bp,word ptr score[di]
       add di,2
       cmp bp,word ptr score[di]
       jna zhenchang
       xchg bp,word ptr score[di]
     zhenchang:
     mov word ptr score[di-2],bp
     loop xiaos
     mov cx,dx
     loop daxunhuan
     nop
     nop  
;call huiche
;call xianshi
;call huiche
;call xianshi






mov di,0

mov dx,offset msg
call showstring
mov dx,offset minmsg
call showstring
;mov ah,2
mov bx,word ptr score[0]
;mov dl,bl
;add dl,30h
int 21h
mov bp,bx
call bin2dec
call huanhang


mov dx,offset maxmsg
call showstring
;mov ah,2
mov bx,word ptr score[10*2]
;mov dl,bh
;add dl,30h
;int 21h
;mov dl,bl
;add dl,30h
;int 21h
mov bp,bx
call bin2dec
call huanhang

mov dx,offset midmsg
call showstring
;mov ah,2
mov bx,word ptr score[5*2]
;mov dl,bl
;add dl,30h
;int 21h
mov bp,bx
call bin2dec
call huanhang

mov dx,offset rankmsg
call showstring
call xianshi

mov ax,4c00h
int 21h
code ends
end start