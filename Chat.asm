.Model medium
.386
.STACK 265

.DATA
	NumMsgSent        db 1
	NumMsgRecived     db 1
	MsgSendIndix      db 0
	MsgReceivedIndix  dw 0
	Msg               db 40 dup(" "),'$'
	PressedKey        db ?
	
	name1             db 15
	                  db ?                              	;CHARACTERS ENTERED BY USER.
	                  db 16 dup("$")

	name2             db 15
	                  db ?                              	;CHARACTERS ENTERED BY USER.
	                  db 16 dup("$")
	; name2             db 'Player2'

	getplayer1namemsg db 'Enter Your Name  $'
	getplayer2namemsg db 'Enter Receiver Name  $'

.CODE

DrawLine proc

	;   mov ah,6
	;     mov al,1
	;     mov bh,7
	;     mov cx,0
	;     mov dh,12
	;     mov dl,79
	;     int 10h
	                
	               

	                 mov  ah,0
	                 mov  al,13H
	                 int  10h
	;---------------------------
	                 mov  ah,9
	                 mov  dx,offset name1+2          	;display the name of player 1
	                 int  21h
	;set the cursor position
	                 mov  ah,2
	                 mov  dh,13
	                 mov  dl,0
	                 int  10h
	;display the name of player 2
	                 mov  ah,9
	                 mov  dx,offset name2+2          	;display the name of player 1
	                 int  21h
	;-------------------------

	;  mov  al,name1+1
	;  mov  MsgSendIndix,al
	;  mov  al,name2+1
	;  mov  ah,0
	;  mov  MsgReceivedIndix,ax

	                 mov  cx,0
	                 mov  dx,100
	                 mov  al,0fh
	                 mov  ah,0ch
	Draw:            
	                 int  10h
	                 inc  cx
	                 cmp  cx,320
	                 jnz  Draw
                            
	                 ret
DrawLine endp



MsgSend proc
	                 mov  di,offset Msg              	;new massage
	                 add  di,MsgReceivedIndix        	;to put char after the last char written

	Loop1Send:       
	                 mov  dx , 3FDH
	Check:           
	                 In   al , dx
	                 test al ,00100000b
	                 JZ   Check
	                 mov  dx,3f8h
	                 mov  ah,0bh
	                 int  21h
	                 cmp  al,0
	                 je   Escape
	                 mov  dl,0
	                 mov  dh,NumMsgSent
	                 add  dl,MsgSendIndix
	                 mov  ah,2
	                 int  10h
	                 mov  ah,1
	                 int  21h
	                 mov  dx , 3F8H
	                 out  dx , al
	                 inc  MsgSendIndix
	                 cmp  MsgSendIndix,39            	;---------------------------------
	                 je   here
	back:            cmp  al,1bh
	                 je   Escape                     	;if esc is pressed end program
	                 cmp  al,08h
	                 je   BackSpace                  	;if backspace is pressed
	                 cmp  al,0dh
	                 jne  Escape

	                 mov  dl,0
	                 mov  dh,NumMsgSent              	;to move in correct Y pos
	                 mov  ah,2
	                 int  10h

	                 mov  MsgSendIndix,0
	                 inc  NumMsgSent
					 cmp NumMsgSent,11
					 jne Escape


	Escape:          
	                 ret
	; here:            dec  MsgSendIndix
	;                  jmp  Check
	here:            dec  MsgSendIndix
	;sub  MsgReceivedIndix,2
	                 jmp  back
	; mov  MsgSendIndix,0
	;add  NumMsgSent,1
	                 
	                 


	BackSpace:       
	                 mov  ah,2
	                 mov  dl,''
	                 int  21h
		             sub  MsgSendIndix,1
					 cmp  MsgSendIndix,0
					 je   Escape
	                 sub  MsgSendIndix,1
	                 jmp  Escape


MsgSend endp







MsgRec proc
	;char input
	;check that the regester is ready to receive char
	loop1Received:   
	                 mov  dx,3FDH                    	; Line Status Register
	                 in   al,dx
	                 test al,1
	                 JZ   Escape2                    	;if not ready jumb

	                 mov  dx , 03F8H
	                 in   al , dx
	                 cmp  al,1bh
	                 je   Escape2                    	;if Esc is pressed end program
	                 cmp  al,0dh
	                 je   SendMsgAndDown             	;if enter is pressed send message go down one line
	                 cmp  al,08h
	                 je   Erase                      	;if backspace is pressed delete last character by dec [MsgReceived]
	                 mov  [di] , al
	                 inc  MsgReceivedIndix
	                 cmp  MsgReceivedIndix,39
	                 je   here2
	back2:           jmp  loop1Received	

	Escape2:         
	                 ret

	Erase:           ;mov  ah,2
	                ;  mov  dl,'.'
	                ;  int  21h
					cmp MsgReceivedIndix,0
					je  loop1Received
					mov [di], " "
	                dec  di
					mov [di]," "
	                sub MsgReceivedIndix,1
	                jmp loop1Received


	here2:           dec  MsgReceivedIndix
	                 jmp  back2


	SendMsgAndDown:  
	;set cursor
	                 mov  ah,02
	                 mov  dh,13
	                 add  dh,NumMsgRecived
	                 mov  dl,0
	                 int  10h
	                 mov  ah,9
	                 mov  dx, offset msg
	                 int  21h
	                 inc  NumMsgRecived
					 cmp  NumMsgRecived,11
					 jne  cont


					 mov  NumMsgRecived,1
	cont:             
					 mov  MsgReceivedIndix,0
	                 mov  cx,39
	                 mov  si,offset msg
	NewMsg:          
	                 mov  [si], " "
	                 inc  si
	                 loop NewMsg
	                 jmp  loop1Received
MsgRec endp




getnameinput1 PROC
	;  mov  ah,9
	;  mov  dx,offset getplayer1namemsg
	;  int  21h
	;CAPTURE STRING FROM KEYBOARD.
	                 mov  ah, 0Ah                    	;SERVICE TO CAPTURE STRING FROM KEYBOARD.
	                 mov  dx, offset name1
	                 int  21h

	;DISPLAY STRING.
	                 mov  ah, 9                      	;SERVICE TO DISPLAY STRING.
	                 mov  dx, offset name1+2
	                 int  21h

	                 ret
getnameinput1 endp
getnameinput2 PROC
	;  mov  ah,0
	;  int  10h
	;  mov  ah,9
	;  mov  dx,offset getplayer2namemsg
	;  int  21h
	;CAPTURE STRING FROM KEYBOARD.
	                 mov  ah, 0Ah                    	;SERVICE TO CAPTURE STRING FROM KEYBOARD.
	                 mov  dx, offset name2
	                 int  21h

	;DISPLAY STRING.
	                 mov  ah, 9                      	;SERVICE TO DISPLAY STRING.
	                 mov  dx, offset name2+2
	                 int  21h

	                 ret
getnameinput2 endp


getnamesandprint proc
	                 mov  ah,0
	                 mov  al,13h
	                 int  10h
	                 mov  ah,9
	                 mov  dx,offset getplayer1namemsg
	                 int  21h
	                 call getnameinput1
	                 mov  ah,0
	                 mov  al,13h
	                 int  10h
	                 mov  ah,9
	                 mov  dx,offset getplayer2namemsg
	                 int  21h
	                 call getnameinput2
	                 ret
getnamesandprint endp


main proc far
	                 mov  ax,@data
	                 mov  ds,ax
	;  call getnameinput1
	;  call getnameinput2
	                 call getnamesandprint
	                 mov  dx,3fbh                    	; Line Control Register
	                 mov  al,10000000b               	;Set Divisor Latch Access Bit
	                 out  dx,al                      	;Out it
	;Set LSB byte of the Baud Rate Divisor Latch register.
	                 mov  dx,3f8h
	                 mov  al,0ch
	                 out  dx,al
	;Set MSB byte of the Baud Rate Divisor Latch register.
	                 mov  dx,3f9h
	                 mov  al,00h
	                 out  dx,al
	;Set port configuration
	                 mov  dx,3fbh
	                 mov  al,00011011b
	;0:Access to Receiver buffer, Transmitter buffer
	;0:Set Break disabled
	;011:Even Parity
	;0:One Stop Bit
	;11:8bits
	                 out  dx,al
	                 call DrawLine
	Start:           
	                 call MsgRec
	                 cmp  al,1bh
	                 jne  resume
	                 jmp  end2
	resume:          
	                 call MsgSend
	                 cmp  NumMsgSent,11
	                 je   end3
	                 cmp  al,1bh
	                 jne  Start

	end2:            
	                 mov  ah,0
	                 mov  al,13H
	                 int  10h
	end3:            hlt
main ENDP



end main


