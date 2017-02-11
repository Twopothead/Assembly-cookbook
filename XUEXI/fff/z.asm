data segment
te db 2000 dup(?)
zz db 2000 dup(?)
MESS2 DB "PLEASE INPUT THE NAME OF THE PATH:",'$'
ERRORME DB "FILE READ ERROR!!!!",'$'
FNI DB 30,?
FN DB 30 DUP(?),'$'
FILHAND1 DW ?
stander db 'A'
FN2 DB 'E:\MUSIC.TXT',0
data ends

CODE SEGMENT  
ASSUME CS:CODE,DS:DATA  
START:MOV AX,DATA
MOV DS,AX
;===================================================read
READ_TXT:

LEA DX,MESS2
MOV AH,09H
INT 21H

LEA DX,FNI
MOV AH,0AH
INT 21H

MOV BL,FNI+1
MOV BH,0
MOV FN[BX],'$'

MOV AH,3DH
MOV AL,0
LEA DX,FN
INT 21H
JC ERROR
MOV FILHAND1,AX

MOV AH,3FH
MOV BX,FILHAND1
MOV CX,2000
LEA DX,TE
INT 21H
jmp c
;=============================
ERROR:
LEA DX,ERRORME
MOV AH,09
INT 21H
JMP READ_TXT
;================================
C:lea si,te-1
lea di,zz

change:
inc si
mov al,[si]
cmp al,'$'
je outt
cmp al,0dh
je hh
cmp al,' '
je xiuzhi
CMP AL,'('
JE JI0
CMP AL,')'
JE JIO2
cmp al,'a'
jae xiaoxie
jmp w
xiaoxie:mov stander,byte ptr 'a'
w:sub al,stander
CMP AL,7
JB DY
CMP AL,13
JA GY


CALL JJ
ADD AL,42
MOV [DI],AL
INC DI
mov [di],byte ptr ' '

inc di
JMP CHANGE

hh:inc si
jmp change

DY:CALL JJ
MOV [DI],BYTE PTR '-'
INC DI
ADD AL,49
MOV [DI],AL
INC DI
mov [di],byte ptr ' '
inc di
JMP CHANGE

GY:CALL JJ
MOV [DI],BYTE PTR '+'
INC DI
ADD AL,35
MOV [DI],AL
INC DI
mov [di],byte ptr ' '
inc di
JMP CHANGE

JI0:MOV DX,1
JMP CHANGE

JIO2:MOV DX,0
JMP CHANGE

JJ:CMP DX,1
JNE CC
DEC DI
MOV [DI],BYTE PTR '.'
INC DI
CC:RET

xiuzhi:
mov [di],byte ptr '~'
inc di
mov [di],byte ptr ' '
inc di
jmp change

outt:mov [di],byte ptr '$'

MOV DX,OFFSET FN2
MOV AH,3CH
XOR CX,CX
INT 21H
MOV BX,AX
MOV AH,40H
MOV DX,OFFSET ZZ
MOV CX,2000
INT 21H
MOV AH,3EH
INT 21H


mov ah,4ch
int 21h
CODE ENDS 
END START
