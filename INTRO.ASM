;****************************************************************************
;*		C Y B E R  F I G H T  die for future			    *
;****************************************************************************
;		Вступление Игры 					    *
;****************************************************************************
intro_pal	proc
;--------------- вывод -=AS=- PRESENT ---------------------
		mov ax,0013h
		int 10h
		mov ah,2
		mov bh,0
		mov dl,12
		mov dh,12
		int 10h
		mov [color],7
		mov [red],0
		mov [green],0
		mov [blue],0
		call setpalette
		mov bx,16
		push ds
		push c_segm
		pop ds
		lea si,aspresent
		pop ds
		call decoder
		mov cx,64
pal_text:	call setpalette
		call pal_halt
		mov dx,03dah
looo:		in al,dx
		test al,08h
		je looo
		inc [blue]
		loop pal_text
		call pal_halt
		mov cx,64
		mov [blue],63
npal_text:	call setpalette
		call pal_halt
		mov dx,03dah
nlooo:		in al,dx
		test al,08h
		je nlooo
		dec [blue]
		loop npal_text
		call zastava
	jmp bbb
;----------------------------------------------
;--------------- Понтовая Рамка ---------------
;----------------------------------------------
cool_ramka	proc
		mov cx,33
		mov [red],11
		mov [green],5
		mov [blue],23
		mov [color],7
		mov ax,7
		add ax,cx
ram_pal:	inc [color]
		inc [red]
		inc [green]
		call setpalette
		loop ram_pal
		mov cx,35
ram_pal_2:
		inc [color]
		dec [red]
		dec [green]
		cmp [blue],0
		je bl_zero
		dec [blue]
bl_zero:
		call setpalette
		loop ram_pal_2
;--------------- ЧертЁж Рамки Основным Цветом ------------------
		mov bx,320			;горизонталь
		mov dx,200			;вертикаль
		push 0a000h
		pop es
		xor di,di
		mov al,9			;начальная цветовая матрица
cikl_again:	cld
		mov cx,bx
		rep stosb
		dec di
		mov cx,dx
ver_1:		stosb
		dec di
		add di,320
		loop ver_1
		sub di,320
		mov cx,bx
		std
		rep stosb
		inc di
		mov cx,dx
		dec cx
ver_2:		stosb
		inc di
		sub di,320
		loop ver_2
		add di,320
		inc di
		dec bx
		dec bx
		dec dx
		dec dx
		inc al
		cmp dx,66
		ja cikl_again
		cld
		ret
cool_ramka	endp
;--------------- "SCREEN LINED" ----------------------------
screen_lined	proc
		cld
		mov [color],255
		mov [red],53
		mov [green],15
		mov [blue],0
		call setpalette
		mov cx,100
		mov di,0
		mov si,63999
draw_p_l:	push cx
		mov al,255
		mov cx,320
		rep stosb
		mov cx,320
lined_p:	mov [es:si],al
		dec si
		loop lined_p
		call pal_halt
		mov dx,03dah
ooo:		in al,dx
		test al,08h
		je ooo
		mov al,0
		sub di,320
		add si,320
		mov cx,320
		rep stosb
		mov cx,320
lined_pp:	mov [es:si],al
		dec si
		loop lined_pp
		pop cx
		loop draw_p_l
		mov ax,0c00h
		int 21h
		ret
screen_lined	endp
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
bbb:
		call main_m
		jmp ex_intro
;****************************************************************************
;*************** M A I N   M E N U ******************************************
;****************************************************************************
main_m		proc
menu_again:	mov ax,0013h
		int 10h
		call clrscr
		call cool_ramka
		call cool_str
		mov [color],7
		mov [red],0
		mov [green],0
		mov [blue],0
		call setpalette 		;ready for menu...
		mov ah,2
		mov bh,0
		mov dl,15
		mov dh,9
		int 10h
		push dx
		mov ah,9
		lea dx,menu1
		int 21h
		pop dx
		add dh,2
		mov ah,2
		int 10h
		push dx
		cmp [type_game],3
		jne m_two
		mov ah,9
		lea dx,menu2_e
		int 21h
		jmp transpher
m_two:		cmp [type_game],2
		jne m_one
		mov ah,9
		lea dx,menu2_m
		int 21h
		jmp transpher
m_one:		mov ah,9
		lea dx,menu2_h
		int 21h
transpher:	pop dx
		add dh,2
		mov ah,2
		int 10h
		push dx
		mov ah,9
		lea dx,menu3
		int 21h
		pop dx
		add dh,2
		mov ah,2
		int 10h
		mov ah,9
		lea dx,menu4
		int 21h
;--------------- просветление меню ----------------------
ligh:		inc [green]
		call setpalette
		call pal_halt
		mov dx,03dah
olo:		in al,dx
		test al,08h
		je olo
		cmp [green],63
		jb ligh
;--------------- выбор меню ------------------------------
		mov [color],8
		mov [red],63
		mov [green],0
		mov [blue],0
		call setpalette
		mov [startup],1 		;пункт меню (#1)
		mov dx,xymenu
		push 0a000h
		pop es
		mov di,dx
i_did_it:	mov al,8
		mov cx,2560
ch_col: 	mov ah,[es:di]
		cmp ah,7
		jne not_ch
		stosb
		jmp cik
not_ch: 	inc di
cik:		loop ch_col
;--------------- read keyboard command -------------
read_menu:	mov ah,7			;читаем клавишу
		int 21h
		cmp al,72			;UP
		je menu_up
		cmp al,80			;DOWN
		je menu_down
		cmp al,32
		je choice_1
		cmp al,13
		je choice_1
		jmp read_menu
choice_1:	jmp choice_menu
;--------------- курсор вниз! ----------------------
menu_down:	sub di,2560
		mov al,7
		mov cx,2560
ch_back:	mov ah,[es:di]
		cmp ah,8
		jne no_ch
		stosb
		jmp ccik
no_ch:		inc di
ccik:		loop ch_back
		cmp [startup],4
		je new_column
		add di,2560
		inc [startup]
		jmp i_did_it
new_column:	mov [startup],1
		mov di,xymenu
		jmp i_did_it
;--------------- курсор вверх! ----------------------
menu_up:	sub di,2560
		mov al,7
		mov cx,2560
col_back:	mov ah,[es:di]
		cmp ah,8
		jne not_eight
		stosb
		jmp not_inc
not_eight:	inc di
not_inc:	loop col_back
		cmp [startup],1
		je down_column
		sub di,7680
		dec [startup]
		jmp i_did_it
down_column:	mov [startup],4
		add di,12800
		jmp i_did_it
;--------------- подтверждение выбора пункта меню ---------------
choice_menu:	cmp [startup],4
		jne not_quit
		ret
not_quit:	cmp [startup],1
		jne not_start
		ret
not_start:	cmp [startup],2
		jne not_difficult
		sub di,2560
		mov ah,2
		mov bh,0
		mov dl,15
		mov dh,11
		int 10h
		cmp [type_game],1
		ja not_hard
		mov [type_game],3
		mov ah,9
		lea dx,menu2_e
		int 21h
		jmp i_did_it
not_hard:	dec [type_game]
		cmp [type_game],1
		ja not_hard_2
		mov ah,9
		lea dx,menu2_h
		int 21h
		jmp i_did_it
not_hard_2:	mov ah,9
		lea dx,menu2_m
		int 21h
		jmp i_did_it
not_difficult:	call about
		push d_segm
		pop ds
		jmp menu_again
main_m		endp
ex_intro:	ret
intro_pal	endp
;****************************************************************************
;		Вывод Понтовой Заставы					    *
;****************************************************************************
zastava 	proc
		mov ah,0ch
		int 21h
		mov ah,3dh
		mov al,0
		lea dx,cyber_name
		int 21h
		jnc cyber_ok
		ret
cyber_ok:	mov [handle],ax
		xchg ax,bx
		mov ah,3fh
		xor dx,dx
		mov cx,1078
		push 5000h
		pop ds
		int 21h
		mov ax,0013h
		int 10h
		call done_pal		;активизировать палитру
		push d_segm
		pop ds
		mov ax,4200h
		mov bx,[handle]
		xor cx,cx
		mov dx,1078
		int 21h
		mov ah,3fh
		mov cx,64000
		xor dx,dx
		push 5000h
		pop ds
		int 21h
		call ready_l		;подготовка к засветлению
;=============== рисуем рисунок ====================
		push 0a000h
		pop es
		xor si,si
		xor di,di
		mov cx,64000
		rep movsb
		call light_now		;засветление
;=============== закрываем файл и ждём нажатия клавиши =============
		push d_segm
		pop ds
		mov ah,3eh
		mov bx,[handle]
		int 21h
		mov ah,7
		int 21h
;!!!!!!!!!!!!!!! затемнение рисунка !!!!!!!!!!!!
		call dark_now
		push d_segm
		pop ds
		mov ax,0013h
		int 10h
		mov ah,0ch
		int 21h
		ret
zastava 	endp
;@@@@@@@@@@@@@@@ Стильная надпись в меню @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
cool_str	proc
		push es
		push ds
		mov ah,3dh
		mov al,0
		lea dx,mnu_name
		int 21h 		;open file
		jnc mnu_ok
		pop ds
		pop es
		ret
mnu_ok: 	mov [handle],ax
		xchg ax,bx
		mov ah,3fh
		xor dx,dx
		mov cx,9503
		push 9060h		;рисунок в 9060:0000
		pop ds
		int 21h 		;read file
		push d_segm
		pop ds
		mov ah,3eh
		mov bx,[handle]
		int 21h 		;close file
;=>
		push ds
		push 9060h
		pop ds
		xor si,si
		mov cx,9503
mnucolr:	lodsb
		cmp al,9
		je nine_mnu
		cmp al,11
		jne notmnu
		mov al,100		 ;NEW COLOR!!!!!!
		dec si
		mov [ds:si],al
		inc si
		jmp notmnu
nine_mnu:	mov al,101		 ;NEW COLOR!!!!!!
		dec si
		mov [ds:si],al
		inc si
notmnu: 	loop mnucolr
		pop ds
;=>
		mov [color],100
		mov [red],63
		mov [green],63
		mov [blue],0
		call setpalette
		inc [color]		;101
		mov [green],0
		call setpalette
		inc [color]		;102
		mov [green],30
		call setpalette
		inc [color]		;103
		add [green],5
		call setpalette
		inc [color]		;104
		add [green],5
		call setpalette
		inc [color]		;105
		add [green],5
		call setpalette
		mov dx,1
		mov di,50
		mov si,221
		mov cx,42
		mov bx,221
		mov [xor_addr],5000h
		mov ah,1
		push ds
		push 9060h
		pop ds
		call xoring
		pop ds			;clear old sprite
		pop ds
		pop es
		ret
cool_str        endp