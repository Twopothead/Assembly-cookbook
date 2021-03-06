data segment
  msgname          db 'Input name:$'
  msgphone         db 'Input telephone number:$'
  msgtishi         db 'If you want to add,press 1',0DH,0AH,'If you want to search,press2',0DH,0AH,'$'
  msgyn            db 'Do you want to kill this process?(y/n)',0dh,0ah,'$'
  huanchong        db 16,?, 17 dup(?)
  shows            db 30 dup('0')
  hmtimes          db 0
  cxvalue       dw 3
  temp             db 20 dup('1')
  msg1             db 'name:$'
  msg2             db 'telephone number:$'
  msgkongge        db  5 dup(32),'$'
  pos           dw 0
  total         dw 3 
  zhaodaoweizhi dw 0
  ;开始一次性输入3个人，如果有新增的，total会加
data ends
assume ds:data,cs:code,es:extra,ss:stack
stack segment
    db 200 dup (0)
stack ends
extra segment
    namespace db 800 dup('0')
    numspace  db 800 dup('0')
extra ends
code segment

init macro
    mov ax,data
    mov ds,ax
    mov ax,extra
    mov es,ax
    mov ax,stack
    mov ss,ax
    mov sp,200
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
local xunhuan
local huan
local jishu
local budeng
local compare
local jieliinlp
local jielioutlp
  ;mov cx,3
      mov cx,total
      dec cx
      mov si,0
      mov bx,0
      mov dx,cx
outlp:mov dx,cx
      mov bx,0
      mov si,0
inlp: mov al,byte ptr es:space[si][bx]
      cmp al,byte ptr es:space[si][bx+16]
      jb next
      ja huan  
      push cx
      push bx
jishu:inc bx
      mov al,byte ptr es:space[si][bx]
      cmp al,'$'
      jnz jishu
      mov cx,bx
      mov bx,0
compare:    mov al,byte ptr es:space[si][bx] 
            cmp al,byte ptr es:space[si][bx+16] 
            jnz budeng
            inc bx 
            loop compare
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;完全匹配      
      mov bx,0
      pop bx
      pop cx
      jmp next
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;接力站
jieliinlp:jmp inlp
jielioutlp:jmp outlp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;接力站
   budeng : pop bx
            pop cx
            jb next 
            ja huan
   huan: exchange namespace
         exchange numspace
      ;;;;;;xchg al,byte ptr es:space[si][bx+16]
      ;;;;;;mov byte ptr es:space[si][bx],al
  next:  add si,16
         dec dx
         cmp dx,0
        jnz jieliinlp
        loop jielioutlp
endm

exchange macro space
local xunhuan
     push cx
     push bx
                mov cx,8
       xunhuan: push word ptr es:space[si][bx+16]
                push word ptr es:space[si][bx]
                pop word ptr es:space[si][bx+16]
                pop word ptr es:space[si][bx]
                add bx,2
       loop xunhuan
      pop bx
      pop cx
endm

show macro dest
local ok    ;宏汇编中防止多次存入同一个地址, 用local
local jieshu;宏汇编中防止多次存入同一个地址，用local
   mov ah,2
   lea di,dest
ok:mov dl,es:[di]
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
    mov bx,0
aga:mov dl,byte ptr es:namespace[di][bx]
    inc di
    int 21h
    loop aga
    mov cx,100
    mov di,0
agai:mov dl,byte ptr es:numspace[di][bx]
    inc di
    int 21h
    loop agai
endm

restoreshowname macro  
local again
    push di
    push cx
    mov cx,8
    mov di,0
again:
    push word ptr es:namespace[di][bx]
    pop word ptr ds:temp[di]
    add di,2
    loop again
    mov ah,9
    mov dl,offset temp
    int 21h
    pop cx
    pop di
endm

restoreshownum macro 
local again
push di
push cx
    mov cx,8
    mov di,0
  again:
    push word ptr es:numspace[di][bx]
    pop word ptr ds:temp[di]
    add di,2
  loop again
    mov ah,9
    mov dl,offset temp
    int 21h
pop cx
pop di
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
agai:mov dl,byte ptr es:numspace[di][bx]
    add di,16
    int 21h
    loop agai
endm

showlist macro 
local again
      enter
      enter
      mov bx,0
      mov cx,total
      ;mov cx,3
    again:
      showmsg msg1
      restoreshowname  pos
      showmsg msgkongge
      showmsg msg2
      restoreshownum 
      enter
      add bx,16
      mov pos,bx
    loop again
endm

search macro
local aga
local again
local ok
local s
local xunhuan
local success
local zhaodao
    inputstr huanchong
    showstr huanchong
enter 
enter
    xor dx,dx
    mov dl,huanchong[1]
    mov bp,dx
    mov di,0
    mov cx,100
    mov ah,2
aga:mov dl,byte ptr es:namespace[di]
    inc di
    int 21h
loop aga
    mov di,0
    ;mov cx,3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov cx,total
again:mov dl,byte ptr es:namespace[di]
    mov ah,2
    int 21h
    cmp dl,byte ptr huanchong[2]
    jz ok
    add di,16
loop again

ok:mov zhaodaoweizhi,di
    push di;;;;;;;这句话很蛋疼
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;第一个字母相同后匹配后面的字母
push bx
;;;;;;;;;;;;;;;;push di
push cx
mov bx,0
mov cx,bp
lea si,namespace
add di,si
lea si,huanchong
add si,2
repz cmpsb
;;mov dl,byte ptr es:namespace[di][bx]
;;cmp dl,byte ptr huanchong[bx+2]
cmp cx,0
jz zhaodao
pop cx
;;;;;;;;;;;;;;;;pop di
pop bx
pop di
add di,16
dec cx
jmp again
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;匹配成功，跳出
zhaodao:
        pop cx
        pop bx
        pop di

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    enter
    mov cx,8
    mov bx,0
s:
    push word ptr es:namespace[di][bx]
    pop word ptr ds:temp[bx]
    add bx,2
loop s
    showmsg temp
    showmsg msgkongge
  ;;;;;;;;;;;pop di
mov di,zhaodaoweizhi
    mov cx,8
    mov bx,0
xunhuan:
    push word ptr es:numspace[di][bx]
    pop word ptr ds:temp[bx]
    add bx,2
loop xunhuan
showmsg temp
endm

main proc far
start:
      init
      mov hmtimes,0
next: mov cx,cxvalue
      showmsg msgname
      enter
      inputstr huanchong
      showstr huanchong
      enter
      store namespace,hmtimes
;;;;show namespace
      enter
      jmp phone
jieli:
      jmp next
phone:
      showmsg msgphone
      enter
      inputstr huanchong
      showstr huanchong
      enter
      store numspace,hmtimes
;;;;show numspace
      enter
      inc hmtimes
      mov cx,cxvalue
      dec cxvalue
      loop jieli
      enter
    display
      maopao namespace
    display
      showlist
fenzhi:  enter
      showmsg msgtishi
      mov ah,1
      int 21h
      cmp al,'1'
      jz tianjia
      cmp al,'2'
      jz jielitwo
tianjia:
      mov cxvalue,1
      inc total
      jmp jieli
      jielitwo:jmp sousuo
      showlist
sousuo:
      enter
      search
      enter
      showmsg msgyn
      enter
      mov ah,1
      int 21h
      cmp al,'y'
      jz jieshule
      jmp fenzhi
jieshule:      finish
main endp
code ends
end start