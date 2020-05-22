; At day, the sky is white and mountains are light red in color while river has blue background 
; with white foreground, there is light grey texture on the road . Fish and car has the same
; color through all the course. At night, the sky becomes black, mountains red, river retains
; blue background but with black foreground, and texture on road becomes dark grey in color.
; This variation in colors during day and night has been done to show the AFFECT of night on the scene.
[org 0x0100]
jmp start

oldkb: 		  dd	0
maxlength:    dw	80                 				; maximum length of input 
;10 is called as LF or Line Feed or new line and 13 is called as CR or Carriage return. These characters are used to control the cursor position. They are control characters
greetings:    db	10, 13, 'Welcome and hello $'  	; greetings message
buffer:       times 81 db 0           				; space for input string 
EnterName:	  db	10, 13, 'Please enter your name: $'
Instructions: db	10, 13, 'Please choose one of the Instructions for Game: $'
Instruction1: db	10, 13, 'Instruction 1: dummy1 $'
Instruction2: db	10, 13, 'Instruction 2: dummy2 $'
Instruction3: db	10, 13, 'Instruction 3: Press Enter to Continue OR Esc to Exit $'
dummy1:		  db	10, 13, 'exiting from the Game $'
dummy2:		  db	10, 13, 'exiting from the Game $'
carPos:		  dw	0;to know car's position relative to its start point
upp:		  db	0;to know if car is up or not!
downn:		  db	0;to know if car is down or not!

clrscreen:	push bp
			mov bp, sp
			push es
			push di
			push ax
			push cx
			
			xor di, di
			les ax, [bp+4];load 0xb800 in es and attribute+ascii of clrscreen in ax
			mov cx, 2000
			
			cld
			rep stosw
			
			pop cx
			pop ax
			pop di
			pop es
			pop bp
			ret 4
;---------------------------Assignment2---------------------------start
Welcome_screen:	push bp
				mov bp, sp
				push es
				push di
				push ax
				push cx

				mov ax, 0xb800
				mov es, ax
				mov ax, 0x0020
				xor di, di
				mov cx, [bp+4];number of di places to be cleared
				cld
				rep stosw
				
				mov ax, 0xe03c;design on upper line
				mov di, 640;leave some space above
				mov cx, 80;run for only 1 line
				cld
				rep stosw;welcome line 1
				
				add di, 174
				mov ah, 0x03
				mov al, 'W'
				mov word[es:di], ax
				add di, 22
				mov al, 'E'
				mov word[es:di], ax
				add di, 22
				mov al, 'L'
				mov word[es:di], ax
				add di, 22
				mov al, 'C'
				mov word[es:di], ax
				add di, 22
				mov al, 'O'
				mov word[es:di], ax
				add di, 22
				mov al, 'M'
				mov word[es:di], ax
				add di, 22
				mov al, 'E'
				mov word[es:di], ax
				add di, 174

				mov ax, 0xe03e;design on upper line
				mov cx, 80;run for only 1 line
				cld
				rep stosw;welcome line 2

				pop cx
				pop ax
				pop di
				pop es
				pop bp
				ret
;---------------------------Assignment2---------------------------end

day_or_night:	push bp
				mov bp, sp
				push es
				push di
				push ax
				push cx
				
				les ax, [bp+4];load 0xb800 in es and attribute+ascii of night in ax
				xor di, di
				mov cx, 960;first 12 rows
				cld
				rep stosw
				
				pop cx
				pop ax
				pop di
				pop es
				pop bp
				ret 4

mountain:	push bp
			mov bp, sp
			push es
			push di
			push ax
			push bx
			push cx
			push dx
			
			mov ax, 80
			mov di, 11
			mul di
			mov di, ax
			mov dx, 16;base of mountain
			mov ax, [bp+4];mountain 0/1/2/3/4
			mul dx
			
			add di, ax
			shl di, 1
			les ax, [bp+6];load 0xb800 in es and attribute+ascii of mountain in ax
			mov cx, 16;inner counter
			mov dx, cx;outer counter
			
print_lines:mov [es:di], ax
			add di, 2
			loop print_lines
			sub dx, 2;decrement outer counter
			mov cx, dx;restore inner count
			sub di, 162;move one row up and one step left ;now er are at right side of mountain
			shl cx, 1;to get to the left side of mountain row, multiplying counter by 2 and subtracting from di
			sub di, cx;getting di to the starting point
			shr cx, 1
			jnz print_lines
			
			pop dx
			pop cx
			pop bx
			pop ax
			pop di
			pop es
			mov sp, bp
			pop bp
			ret 6

road:		push bp
			mov bp, sp
			push es
			push di
			push ax
			push cx
			push dx
			push si
			
			mov ax, 80
			mov di, 12
			mul di
			shl ax, 1
			mov dx, ax;for later use
			mov di, ax;80 * row number * 2 ; 80*12*2
			les ax, [bp+4]
			mov cx, 400;80 * no of rows ; 80*5
			cld
			rep stosw
			
			mov di, dx;go to start of road i.e., 80*12*2
			mov cx, 80;total 80 white dashes
			mov ax, [bp+8];changing color from grey
			
dash:		mov [es:di], ax
			add di, 10;jump to 5th following column
			loop dash
			
			cmp word[cs:upp], 1;is car UP!
			jne normal_pos
			sub di, 160;if car is one row UP, place $ (car) at start of one row up (than usual/normal position)
			;object
normal_pos:	sub di, 480
			mov ax, 0x0224;green dollar
			mov [es:di], ax
			
			pop si
			pop dx
			pop cx
			pop ax
			pop di
			pop es
			pop bp
			ret 6
			
river:		push bp
			mov bp, sp
			push es
			push di
			push ax
			push cx
			
			mov ax, 80
			mov di, 17
			mul di
			shl ax, 1;80 * row number * 2 ; 80*17*2 ; start printing river on 17th row
			mov di, ax
			les ax, [bp+4];load 0xb800 in es and attribute+ascii of river in ax
			mov cx, 640;print 8 rows
			
			cld
			rep stosw
			
			pop cx
			pop ax
			pop di
			pop es
			pop bp
			ret 4

outtt:jmp outt

movement:	push es
			push di
			push ax
			push bx
			push cx
			push dx
			push si

			mov ax, 0xb800
			mov es, ax
			;checking if there was fish situated beforehand
			mov ax, 80
			mov di, 22
			mul di
			shl ax, 1;80*22*2
			add ax, 40;22th row, 20th column; where fish ends its tour
			mov di, ax
			mov ax, [es:di]
			cmp ax, 0x1F4F;white| O ;attributes of fish
			jne no_prior_fish;if there was no fish, then jump

			sub di, 320;go 3 rows backwards
			mov bx, [es:di]
			mov [es:di], ax
			add di, 320
			mov [es:di], bx;swapping completed
			jmp skip_fish_init
			
no_prior_fish:	mov ax, 0x1F4F;white| O ;fish
				mov [es:3240], ax;fish at its staring point ;20th column of 20th row

skip_fish_init:	mov ax, 80
				mov di, 4
				mul di
				shl ax, 1;80*4*2
				mov dx, ax;save the initial position of mountains for later use
				mov ch, 8;total number of rows of  mountains=8  to be moved		;outer counter
				mov si, 80;number of movements
				mov di, dx

repp:		mov bx, [es:di];store first element so that it'd be pasted at the last place	;i.e., movement from right to left
			add di, 2
			mov cl, 79;total number of columns in a row to be copied	;inner counter
back_copying:	mov ax, [es:di]
				sub di, 2
				mov [es:di], ax
				add di, 4
				dec cl
				jnz back_copying

				sub di, 2
				mov [es:di], bx;paste first element at last position
				add di, 2

			cmp ch, 0x01;check if mountain movements are completed
			jne check_fish

			cmp word[cs:carPos], 158;checking if the car has reached to the end of line
			jb inc_carPos;if no, move car one place from left to right
			mov word[cs:carPos], 0;if yes, re-initialize carPos
			jmp check_fish

inc_carPos:	mov di, 2240;get to the start of 15th row ;where car is situated
			add di, word[cs:carPos];get to car's current position
			cmp word[cs:upp], 1;check if car is one row up!
			jne forward_car
			call Sound
			sub di, 160;if yes, then get one row up

forward_car:mov bx, [es:di];$;car
			add di, 160;get one row down
			mov ax, [es:di];white dash
			sub di, 160;get back
			mov [es:di], ax;replace  [es:di]=$  with  ax=white dash  which was above it
			add di, 2;come to middle of targeted row i.e, where the car is situated
			mov [es:di], bx;retain $ at middle
			sub di, 322;go back to the original position of di
			sub di, word[cs:carPos]
			add word[carPos], 2;now the car is moved one place from left to right

check_fish:	cmp ch, 0x01;check if 'mountain movement' is completed or not
			jne next_iteration
			cmp si, 40;check if fish's right side movement is finished
			ja fish_right;if si is greater than 40, then jump
			jne fish_left;if less than 40, then jump
			
			add di, 1400;go to last position of fish and copy it	;60th column of 20th row
			;mov di, 3260
			mov ax, [es:di];fish
			add di, 320
			mov bx, [es:di]
			mov [es:di], ax;first position for fish_left
			sub di, 320
			mov [es:di], bx;swapping completed
			sub di, 1400;because this label will be active only once when si = 40`

fish_left:	add di, 1720;jump 8 rows downward and 40 columns forward ;40th column of 22th row
			;mov di, 3560
			mov bx, 40;original value of si
			sub bx, si;value of si at current position
			shl bx, 1;bx*2
			sub di, bx;move backward bx times from 40th column of 20th row
			;swapping fish with its previous place holder
			mov bx, [es:di];white| O ;fish
			sub di, 2
			mov ax, [es:di];previous place holder
			mov [es:di], bx
			add di, 2
			mov [es:di], ax;swapping completed
			jmp next_iteration
			
fish_right:	add di, 1320;jump 8 rows downward and 20 columns forward ;20th column of 20th row
			mov bx, 80;original value of si
			sub bx, si;value of si at current position
			shl bx, 1;bx*2
			add di, bx;move forward bx times from 20th column of 20th row
			;swapping fish with its next place holder
			mov bx, [es:di];white| O ;fish
			add di, 2
			mov ax, [es:di];next place holder
			mov [es:di], bx
			sub di, 2
			mov [es:di], ax;swapping completed
			
next_iteration:		dec ch
					jnz repp
					
delays:		cmp word[cs:upp], 1;if car is up, don't delay (because its already been compensated in Sound function)
			je re_init
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay
			call delay

re_init:	mov di, dx;restore initial position
			mov ch, 8;re-initialize total number of rows of mountains
			dec si
			jnz repp
			
			mov word[cs:carPos], 0
			pop si
			pop dx
			pop cx
			pop bx
			pop ax
			pop di
			pop es
			ret	

delay:
	push cx
	mov cx, 0xffff
	d0:	loop d0
	pop cx
	ret
;---------------------------Assignment3---------------------------start
Sound:		pusha
			mov al, 0b6h
			out 43h, al
;load the counter 2 value for c7
			mov ax, 0023h
			out 42h, al
			mov al, ah
			out 42h, al

;turn the speaker on
			in al, 61h
			mov ah,al
			or al, 3h
			out 61h, al
call delay
call delay
			mov al, ah
			out 61h, al
call delay
call delay
;load the counter 2 value for A2b
			mov ax, 05c0h
			out 42h, al
			mov al, ah
			out 42h, al

;turn the speaker on
			in al, 61h
			mov ah,al
			or al, 3h
			out 61h, al
call delay
call delay
			mov al, ah
			out 61h, al
call delay
call delay
			popa
			ret
							
kbisr:;;this will only take car UP or DOWN i.e., not forward
					push ax
					push bx
					push dx
					push es
					mov ax, 0xb800
					mov es, ax
					
					in al, 0x60 ; read char from keyboard port

					cmp al, 0x01
					je outtt
					mov di, 2240;
					add di, word[cs:carPos];current pos of car
					mov dx, [es:di]; dx will have $ (car) in it IFF car is at its normal row (position), while dx will have whatever is at +160 of car's position when the car is at upper row (during the time when up key is being pressed)
					;no need to initialize es, because it already has 0xb800
					cmp al, 0x48;compare if up key was pressed recently!
					jne check_release
					cmp byte[cs:upp], 1;is car already up?
					je check_release

					;lets move car up
					sub di, 160
					mov bx, [es:di];whatever is at -160 of cars current position
					mov [es:di], dx;place car up
					add di, 160
					mov [es:di], bx
					mov byte[cs:upp], 1; now the car is up
					mov byte[cs:downn], 0; now, car can go down one row (original position) again 
					jmp end_kbisr
					
check_release:		cmp al, 0xc8;up key release code
					jne end_kbisr
					cmp byte[cs:downn], 1;is car already down?
					je end_kbisr
					
					;lets move car down
					sub di, 160;going up, where the car is currently situated
					mov bx, [es:di];$;car
					mov [es:di], dx;whatever is at +160 of car's current position.. note that car is on upper row than normal
					add di, 160;getting car one row down
					mov [es:di], bx
					mov byte[cs:upp], 0; now the car is at normal position
					mov byte[cs:downn], 1; now the car is down

end_kbisr:			pop es
					pop dx
					pop bx
					pop ax
					jmp far [cs:oldkb] ; call original ISR
;---------------------------Assignment3---------------------------end

start:
;---------------------------Assignment2---------------------------start
xor ax, ax
mov es, ax ; point es to IVT base

mov ax, [es:9*4]
mov [oldkb], ax ; save offset of old routine
mov ax, [es:9*4+2]
mov [oldkb+2], ax ; save segment of old routine

cli ; disable interrupts

mov word [es:9*4], kbisr ; store offset at n*4
mov [es:9*4+2], cs ; store segment at n*4+2

sti ; enable interrupts

push 1920
call Welcome_screen

			mov  dx, EnterName      ; User will be asked to enter his/her name               
			mov  ah, 9              ; service 9 – write string               
			int  0x21               ; dos services
			mov  cx, [maxlength]    ; load maximum length in cx              
			mov  si, buffer         ; point si to start of buffer 
 
nextchar:  	mov  ah, 1              ; service 1 – read character               
			int  0x21               ; dos services 
			cmp  al, 13             ; is enter pressed               
			je   nextScenerio       ; yes, leave input               
			mov  [si], al           ; no, save this character               
			inc  si                 ; increment buffer pointer               
			loop nextchar           ; repeat for next input char 
 
nextScenerio: mov byte [si], '$'     ; append $ to user input 
	
              mov dx, greetings      ; greetings message               
			  mov ah, 9              ; service 9 – write string               
			  int 0x21               ; dos services 
 
              mov dx, buffer         ; user input buffer               
			  mov ah, 9              ; service 9 – write string               
			  int 0x21               ; dos services 
			  
			  mov dx, Instructions   ; user will be shown instructions               
			  mov ah, 9              ; service 9 – write string               
			  int 0x21               ; dos services
			  mov dx, Instruction1
		  	  mov ah, 9
			  int 0x21
			  mov dx, Instruction2
			  mov ah, 9
			  int 0x21
			  mov dx, Instruction3
			  mov ah, 9
			  int 0x21
			  
push 1360
call Welcome_screen

PressAgain:	  mov  ah, 0              ; service 0 – get keystroke               
			  int  0x16               ; call BIOS keyboard service 
			  cmp  al, 31h            ; is '1' pressed
			  je onePressed
			  cmp  al, 32h            ; is '2' pressed
			  je twoPressed
			  jne threePressed		  ; if not '1' and '2', then check for Enter and Esc
			  
onePressed:		mov dx, dummy1		  ; showing dummy message against instruction 1
				mov ah, 9			  ; service 9 – write string
				int 0x21			  ; dos services
				jmp outt			  ; exiting
twoPressed:		mov dx, dummy2		  ; showing dummy message against instruction 2
				mov ah, 9			  ; service 9 – write string
				int 0x21			  ; dos services
				jmp outt			  ; exiting
threePressed:	cmp al, 27            ; is the Esc key pressed 
			    je outtt			  ; exiting
				cmp al, 13            ; is the Enter key pressed 
			    je GAME
			    jne PressAgain
;---------------------------Assignment2---------------------------end
GAME:
mov cx, 2;times the scenerio will run
push 0xb800
push 0x0020;black|space
call clrscreen

again:	push cx
		push 0xb800
		push 0x7020;white|space
		call day_or_night
push 0xb800
push 0x0C3A;ligt red foeground colon
push 0
call mountain
push 0xb800
push 0x0C3A
push 1
call mountain
push 0xb800
push 0x0C3A
push 2
call mountain
push 0xb800
push 0x0C3A
push 3
call mountain
push 0xb800
push 0x0C3A
push 4
call mountain
		push 0x0F2d;white dash
		push 0xb800
		push 0x082d;dark grey dash
		call road
		push 0xb800
		push 0x1F27;blue background with white foeground| '
		call river
call movement
;;;;;;;;;;;;;;;;;;;;;;;;;;;
		push 0xb800
		push 0x0020;black|space
		call day_or_night
push 0xb800
push 0x043A
push 0
call mountain
push 0xb800
push 0x043A
push 1
call mountain
push 0xb800
push 0x043A
push 2
call mountain
push 0xb800
push 0x043A
push 3
call mountain
push 0xb800
push 0x043A
push 4
call mountain
		push 0x072d;black dash
		push 0xb800
		push 0x082d;grey dash
		call road
		push 0xb800
		push 0x1027;blue background with black foeground| '
		call river
call movement
pop cx
dec cx
jnz again
			  
outt:
xor ax, ax
mov es, ax
			  mov ax, [oldkb]
              mov bx, [oldkb+2]
              cli
              mov [es:9*4], ax
              mov [es:9*4+2], bx
              sti
mov  al, 0x20           
out  0x20, al           ; send EOI to PIC
mov  ax, 0x4c00         ; terminate program               
int  0x21