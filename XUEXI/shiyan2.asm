data segment 
 	source dw 100 dup(0)
data ends
extra segment
 	dest dw 100 dup(0)
extra ends
assume cs:code,ds:data,es:extra 
code segment
start : mov ax,data
        mov ds,ax
        mov ax,1
        mov bx,0
        mov cx,100
     s: mov word ptr ds:[bx],ax
        inc ax
        add bx,2
        loop s
        nop
        nop
copy: lea si,source
 	  lea di,dest
 	  cld ;方向标志清0
 	  mov cx,100*2
 	  rep movsb ;以字节形式传送cx次
 	  nop
 	  nop
 	  lea si,source 
 	  lea di,dest
 	  cld 
 	  mov cx,100*2
 	  rep cmpsb
 	  jz ok
 	  jmp copy
 ok : lea di,dest
      mov ax,0
   	  mov cx,100
plus: add ax,es:[di]
   	  add di,2
   	  loop plus
	  mov ax,ax  
 	  nop
	  nop
   mov ax,4c00h
   int 21h
code ends
end start