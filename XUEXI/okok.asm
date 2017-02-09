data segment
  msgname 	db 'Input name:$'
  msgphone 	db 'Input telephone number:$'
  msgyn 	db 'Do you want a telephone number? (Y/N)$'
  tishi 	db 'If you want to add,press 1',0DH,0AH,'If you want to search,press2',0DH,0AH,'$'
  huanchong db 10,?, 11 dup(?)
  shows 	db 30 dup('0')
data ends
assume ds:data,cs:code,es:extra
extra segment
		namespace db 100 dup('2')
  		numspace  db 100 dup('3')
extra ends
code segment

init macro
	mov ax,data
	mov ds,ax
	mov ax,es
	mov es,ax
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

showchar macro char
 mov ah,2
 mov dl,char
 add dl,30h
 int 21h
endm

store macro dest
 lea si,huanchong+2
 lea di,dest
 cld
 mov cx,bp
 rep movs byte ptr es:[di],ds:[si]
endm

maopao macro
endm

show macro dest
mov ah,2
lea di,dest
ok:	mov dl,es:[di]
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

main proc far
start:
init
inputstr huanchong
showstr huanchong
enter
store namespace
show namespace


finish
main endp

code ends
end start