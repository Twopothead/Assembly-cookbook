data segment 
  source dw 100 dup(0)
data ends
extra segment
  dest dw 100 dup(0)
extra ends
stack segment 
   db 30 dup(0)
stack ends
assume cs:code,ds:data,es:extra,ss:stack 
code segment
start : mov ax,stack
        mov ss,ax
        mov sp,30 
        mov ax,data
        mov ds,ax
        mov ax,1
        mov bx,0
        mov cx,100
     s: mov word ptr ds:[bx],ax
        inc ax
        add bx,2
        loop s
 copy:  lea si ,source
       mov ax,37h  ;改为075a:0037;075a:0000里似乎有重要东西
       ;(这一行如果是mov ax,36h都将破坏重要数据，屏幕无显示)
       mov di,ax
       cld 
       mov cx,100*2
       rep movsb
       nop
       nop
       lea si,source
       mov ax,37h
       mov di,ax
       cld
       mov cx,100
       rep cmpsw
       jnz copy
       mov ax,0

      mov ax,37h
      mov di,ax
      mov ax,0
      mov cx,100
      nop
      nop
 plus:     add ax,es:[di]
           add di,2
          loop plus
      mov dx,0
      mov bx,10
      div bx;;;;;;ax=01f9(商505) dx=0(0)
      push dx
      div bx;;;;;;ax=0032(商50)  dx=5(余5)
      push dx
      div bx;;;;;;ax=0005(商5)  dx=0(余0)
      push dx
      push ax
      nop 
      mov cx,4
show:pop dx
     add dx ,30h
     mov ax,0200h
     int 21h
     loop show
  mov ax,4c00h
  int 21h
code ends
end start