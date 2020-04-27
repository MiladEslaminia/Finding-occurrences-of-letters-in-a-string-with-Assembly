;*******************************Milad Eslaminia 810185259*****************************************
PAGE 300,310
TITLE Homework 1, finding occurrences of 'AX' , 'BX' & 'CX' in dting 'AZAXBCXXCVZXFCYRYAAXTAXYDDYTBXCXCDXAXXXBXCX'
;**********************************************************
;		DEFINING STACK SEGEMENT
;**********************************************************

STSEG   SEGMENT STACK 'STACK'
	DW 32 DUP(0)
STSEG   ENDS
;*********************************************************
;		DEFINING DATA SEGEMENT
;*********************************************************
DSEG    SEGMENT
STRING DB 'AZAXBCXXCVZXFCYRYAAXTAXYDDYTBXCXCDXAXXXBXCX','$'
AN		DB ?
BN		DB ?
CN		DB ?
N0	DB 'Combination','$'
N1	DB '1)AX:  ','$'       ;messages to be displayed on monitor
N2	DB '2)BX:  ','$'
N3	DB '3)CX:  ','$'
N4      DB 'Press space key to exit!','$'
DSEG    ENDS
;********************************************************
;		CODE SEGEMENT STARTS HERE!
;********************************************************
CSEG    SEGMENT
START   PROC FAR
	ASSUME CS:CSEG, DS:DSEG, SS:STSEG
	MOV AX,DSEG	
	MOV DS,AX	

;***********************************************************
	MOV [AN],00H
	MOV [BN],00H
	MOV [CN],00H
	LEA SI,STRING

SLOOP:                                     ;main LOOP for scaning the string char by char

SEARCH_AX:                                 
	MOV AL,[SI]
	CMP AL,'$'                         ;looking for AX occurance using CMP 
	JE FINISH
	CMP AL,'A'
	JNE SEARCH_BX
	INC SI
	MOV AL,[SI]
	CMP AL,'A'
	JE SLOOP
	CMP AL,'X'
	JNE SEARCH_BX
	INC [AN]
	INC SI
	JMP SLOOP

SEARCH_BX:                                 ;looking for BX occurance 

	CMP AL,'B'
	JNE SEARCH_CX
	INC SI
	MOV AL,[SI]
	CMP AL,'A'
	JE SEARCH_BX
	CMP AL,'X'
	JNE SEARCH_CX
	INC [BN]
	INC SI
	JMP SLOOP

SEARCH_CX:                                    ;looking for CX occurance 

        CMP AL,'C'
	JNE JUMP_SLOOP
	INC SI
	MOV AL,[SI]
	CMP AL,'A'
	JE SEARCH_CX	
	CMP AL,'X'
	JNE SLOOP
	INC [CN]

JUMP_SLOOP:

	INC SI
	JMP SLOOP

FINISH:

;Using interrupt 21H & display message on screen
MOV AH,9H       
	LEA DX,STRING  
	INT 21H         
	MOV AH,0EH    
	MOV AL,0AH      
	INT 10H      
  
	MOV AH,9H       ;Displaying the message in DX. see N0 in DATA SEGEMENT
	LEA DX,N0   
	INT 21H         
	
	

	MOV AH,0EH 
	MOV AL,0AH
	INT 10H    
    
	MOV AH,9H       ;Displaying the message in DX. see N1 in DATA SEGEMENT
	LEA DX,N1    
	INT 21H         
	
	MOV CL,[AN]
	ADD CL,30H

;Using service 0EH to show character and then enter a new line

	MOV AH,0EH      
	MOV AL,CL       
	INT 10H        
	MOV AH,0EH     
	MOV AL,0AH      
	INT 10H         

	MOV AH,9H       
	LEA DX,N2    ;Displaying the message in DX. see N2 DATA SEGEMENT
	INT 21H         
	
;Using service 0EH to show character and then enter a new line

	MOV CL,[BN]
	ADD CL,30H
	MOV AH,0EH      
	MOV AL,CL       
	INT 10H         
	MOV AH,0EH      
	MOV AL,0AH      
	INT 10H         

	MOV AH,9H       
	LEA DX,N3     ;Displaying the message in DX. see N3 in DATA SEGEMENT
	INT 21H         

;Using service 0EH to show character and then enter a new line	

	MOV CL,[CN]
	ADD CL,30H
	MOV AH,0EH      
	MOV AL,CL       
	INT 10H         
	MOV AH,0EH      
	MOV AL,0AH      
	INT 10H         
	



MOV AH,9H       
	LEA DX,N4    ;Displaying the message in DX. see N4 DATA SEGEMENT
	INT 21H    

        MOV AH,0EH      
	MOV AL,0AH      
	INT 10H    

EK:	  ;END_KEY

;implementing 'press aspace key to exit' function using service 1 of interrupt 16 and detecting what key is pressed

	MOV AH,01     
	INT 16H	       
	JZ EK   	   
	MOV AH,00     
	INT 16H	  
        CMP AL,' '       ;see if it is space
	JNE EK		

        
	
	MOV AX,4C00H         
	INT 21H        ;FINISH!
START   ENDP		
CSEG    ENDS		
	END START	

;*******************************************EOP*********************************	