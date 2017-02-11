DISPLAY   MACRO b 
          LEA DX,b 
          MOV AH,9 
          INT 21H 
          ENDM 

;*********************** 

DATA      SEGMENT 

LIST      DB 0DH,0AH,'a: <<Liang Zhi Lao Hu>>'                   
          DB 0DH,0AH,'b: Keyboard Piano'  
          DB 0DH,0AH,'q: exit' 
          db 0dh,0Ah,'$' 

MUS_FREG1 dw 263,294,330,263, 263,294,330,263, 330,349,392, 330,349,392,  392,440,392,349,330,263,  392,440,392,349,330,263, 263,196,263, 263,196,263, 0      

MUS_TIME1 dw 10 dup(20), 40, 2 dup(20), 40, 4 dup(10), 20, 20, 4 dup(10), 20, 20, 2 dup(20), 40, 2 dup(20), 40

table   dw 262      ;C
        dw 294      ;D
        dw 330      ;E
        dw 349      ;F
        dw 392      ;G
        dw 440      ;A
        dw 494      ;B
        dw 523      ;C      

DATA      ENDS 
;***********************************************************

STACK     SEGMENT

STACK     ENDS


CODE      SEGMENT                                                
          ASSUME DS:DATA,CS:CODE 
START: 
          MOV AX,DATA
          MOV DS,AX
          MOV AH, 0 
          MOV AL,0 




INPUT:                     ;控制播放的主程序

          DISPLAY LIST

          MOV AH,01H
          INT 21H

Q:
          CMP AL,'q'
          JZ RETU

A:      
          CMP AL,'a'
          JNZ B
          lea SI,MUS_FREG1
          lea BP,MUS_TIME1
          CALL MUSIC
          JMP INPUT

B:      
          CMP AL,'b'
          JNZ INPUT
          CALL PIANO
          JMP INPUT


RETU:                                                             
          MOV AH,4CH
          INT 21H
;********************************************* 通用发声程序                  
soundf PROC NEAR 
          PUSH AX 
          PUSH BX 
          PUSH CX 
          PUSH DX 
          PUSH DI 
          MOV AL,0B6H 
          OUT 43H,AL 
          MOV DX,12H 
          MOV AX,348ch                                           
          DIV DI 
          OUT 42H,AL 
          MOV AL,AH 
          OUT 42H,AL 
          IN AL,61H 
          MOV AH,AL 
          OR AL,3 
          OUT 61H,AL 

WAIT1:    
          MOV CX,3314                                          
          call waitf 
DELAY1:   
          DEC BX 
          JNZ WAIT1 
          MOV AL,AH 
          OUT 61H,AL 
          POP DI 
          POP DX 
          POP CX 
          POP BX                                                 
          POP AX 
          RET 


soundf ENDP 
;******************************************** 
waitf proc near 
          push cx 
waitf1: 
          in al,61h 
          and al,10h 
          cmp al,ah                                              
          je waitf1 
          mov ah,al 
          loop waitf1 
          pop cx 
          ret 
waitf endp 
;********************************************* 音乐播放
MUSIC     PROC NEAR 
          PUSH DS 
          SUB AX,AX                                              
          PUSH AX                                     
FREG:     
          MOV DI,[SI] 
          CMP DI,0
          JE END_MUS 
          MOV BX,[BP] 
          CALL soundf 
          ADD SI,2 
          ADD BP,2 
          JMP FREG                                               
END_MUS:  

          RET

MUSIC    ENDP 

;********************************************* 键盘钢琴
PIANO PROC NEAR
        PUSH DS  
        SUB AX,AX                                              
        PUSH AX 

read_key:
        mov ah,0
        int 16H
        cmp al,0dh
        je exit

        mov bx,offset table
        cmp al,'1'
        jb read_key
        cmp al,'8'
        ja read_key
        and ax,0fh
        sub ax,1
        shl ax,1
        mov si,ax
        mov di,[bx][si]
        mov bx,20
        call soundf
        jmp read_key

exit:
        ret

PIANO   ENDP

CODE      ENDS 
          END START
