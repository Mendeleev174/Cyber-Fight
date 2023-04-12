;****************************************************************************
;*	Обслуживание пункта ABOUT GAME и просмотр VGA и SVGA файлов	    *
;****************************************************************************
about		proc
		mov ah,3dh
		mov al,0
		lea dx,bmp_name
		int 21h
		jnc confin			;open file
		ret
confin: 	xchg ax,bx
		mov ah,3fh
		mov cx,33078
		xor dx,dx
		push 5000h
		pop ds
		int 21h 			;read file
		mov ah,3eh
		int 21h 			;close file
;--------------- reset VGA ----------------------------
		mov ax,0013h
		int 10h 			;VGA ON!!!
		call done_pal
		call ready_l			;подготовка к засветлению
		jmp lets_draw
;--------------- преобразование палитры ---------------
done_pal	proc
		mov si,54
		push 6000h
		pop es
		xor di,di
		mov cx,256
eee:		lodsb
		shr al,2
		stosb
		lodsb
		shr al,2
		stosb
		lodsb
		shr al,2
		stosb
		mov al,[es:di-1]
		mov bl,[es:di-3]
		xchg al,bl
		mov [es:di-1],al
		mov [es:di-3],bl
		inc si
		loop eee
;--------------- установка палитры --------------------
		push 6000h
		pop es
		mov ax,1012h
		mov dx,0
		mov cx,256
		xor bx,bx
		int 10h
		ret
done_pal	endp
;--------------- вывод на экран -----------------------
lets_draw:	push 5000h
		pop ds
		push 0a000h
		pop es
		mov si,33077
		mov di,160
		mov cx,200
		std
image:		push cx
		mov cx,160
line_bitmap:	mov al,[ds:si]
		dec si
		stosb
		loop line_bitmap
		add di,480
		pop cx
		loop image
		cld
		call lorus		;load rus fonts
;--------------- подбор текста -----------------------
		mov [stroka],1
		mov [positas],1
prt_info_as:	call info_as
		inc [stroka]
		add [positas],10
		cmp [stroka],16
		jbe prt_info_as
		call light_now		;засветление
		mov ah,7
		int 21h 		;keypressed!
		call dark_now		;затемнение
		mov ah,0ch
		int 21h
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;!!		Представление ACG-Graphics				   !!
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		push d_segm
		pop ds
		mov ah,3dh
		mov al,0
		lea dx,bmp_acg
		int 21h
		jnc sconfin			;open file
		ret
sconfin:	xchg ax,bx
		mov ah,3fh
		mov cx,33078
		xor dx,dx
		push 5000h
		pop ds
		int 21h 			;read file
		mov ah,3eh
		int 21h 			;close file
		mov ax,0013h
		int 10h
		call done_pal		;активизировать палитру
		call ready_l
;=============== рисуем рисунок ====================
		push 0a000h
		pop es
		mov si,33077
		mov di,160
		mov cx,200
		std
bmimage:	push cx
		mov cx,160
line_bm:	mov al,[ds:si]
		dec si
		stosb
		loop line_bm
		add di,480
		pop cx
		loop bmimage
		cld
		call lorus		;load rus fonts
;--------------- Изменение исходного цвета шрифтов --------------
		push ds
		push 3630h
		pop ds
		xor si,si
		mov cx,2618
chcolr: 	lodsb
		cmp al,39
		jne notch
		mov al,100		 ;NEW COLOR!!!!!!
		dec si
		mov [ds:si],al
		inc si
notch:		loop chcolr
		pop ds
;-----------------------------------------------------------------
		mov [stroka],1
		mov [positas],1
prt_info_acg:	lea si,mess_info_acg
		call info_acg
		inc [stroka]
		add [positas],10
		cmp [stroka],11
		jbe prt_info_acg
		call light_now		;засветление
;=============== закрываем файл и ждём нажатия клавиши =============
		mov ah,7
		int 21h
		call dark_now		;затемнение
		push d_segm
		pop ds
		mov ax,0013h
		int 10h
		mov ah,0ch
		int 21h
		ret
;$$$$$$$$$$$$$$$ INFO AS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
info_as 	proc
		lea si,mess_info_as
info_acg:	mov cx,[stroka]
		dec cx
		cmp cx,0
		jz write_now
optimize_string:
		add si,20
		loop optimize_string
write_now:	mov cx,20		;кол-во символов в сообщении
		mov ah,1
		mov dx,[positas]	;VER
		mov di,170		;HOR
		mov bx,7
prt_m:		push cx
		lodsb			;смещение для символа в AL(режим печати)
		call decoder_font	;раскодируем символ
		push si
		push ds
		push 3430h
		pop ds
		mov cx,8
		xor si,si
		call anim_new		;печатаем символ
		pop ds
		pop si
		adc di,7
		pop cx
		loop prt_m		;напечатали первую строку сообщения
		ret
info_as 	endp
about		endp
;****************************************************************************
;*		Svga View						    *
;****************************************************************************
svga_view	proc
		push d_segm				 ;\ds:=d_segm
		pop ds					 ;/
		jmp svga_main
svga_fin:	mov ah,3eh
		mov bx,[handle]
		int 21h 				;close file
		mov ax,0013h
		int 10h
		ret
svga_main:	mov ah,3dh
		mov al,0
		lea dx,assoft_name
		int 21h
		jnc ok_fin			;open file
		ret
ok_fin: 	mov [handle],ax
		xchg ax,bx
		mov ah,3fh
		mov cx,1078
		xor dx,dx
		push 5000h
		pop ds
		int 21h 		;read file
		mov ax,4f02h
		mov bx,103h
		int 10h 		;SVGA ON!!! 800x600   256 colors
		call done_pal
		jmp setpal_ok
;--------------- вывод картинки на экран ---------------------------
draw_svga	proc
		push 5000h
		pop ds
		push 0a000h
		pop es
		xor si,si
		xor di,di
		mov cx,65535
		rep movsb
		ret
draw_svga	endp
;--------------- вывод на экран первого поля ------------------------
setpal_ok:	push d_segm
		pop ds
		mov ax,4200h
		mov bx,[handle]
		mov cx,0
		mov dx,1078
		int 21h
		mov ah,3fh
		mov bx,[handle]
		mov cx,65535
		xor dx,dx
		push 5000h
		pop ds
		int 21h
		push d_segm
		pop ds
		mov ax,4f05h
		xor bx,bx
		mov dl,0
		mov [bank],dl
		int 10h
		call draw_svga
;=============== последний pixel первого поля =================
		push d_segm
		pop ds
		mov ah,3fh
		mov bx,[handle]
		mov cx,1
		xor dx,dx
		push 5000h
		pop ds
		int 21h
		push d_segm
		pop ds
		mov ax,4f05h
		xor bx,bx
		mov dl,[bank]
		int 10h
		push 5000h
		pop ds
		push 0a000h
		pop es
		xor si,si
		mov di,65535
		mov cx,1
		movsb
		push d_segm
		pop ds
		add [bank],10h
;--------------- вывод остальных полей --------------------
rep_read:	mov ah,3fh
		mov bx,[handle]
		mov cx,65535
		xor dx,dx
		push 5000h
		pop ds
		int 21h
		push d_segm
		pop ds
		mov ax,4f05h
		xor bx,bx
		mov dl,[bank]
		int 10h
		call draw_svga
;=============== последний pixel остальных полей =================
		push d_segm
		pop ds
		mov ah,3fh
		mov bx,[handle]
		mov cx,1
		xor dx,dx
		push 5000h
		pop ds
		int 21h
		push d_segm
		pop ds
		mov ax,4f05h
		xor bx,bx
		mov dl,[bank]
		int 10h
		push 5000h
		pop ds
		push 0a000h
		pop es
		xor si,si
		mov di,65535
		mov cx,1
		movsb
		push d_segm
		pop ds
		cmp [bank],70h			;ограничитель полей!
		jae wanna_fin
		add [bank],10h
		jmp rep_read
wanna_fin:	mov ah,0ch
		int 21h
		mov ah,7
		int 21h
		jmp svga_fin
svga_view	endp
;!!!!!!!!!!!!!!! подготовка рисунка к засветлению !!!!!!!!!!
ready_l 	proc
		push ds
		xor bl,bl
		push 6000h
		pop ds
		mov di,0
		mov dx,03dah
jjoo:		in al,dx
		test al,08h
		je jjoo
		xor al,al
		mov dx,03c8h
		out dx,al
		mov si,di
		mov cx,0300h
		inc dx
jjvv:		lodsb
		mul bl
		shr ax,6
		out dx,al
		loop jjvv
		pop ds
		ret
ready_l 	endp
;!!!!!!!!!!!!!!! засветление рисунка !!!!!!!!!!!!!!
light_now	proc
		xor bl,bl
		push 6000h
		pop ds
		mov di,0
jeee:		mov dx,03dah
jooj:		in al,dx
		test al,08h
		je jooj
		xor al,al
		mov dx,03c8h
		out dx,al
		mov si,di
		mov cx,0300h
		inc dx
jvvj:		lodsb
		mul bl
		shr ax,6
		out dx,al
		loop jvvj
		inc bl
		cmp bl,41h
		jne jeee
		ret
light_now	endp
;!!!!!!!!!!!!!!! затемнение рисунка !!!!!!!!!!!!
dark_now	proc
		push 6000h
		pop ds
		mov bl,3fh
jexe:		mov dx,03dah
joxo:		in al,dx
		test al,08h
		je joxo
		xor al,al
		mov dx,03c8h
		out dx,al
		mov si,0	    ;адрес палитры
		mov cx,0300h
		inc dx
jvxv:		lodsb
		mul bl
		shr ax,6
		out dx,al
		loop jvxv
		dec bl
		jne jexe
		ret
dark_now	endp
;подготовка к загрузке шрифтов в память
lorus		proc
		push d_segm
		pop ds
		xor di,di
		xor si,si
		call loadnamerus	;загрузка активного имени файла
		mov ah,0fh
		lea dx,fcbrec
		int 21h 		;OPEN FILE
		cmp al,0
		jz got
		ret
got:		mov ah,1ah
		mov dx,dtastart
		int 21h
		mov [block],0
		mov [lenzap],154
		mov [numczap],1
		mov cx,16
		xor di,di
		xor si,si
		push 3630h
		pop es			;куда загружаем FONTы
		xor bp,bp
		call loadgra		;загружаем FONTы
		mov ah,10h
		lea dx,fcbrec
		int 21h 		;close file
		ret
lorus           endp