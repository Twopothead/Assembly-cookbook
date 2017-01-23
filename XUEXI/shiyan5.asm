data segment
buf db  80,?,20 dup(?),'$'
score db 80 dup(0)
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
start:
mov ax,data
mov ds,ax
mov  dx, offset buf
mov ah,10
int 21h
;mov ah,9
;int 21h
lea si,buf
add si,2
mov cx,5
mov di,0
shu:call transf
loop shu
exit:
mov cx,20
mov di,2
show:
mov ah,2
mov bx,word ptr score[di]
mov dl,bl
add dl,30h
int 21h
add di,2
loop show

mov dx,offset msg
call showstring
mov dx,offset minmsg
call showstring
mov dx,offset maxmsg
call showstring
mov dx,offset midmsg
call showstring
mov dx,offset rankmsg
call showstring

mov ax,4c00h
int 21h
code ends
end start
