;A Matrix rain application. Assembles as a .COM file.
;Author: Yll Buzoku
;Date of initial write: 23/08/21

CODE 	SEGMENT
ASSUME 	CS:CODE, DS:CODE, ES:CODE, SS:CODE
ORG 	100H

INIT	PROC	NEAR
;Saves current screen then blanks the screen, and starts scrolling ascii
;chars down the screen. Does not depend on hardware techniques, paging or 
;hw scrolling. Use BIOS INT 10h to slow down screen drawing. 

;First manually set segregs
	push cs
	pop ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, OFFSET stkend 	;Bottom of the stk space
;Now detect video mode
	mov ah, 0Fh
	int 10h
;Returns al=Vid mode, ah=#of cols, bh=active page
	mov byte ptr [mode], al
	mov byte ptr [cols], ah
	mov byte ptr [page], bh
	mov word ptr [regseg], 0b800h	;Assume colour card
	cmp al, 07h	;Are we a BW card, currently active?
	jne i1
	sub word ptr [regseg], 800h	;Move it back to bw space
i1:
	;First we create a first seed
	xor ah, ah
	int 1Ah
	mov word ptr [seed], dx		;Get ticks into seed var

	;Now we save the current screen and clear it in prep for screensaver
	;Temporarily, one textmode regen size
	;Calculate size needed, and realloc

	mov ax, OFFSET stkend + 1
	mov cl, 4
	shr ax, cl	;Turn ax into number of paragraphs
	mov bx, ax	;Move paragraphs into bx
	inc bx		;Add 1 to be safe
	mov ax, cs	;get code segment
	mov es, ax	;put code segment into es
	mov ah, 4Ah	;Realloc
	int 21h

	jnc i2	;Jump if passed
	mov dx, OFFSET fmsg
	mov ah, 09h
	int 21h	;Print string, ds in correct segment
	jmp iexit
fmsg:	db "Maloc error!",0Ah,0Dh,"$"	
i2:
	xor bh, bh		;0 page
	mov ah, 03h		;read cursor pos
	int 10h
	mov word ptr [curs], dx	;Save cursor pos

	mov ax, word ptr [regseg]	;Get actual segment 
	push ds
	mov ds, ax			;Set ds to point to bios regen
	xor si, si
	mov di, OFFSET regen		;es points to current code segment
	mov cx, 2000			;2000 words to be transferred
	rep movsw
	pop ds				;Get original ds back
;Buffers copied, time for some fun!

iloop:		;Main loop
;Get a random column number to scroll down, a random number of rows to scroll 
;that column down by
	mov bl, byte ptr [cols]	;Get columns into bl
	call rndgen
	mov al, bl	;Move the random column into al
			;Get a random column function
	mov bl, 0FFh	;Sub function options
	call rndgen
	mov ah, bl	;Move random column function into ah
	call col
	mov ah, 01
	int 16h
	jz iloop
;Exit below here. Return regen to regseg and dealloc
	mov ax, word ptr [regseg]
	mov es, ax
	push cs
	pop ds			;Ensure ds in code segment
	mov si, OFFSET regen
	xor di, di
	mov cx, 2000
	rep movsw
	mov dx, word ptr [curs]	;Get original cursor position back
	xor bh, bh		;0 page
	mov ah, 02h		;set cursor
	int 10h
iexit:
	mov ax, 4c00h	;DOS exit
	int 21h
INIT	ENDP

RNDGEN	PROC	NEAR
;Generates a random 8 bit "ASCII" value to put in the column.
;Input: bl = Modulo value (max allowed value plus 1)
;Ret:	bl = Random value
	push ax
	push cx
	push dx
	mov ax, 25173	;Random multiplier
	mul word ptr [seed]	;Multiply to seed
	add ax, 13849
	mov word ptr [seed], ax
;ax now has new random value
	mov cl, bl	;Get max number in cl
	xor ch, ch
	xor dx, dx	;Clear upper word for division for no overflow?
	div cx		;Divide ax by cl
	mov bl, dl	;move remainder into bl

	pop dx
	pop cx
	pop ax
	ret
RNDGEN	ENDP
COL	PROC	NEAR
;-----------------------------------------------------
; Takes column to scroll down, and scrolls it down.  :
; Might generate a new char or even clear column.    :
; Input: al=Column number (0-49), ah=Bit 7 	     :
;	ah(7) clear = Scroll column		     :
;	ah(7) set   = Add new char + scroll	     :
; Output: Nothing, ax destroyed.		     :
;-----------------------------------------------------
	push dx
	push cx
	push bx
	push si	
	
	xor ch, ch	;Upper row
	mov dh, 24	;Lower row
	mov cl, al	;Column to scroll in cl
	mov dl, al	;Column to scroll in dl
	mov si, ax	;Save col number in si
	mov bx, 0700h	;Usual char attrib in bh
	test ah, 80h
	jz colsub0

	mov ax, 0701h	;Scroll col down 1
	int 10h
	;Now insert a new random char at top
	mov dx, si	;Return col number into dl
	xor dh, dh	;Row 0
	xor bh, bh	;Page 0
	mov ah, 02h	;Set cursor pos
	int 10h
	mov bl, 0FFh	;Max ASCII char value
	call rndgen	;Get the char
	mov cx, 1	;1 char to print
	mov al, bl	;Move char code into al
	mov bh, 00h	;Page number
	mov ah, 0Ah	;Write char function
	int 10h
	jmp short colexit
colsub0:
	mov ax, 0701h	;Scroll col down 1
	int 10h
colexit:
	pop si
	pop bx
	pop cx
	pop dx
	ret
COL	ENDP
mode:	db	?	;Screenmode value
cols:	db	?	;Number of columns
regseg:	dw	?	;Either b000 or b800 (regen segment)
page:	db	?	;Current page number
seed:	dw	?	;Seed
curs:	dw	?	;Original cursor
regen:	db	4000 	dup(?)	;Regen space
stk:	db	100	dup(?)	;100 bytes stack space, overkill but safe
stkend	LABEL	WORD	
CODE	ENDS
	END	INIT
