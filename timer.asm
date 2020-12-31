.model small
.stack
.data

	text     db 'hello$'
	seconds  db 99
	timer    dw 100
	time_str dw ?,"$"

.code
MAIN PROC
	;INITILIZE DATA SEGMENT.
	          mov ax, @data
	          mov ds, ax

	again:    
	;GET SYSTEM TIME.
	          mov ah, 2ch
	          int 21h               	;RETURN SECONDS IN DH.
	;CHECK IF ONE SECOND HAS PASSED.
	          cmp dh, seconds
	          je  no_change

	          mov seconds, dh
	          sub timer,1d
	          jz  EXIT
	;DISPLAY TEXT EVERY SECOND.
	;   mov ah, 9
	;   mov dx, offset text
	;   int 21h

	;   mov dl,'0'
	          mov dx,timer
	;   mov time_str,0
	          add dx,38D6H
	          mov time_str,dx
	          mov dx,offset time_str
	          mov ah,9
	          int 21h
	          mov ah,2
	          mov dl,' '
	          int 21h
	    
	no_change:
	          jmp again

	;end the program
	EXIT:     mov ax, 4c00h
	          int 21h
  MAIN ENDP
END MAIN