data segment
  msgname   db 'Input name:$'
  msgphone  db 'Input telephone number:$'
  msgyn   db 'Do you want a telephone number? (Y/N)$'
  tishi   db 'If you want to add,press 1',0DH,0AH,'If you want to search,press2',0DH,0AH,'$'
  huanchong db 16,?, 17 dup(?)
  shows   db 30 dup('0')
  hmtimes db 0
  cxvalue dw 3
  temp db 20 dup('1')
data ends
assume ds:data,cs:code,es:extra,ss:stack
stack segment
 db 80 dup (0)
stack ends
extra segment
    namespace db 800 dup('2')
    numspace  db 800 dup('3')
extra ends
code segment

init macro
  mov ax,data
  mov ds,ax
  mov ax,extra
  mov es,ax
  mov ax,stack
  mov ss,ax
  mov sp,80
endm

finish macro 
    mov ax,4c00h
    int 21h
endm

inputstr macro str
    mov ah,10
    lea dx,str
    int 21h
    mov al,str+1
    add al,2
    mov ah,0
    mov si,ax
    mov bp,ax
    mov str[si],'$'
endm

showstr macro str
  mov ah,9
  lea dx,str+2
  int 21h
endm

showmsg macro msg
  mov ah,9
  lea dx,msg
  int 21h
endm


showchar macro char
 mov ah,2
 mov dl,char
 add dl,30h
 int 21h
endm

store macro dest,cishu
 lea si,huanchong+2
 lea di,dest 
 mov ah,0
 mov al,cishu
 mov cx,16
 mul cx
 add di,ax
 cld
 mov cx,bp
 rep movs byte ptr es:[di],ds:[si]
endm

showch macro ch
 mov ah,2
 mov dl,ch
 int 21h
endm



maopao macro space
local outlp
local inlp
local next
mov cx,3
dec cx
mov si,0
mov bx,0
outlp:mov dx,cx
inlp: mov al,byte ptr es:space[si][bx]
      cmp al,byte ptr es:space[si][bx+16]
      jna next
      xchg al,byte ptr es:space[si][bx+16]
      mov byte ptr es:space[si][bx],al
next:add si,16

     dec dx
     jnz inlp
     loop outlp
endm
exchange macro space 
local ok
push si
push di
push cx
mov si,0
mov bx,0
mov di,0
mov cx,8
ok:
push word ptr es:space[si][bx]
pop word ptr ds:temp[di]
add si,2
add di,2
loop ok

pop cx
pop di
pop si
endm

show macro dest
local ok    ;宏汇编中防止多次存入同一个地址, 用local
local jieshu;宏汇编中防止多次存入同一个地址，用local
mov ah,2
lea di,dest
ok: mov dl,es:[di]
  cmp dl,'$'
  jz jieshu
  int 21h
  inc di
  jmp ok
jieshu: nop
endm

enter macro
mov ah,2
mov dl,0ah
int 21h
endm

display macro
local aga
local agai
mov di,0
mov cx,100
mov ah,2
aga:mov dl,byte ptr es:namespace[di]
inc di
int 21h
loop aga
mov cx,100
mov di,0
agai:mov dl,byte ptr es:numspace[di]
inc di
int 21h
loop agai
endm

displ macro
local aga
local agai
mov di,0
mov cx,3
mov ah,2
mov bx,0
aga:mov dl,byte ptr es:namespace[di][bx]
add di,16
int 21h
loop aga
mov cx,3
mov di,0
agai:mov dl,byte ptr es:numspace[di]
add di,16
int 21h
loop agai
endm




main proc far
start:
init
mov hmtimes,0

next:mov cx,cxvalue
showmsg msgname
enter
inputstr huanchong
showstr huanchong
enter
store namespace,hmtimes
show namespace
enter
jmp phone

jieli:jmp next
phone:showmsg msgphone
enter
inputstr huanchong
showstr huanchong
enter
store numspace,hmtimes
show numspace
enter

inc hmtimes
nop
mov cx,cxvalue
dec cxvalue
loop jieli

display
enter
displ


enter
enter
enter
enter
exchange namespace
mov ah,9
lea dx,temp
int 21h
enter
enter
enter

display

finish
main endp


code ends
end start