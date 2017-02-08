data segment
  msgname db 'Input name:$'
  msgphone db 'Input telephone number:$'
  msgyn db 'Do you want a telephone number? (Y/N)$'
  temp dw 01h,02h
  
  haha db 'Student'
  teletable db ?
  ;changdu equ($-haha)
  huanchong db 20,?, 40 dup('$')
  shows db 20 dup('0')
  tishi DB 'If you want to add,press 1',0DH,0AH,'If you want to search,press2',0DH,0AH,'$'



data ends
assume ds:data,cs:code,es:extra

extra segment
  namespace db 100 dup('0')
  numspace db 100 dup('0')
extra ends
code segment

hehe macro haha
	mov bx,offset haha
	mov bp,bx
	mov bx,seg haha
	mov es,bx
	mov ah,13h
	mov al,1
	;mov bl,8dh;color
	mov bl,01001010b
	mov bh,0
	mov cx,7
	int 10h
endm 
enter macro
	mov ah,2
	mov dl,0dh
	int 21h
	mov dl,0ah
	int 21h
	
endm
showstr macro str
	lea dx, str
	mov ah,9
	int 21h
endm
cls macro
	mov ah,06h
	mov al,0
	mov bh,0fh
	mov ch,0
	mov cl,0
	mov dh,60
	mov dl,80
	int 10h
	mov dx,0
	mov ah,2

	int 10h
endm 
cursor macro row,column
	mov ah,2
	mov dh,row
	mov dl,column
	mov bh,0
	int 10h
endm
inputstr macro str
    mov ah,10
    lea dx,str
    int 21h
endm
bell macro
	mov ah,2
	mov dl,07h
	int 21h
endm
showchar macro char
    mov ah,2
    mov dl,char
    add dl,30h
    int 21h
endm
finish macro 
mov ax,4c00h
int 21h
endm


store macro dest
	lea si,huanchong+2
	lea di,dest
	cld
	mov cx,20
	rep movs byte ptr es:[di],ds:[si]
endm

show macro 

  lea di,namespace

		mov ah,2	
		mov cx,20
	mov dl,byte ptr es:[di]
	int 21h
	inc di

	mov dl,byte ptr es:[di]
	int 21h
	inc di
	
	mov dl,byte ptr es:[di]
	int 21h
	inc di
	mov cx,20
;s:	mov dl,byte ptr es:[di]
;	int 21h
;	inc di
;	loop s
;宏里面似乎不能用loop

	;loop xian
 endm


sort macro

endm
laji proc
cls
cursor 0,0
;call input
;hehe haha
showstr msgname
enter
showstr msgphone
enter
showstr msgyn
enter
inputstr huanchong
enter
showstr huanchong
laji endp





input macro
showstr msgname
enter
inputstr huanchong
store namespace
enter
;showstr namespace
endm

init macro
	mov ax,data
	mov ds,ax
	mov ax,extra
	mov es,ax
endm

start:

main proc far
init
;input
showstr msgname
enter
inputstr huanchong
store namespace
enter

show
finish
main endp


code ends
end start