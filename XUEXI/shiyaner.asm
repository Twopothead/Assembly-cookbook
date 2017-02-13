data segment 
  msg  db '1+2+3+4+...+100=',0ah,0dh,'$'
  source db 100 dup(0)
data ends
extra segment
  dest db 100 dup(0)
extra ends
stack segment 
   db 30 dup(0)
stack ends
assume cs:code,ds:data,es:extra,ss:stack 
code segment
showmsg proc           ;showmsg子程序调用dos9号中断，显示字符串
    mov ah,9
    mov dx,offset msg  ;AH=9,DS:DX=字符串地址
    int 21h
  ret
showmsg endp
enter proc            ;enter子程序显示回车字符
    mov ah,2          ;2号功能是单字符显示输出
    mov dl,0dh        ;回车ASCII码送dl
    int 21h
  ret
enter endp
start : mov ax,stack
        mov ss,ax
        mov sp,30     ;设栈顶指针
        mov ax,extra
        mov es,ax
        mov ax,data
        mov ds,ax
        call showmsg
        call enter
        mov bx,0
        mov al,1
        mov cx,100
    s : mov source[bx],al
         inc al
         inc bx
        loop s
  copy: lea si,source
        lea di,dest
        cld
        mov cx,100
        rep movsb

        lea si,source
        lea di,dest
        cld
        mov cx,100
        repz cmpsb
        cmp cx,0
        jnz copy
        mov cx,100
        xor ax,ax
        xor bx,bx
        mov di,0
        plus:mov bl,byte ptr es:dest[di]
        add ax,bx
        inc di
        loop plus
        mov bp,10
        xor bx,bx
        xor cx,cx
  bin2decimal  :mov dx,0
                inc cx
        idiv bp
        push dx
        cmp ax,0
        jnz bin2decimal
        mov ah,2
  again:    pop dx
            add dl,30h
            int 21h
          loop again    
  mov ax,4c00h
  int 21h
code ends
end start