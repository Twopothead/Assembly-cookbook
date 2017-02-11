;=========================================音符宏定义(谈音乐 大调 )
.286
LDO EQU 4571*2        
LDOU EQU 4307*2       
LRE EQU 4072*2        
LREU EQU 3836*2        
LMI EQU 3626*2        
LFA EQU 3418*2        
LFAU EQU 3233*2        
LSO EQU 3043*2        
LSOU EQU 2875*2        
LLA EQU 2711*2
LLAU EQU 2560*2        
LXI EQU 2420*2
DO EQU 4571        
DOU EQU 4307        
RE EQU 4072        
REU EQU 3836        
MI EQU 3626        
FA EQU 3418        
FAU EQU 3233        
SO EQU 3043        
SOU EQU 2875        
LA EQU 2711
LAU EQU 2560        
XI EQU 2420
HDO EQU 4571/2        
HDOU EQU 4307/2        
HRE EQU 4072/2        
HREU EQU 3836/2        
HMI EQU 3626/2        
HFA EQU 3418/2        
HFAU EQU 3233/2        
HSO EQU 3043/2        
HSOU EQU 2875/2        
HLA EQU 2711/2
HLAU EQU 2560/2        
HXI EQU 2420/2
HHDO EQU 4571/4        
HHDOU EQU 4307/4        
HHRE EQU 4072/4        
HHREU EQU 3836/4        
HHMI EQU 3626/4        
HHFA EQU 3418/4        
HHFAU EQU 3233/4        
HHSO EQU 3043/4        
HHSOU EQU 2875/4        
HHLA EQU 2711/4
HHLAU EQU 2560/4        
HHXI EQU 2420/4
;=============================================数据段
DATA SEGMENT

MESS1 DB "CHOOSE THE OPERATION:",0DH,0AH,"      1)READ FROM THE TXT",0DH,0AH,"      2)INPUT THE MUSIC NOW",0DH,0AH,'$'
MESS2 DB "PLEASE INPUT THE NAME OF THE PATH:",'$'
MESS3 DB "PLEASE INPUT THE SPEED OF PLAYING MUSIC:",'$'
MESS4 DB "PLEASE INPUT THE TAP:",'$'
MESS5 DB "PLEASE INPUT THE DIAOZI:",'$';(~~~~~~~~~~~~~~~~~~~~~~~~~~~~~)
MESS6 DB "PLEASE INPUT THE MUSIC(Q IS THE END):",0DH,0AH,'$'
MESS7 DB "PRESS ANY KEY TO PLAY MUSIC:",'$'
ERRORME DB "FILE READ ERROR!!!!",'$'
FNI DB 30,?
FN DB 30 DUP(?),'$'
FN2 DB 'E:\MUSIC.TXT',0
FILHAND1 DW ?
PLAY_SPEED DW 0
TAP DB ?,?
MUSIC   DW LDO,LDOU,LRE,LREU,LMI,LFA,LFA,LFAU,LSO,LSOU,LLA,LLAU,LXI,LXI;
      DW DO,DOU,RE,REU,MI,FA,FA,FAU,SO,SOU,LA,LAU,XI,XI;28
      DW HDO,HDOU,HRE,HREU,HMI,HFA,HFA,HFAU,HSO,HSOU,HLA,HLAU,HXI,HXI;
       DW HHDO,HHDOU,HHRE,HHREU,HHMI,HHFA,HHFA,HHFAU,HHSO,HHSOU,HHLA,HHLAU,HHXI,HHXI
TE DB 2000 DUP(' '),0
FREQ DB 2000 DUP(?)
TIME DB 2000 DUP(?)
JIANPU DB 80
DATA ENDS

;============================================段，蜂鸣器初始化
CODE SEGMENT  
ASSUME CS:CODE,DS:DATA  
START:
MOV AX,DATA
MOV DS,AX
;===========================================清屏
MOV AH,00H
MOV AL,03H
INT 10H
;=========================================初始提示信息（选择操作）
LEA DX,MESS1
MOV AH,09H
INT 21H
;=========================================对操作作出判断(添加弹奏音乐的选项，提示信息要修改)
MOV AH,01H
INT 21H

CMP AL,31H
JE READ_TXT
CMP AL,32H
JE MUSIC_INPUT
JMP START
;=========================================输入文件名FN,读文件，FN所指文件送到TE
READ_TXT:
CALL NEW_LINE

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
CALL NEW_LINE
JMP PLAY_MUSIC

ERROR:
CALL NEW_LINE
LEA DX,ERRORME
MOV AH,09
INT 21H
JMP READ_TXT
;=======================================乐谱输入(TE中为ASICC码，输出时再转换)
MUSIC_INPUT:
CALL NEW_LINE
;=======================================输入拍子
LEA DX,MESS4
MOV AH,09H
INT 21H
CALL NEW_LINE
I:MOV AH,01H
INT 21H
CMP AL,30H
JB I
CMP AL,39H
JA I
SUB AL,30H
MOV TAP,AL
MOV DL,32

CALL PRINT

J:MOV AH,01H
INT 21H
CMP AL,30H
JB J
CMP AL,39H
JA J
SUB AL,30H
MOV TAP+1,AL
LEA BX,TE

CALL NEW_LINE
;====================================输入到TE
LEA DX,MESS6
MOV AH,09
INT 21H

MOV DL,TAP+1
MOV CX,0
MOV MESS1,DL
SUB MESS1,1

INPUT:MOV AH,01H
INT 21H
CMP AL,0DH
JE NL
CMP AL,32
JE SPACE
CMP AL,'q';==================大小写不可变
JE INPUT_END
CMP AL,'Q'
JE INPUT_END
CMP AL,'='
JE COUNTER2
CMP AL,08H
JE BACK
CMP AL,'@'
JE COUNTER2
DEAL:MOV [BX],AL
INC BX
JMP INPUT

BACK:DEC BX
CMP AL,' '
JE DISA
CMP AL,'='
JE DISA
B:
JMP INPUT

DISA:DEC CX
JMP B

NL:CALL NEW_LINE
JMP INPUT

SPACE:CMP CL,MESS1
JE ADD1
INC CX
JMP DEAL

ADD1:MOV [BX],BYTE PTR '|'
INC BX
PUSHA
MOV DL,08H
CALL PRINT
MOV DL,'|'
CALL PRINT
POPA
MOV CX,0
JMP INPUT

BACK2:PUSHA
MOV DL,08H
CALL PRINT
POPA
JMP INPUT

COUNTER2:
CMP CL,MESS1
JE BACK2
INC CX
JMP DEAL
;==================================把TE的内容转到FN2所指TXT里
INPUT_END:
CALL NEW_LINE
MOV [BX],BYTE PTR '$'
MOV DI,BX
PUSHA
MOV DX,OFFSET FN2
MOV AH,3CH
XOR CX,CX
INT 21H
MOV BX,AX
MOV AH,40H
MOV DX,OFFSET TE
MOV CX,DI
INT 21H
MOV AH,3EH
INT 21H
POPA
JMP PLAY_MUSIC
;=======================================准备输出音乐
PLAY_MUSIC:
;=======================================播放速度输入
LEA DX,MESS3
MOV AH,09H
INT 21H
SPEED_INPUT:MOV AH,01H
INT 21H
CMP AL,0DH
JE PLAY
SUB AL,30H
MOV BX,PLAY_SPEED
MOV CH,0
MOV CL,AL
MOV AX,10
MUL BX
ADD AX,CX
MOV PLAY_SPEED,AX
JMP SPEED_INPUT

;=====================================音乐转换 
PLAY:

MOV DX,0
MOV AX,1091
MOV BX,PLAY_SPEED
DIV BX
MOV PLAY_SPEED,AX

CALL NEW_LINE
LEA DX,MESS7
MOV AH,09H
INT 21H
MOV AH,01H
INT 21H
MOV AH,00H
MOV AL,03H
INT 10H
CALL NEW_LINE


LEA DI,TE-1
LEA BX,FREQ
LEA SI,TIME
MOV CX,1
MOV DX,PLAY_SPEED
MOV MESS2,BYTE PTR 1

CHANGE:
INC DI
MOV AL,[DI]
CMP AL,'$'
JE B_PLAY1
CMP AL,'~'
JE XIUZHI
CMP AL,'='
JE SXIUZHI
CMP AL,'.'
JE JJ
CMP AL,'|'
JE NEXT
CMP AL,32
JE NEXT
CMP AL,'+'
JE HT
CMP AL,'-'
JE LLT
CMP AL,'#'
JE JING
CMP AL,'@'
JE YC
SUB AL,42
ADD AL,AL
MOV [BX],AL
INC BX
JMP CHANGE

XIUZHI:
MOV [SI],DX
INC SI
INC DI
MOV [BX],BYTE PTR 80
INC BX
JMP CHANGE

SXIUZHI:
MOV [SI],DX
ADD [SI],DX
INC SI
INC DI
MOV [BX],BYTE PTR 80
INC BX
JMP CHANGE

B_PLAY1:JMP B_PLAY

JJ:INC CX
JMP CHANGE

HT:INC DI
MOV AL,[DI]
SUB AL,35
ADD AL,AL
MOV [BX],AL
INC BX
JMP CHANGE

LLT:INC DI
MOV AL,[DI]
SUB AL,49
ADD AL,AL
MOV [BX],AL
INC BX
JMP CHANGE

NEXT:MOV AX,DX
DIV CL
A1:CMP MESS2,1
JE POINT
SHL AX,1
SHR MESS2,1
JMP A1
POINT:MOV [SI],AL
INC SI
LOOP POINT
MOV CX,1
JMP CHANGE

JING:DEC BX
ADD [BX],BYTE PTR 1
INC BX
JMP CHANGE

YC:SHL MESS2,1
JMP CHANGE
;===========================
B_PLAY:

MOV AX,DX
DIV CL
POINT2:MOV [SI],AL
INC SI
LOOP POINT2
MOV CX,1

MOV [BX],BYTE PTR 100


;======================================MUSIC
MOV DI,PLAY_SPEED
MOV CX,0
CALL BEEP

LEA BX,FREQ
LEA SI,TIME
SOUND:MOV AL,[BX]
MOV JIANPU,AL
CMP AL,100
JE EXIT
LEA DI,MUSIC
MOV AH,0
ADD AL,AL
ADD DI,AX
MOV CX,[DI]
MOV DL,[SI]
MOV DH,0
MOV DI,DX
CMP AL,160
JE D
CALL BEEP
EEE:INC BX
INC SI
JMP SOUND

D:CALL DELAY
JMP EEE
;=========================EXIT
EXIT:
MOV AH,4CH
INT 21H
;===================================输出PRINT(入口DL)
PRINT:
PUSHA
MOV AH,02H
INT 21H
POPA
RET
;====================================换行
NEW_LINE:
MOV DL,0DH
CALL PRINT
MOV DL,0AH
CALL PRINT
RET
;=================================================音频+延时  BX频率  DI时间（）
BEEP:
PUSHA
MOV AL,0B6H
OUT 43H,AL
MOV AX,CX
OUT 42H,AL
MOV AL,AH
OUT 42H,AL
IN AL,61H
OR AL,3
OUT 61H,AL
POPA

CALL DELAY
IN AL,61H
AND AL,0FCH
OUT 61H,AL

RET
;===========================延时模块;DI IS THE INPUT MSEC
DELAY:PUSHA
MOV AH,0
INT 1AH
ADD DX,DI
MOV BX,DX

DRAW:PUSHA
MOV AL,JIANPU
CMP AL,80
JE STT
CMP AL,14
JB DY
CMP AL,27
JA ZY
SUB AL,12
JMP YYY

QQQ:MOV DL,' '
CALL PRINT
POPA

DELAY_D:INT 1AH
CMP DX,BX
JA O
JNE DELAY_D

O:
POPA
RET

DY:MOV DL,'-'
CALL PRINT
MOV AH,0
MOV BL,2
DIV BL
MOV CH,AH
ADD AL,31H
MOV DL,AL
CALL PRINT
CMP CH,0
JE QQQ
MOV DL,'#'
CALL PRINT
JMP QQQ

ZY:MOV DL,'+'
CALL PRINT
SUB AL,26
YYY:MOV AH,0
MOV BL,2
DIV BL
MOV CH,AH
ADD AL,30H
MOV DL,AL
CALL PRINT
CMP CH,0
JE QQQ
MOV DL,'#'
CALL PRINT
JMP QQQ

STT:MOV DL,'~'
CALL PRINT
MOV DL,' '
CALL PRINT
JMP QQQ
;==========================结束
CODE ENDS 
END START