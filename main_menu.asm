;Mohamed Shams
;Main Menu
.model small
.data
	menu    db "Welcome To Coins War",13,10
	        db "1. Play",13,10
	        db "2. Chat",13,10
	        db "3. Exit",13,10,'$'
	chatmes db "Welcome to the chat !","$"
    playmes db "Play now","$"
.code
MAIN PROC

	;INITIALIZE DATA SEGMENT.
	      mov ax, @data
	      mov ds, ax
	;Clear screen
	      mov ah, 0
	      mov al, 3
	      int 10H
	;Display messages
	      mov dx, offset menu
	      mov ah, 9
	      int 21h

	;WAIT FOR ANY KEY.
	AGAIN:mov ah, 01
	      int 16h
	      JZ  AGAIN
	      mov ah,0
	      int 16h               	;if there is a key get it in al
	;   mov dl,al
	;   mov ah,02
	;   int 21h
	      cmp ah,4
	      jz  EXIT
	      cmp ah,3
	      jz  CHAT
	      cmp ah,2
	      jz  PLAY
	      jmp EXIT

	CHAT: mov dx ,offset chatmes
	      mov ah,9
	      int 21h
	      jmp EXIT
	PLAY: mov dx ,offset playmes
	      mov ah,9
	      int 21h
	      jmp EXIT

	;Exit the program
	EXIT: mov ah,4ch
	      int 21h
MAIN ENDP
END MAIN