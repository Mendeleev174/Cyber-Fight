;╒══════════════════════════════════════════════════════════════════════════╕
;│		C Y B E R   F I G H T		∙ die for future ∙	    │
;╞══════════════════════════════════════════════════════════════════════════╡
;│ ∙	    √	Create by -=AS=-					  ∙ │
;│	    √	April 1999						    │
;│	    √	Minimum Configuration:					    │
;│		- Central Processing Unit 486DX 			    │
;│		- RAM 1M						    │
;│		- Video Card SVGA with 512K				    │
;│		- Operating System : MS DOS 6.22 maybe less!		    │
;│	    √	Connected Files:					    │
;│		- fback   .dat _______________64000 bytes		    │
;│		- sback   .dat _______________64000 bytes		    │
;│		- tback   .dat _______________64000 bytes		    │
;│		- finback .dat _______________64000 bytes		    │
;│		- as	  .dat _______________33078 bytes		    │
;│		- acg	  .dat _______________33078 bytes		    │
;│		- menu_scr.dat _______________9503 bytes		    │
;│		- cyber   .dat _______________65078 bytes		    │
;│		- gameover.dat _______________65078 bytes		    │
;│		- assoft  .dat _______________481078 bytes		    │
;│		- overas  .dat _______________481078 bytes		    │
;│		- fonts   .dat _______________2618 bytes		    │
;│		- fonts_ru.dat _______________2618 bytes		    │
;│		- mes	  .dat _______________5376 bytes		    │
;│		- panel   .dat _______________7150 bytes		    │
;│		- main	  .dat _______________213671 bytes		    │
;│ ∙									  ∙ │
;╘══════════════════════════════════════════════════════════════════════════╛
;****************************************************************************
;*		FONTS.ART	==>3630h				    *
;*		ЗАСТАВКИ	==>9060h				    *
;*		MAIN.ART	==>4000h				    *
;****************************************************************************
c_segm		segment byte
		assume cs:c_segm,ds:d_segm
;****************************************************************************
;*		DATA SEGMENT						    *
;****************************************************************************
d_segm		segment
;===============  File Control Block  ====================
fcbrec		label byte	   ;<<< FCB >>>
disk		db    00	   ;накопитель
imya		db    '        '   ;имя файла
ext		db    'art'	   ;расширение
block		dw    0000	   ;номер текущего блока
lenzap		dw    ? 	   ;размер логической записи
lenfile 	dd    ? 	   ;размер файла(DOS)
		dw    ? 	   ;дата(DOS)
		dt    ? 	   ;reserved(DOS)
numczap 	db    00	   ;номер текущей записи
		dd    ? 	   ;относительный номер записи
;>>>>>>>>>>>>>>>>>>>   Константы   <<<<<<<<<<<<<<<<<<<<<<<<<<<<
dtastart	equ 4530h
sprbuf		equ 5630h
;---------------------------------------------------------------
god_mode	db 0			;режим бога отключён
color		db ?			;цвет
red		db ?			;R \
green		db ?			;G  (RGB)
blue		db ?			;B /
life_t101	db ?			;life of T101
mindfield	db 10 dup (?)		;буфер искусственного интеллекта
startup 	db ?			;пункт главного меню
type_game	db 3			;уровень интеллекта 1,2,3
;>>>>>>>>>>>>>>>>>>>   Переменные и Данные  <<<<<<<<<<<<<<<<<<<
t101_spr_si	dw ?			;reserved
t101_spr_ds	dw ?			;reserved
t101_new_si	dw ?			;reserved
t101_new_ds	dw ?			;reserved
t1000_spr_si	dw ?			;reserved
t1000_spr_ds	dw ?			;reserved
num_sprites	db ?			;how many sprites
mode_t101	db ?			;command of t101
busy_t101	db ?			;блокирование управления ,если %=1
kill_t101	db ?			;t101 мёртв?
game_over	db ?			;if %=1 then game over,t101 lost...
win		db ?			;if %=1 then we wins!!!
mod_t101	db ?			;CLEAR COMMAND OF T101!!!
;----------------------------------------------------------------
t1000_new_si	dw ?			;reserved
t1000_new_ds	dw ?			;reserved
num_s_t1000	db ?			;how many sprites
mode_t1000	db ?			;command of t1000
busy_t1000	db ?			;командный блок t1000 блокирован if=1
mod_t1000	db ?			;CLEAR COMMAND OF T1000 !!!
kill_t1000	db ?			;t1000 мёртв?
life_t1000	db ?			;life of t1000
backw		db 0			;отход T1000
round		db 0			;раунд
diet1000	db 0			;if 2 then out of level
diet101 	db 0			;if 2 then out of level
in_menu 	db 0			;user exit to main menu (if 1)
level		db ?			;номер уровня
;----------------------------------------------------------------
fun_key 	db ?			;1-функциональная 0-обычная клавиша
bank		db ?			;счётчик полей (банков) видеопамяти
handle		dw ?			;reserved (незнает только дебил)
stroka		dw ?			;кол-во строк в ABOUT GAME
positas 	dw ?			;позиционирование строк в ABOUT GAME
xymenu		dw 23040		;начальные координаты курсоро меню
wait_for_wait	db 0			;переменная синхронизации задержек
xor_addr	dw ?			;начало буфера XOR
xor_t1000	dw 31884		;XORовый буфер T1000
xor_t101	dw 37516		;XORовый буфер T101
y_t1000 	dw 95			;y coords of t1000 & t101
x_t1000 	dw 50			;x coords of t1000
x_t101		dw 195			;x coords of t101
alloc_term	dw 4000h		;начальный адрес загрузки терминаторов
step		dw ?			;счётчик адреса при печати заставки
line_count	db ?			;счётчик линий при печати заставки
message 	db 0			;if 0 then error!
memorystart	dw 7630h		;начало области для загрузки
groundname	db 'fback   dat'	;имя файла с фоном первого уровня
groundname3	db 'sback   dat'	;имя файла с фоном второго уровня
groundname2	db 'tback   dat'	;имя файла с фоном третьего уровня
groundname4	db 'finback dat'	;имя файла с фоном финального уровня
groundnamet	db 'main    dat'	;имя файла со спрайтами киборгов
groundnamef	db 'fonts   dat'	;имя файла со шрифтами
gra_mess	db 'mes     dat'	;имя файла с "LOAD"
panel_int	db 'panel   dat'	;имя файла с панелью к игровому экрану
name_rus	db 'fonts_rudat'	;имя файла с русским шрифтом
bmp_name	db 'as.dat',0		;файл с моей фотографией
bmp_acg 	db 'acg.dat',0		;файл с фотографией ACG
assoft_name	db 'assoft.dat',0	;файл с моей рекламой
overas_name	db 'overas.dat',0	;файл с сообщением о прохождении игры
cyber_name	db 'cyber.dat',0	;файл с понтовой заставкой
g_over_name	db 'gameover.dat',0	;файл с рисунком GAME OVER
mnu_name	db 'menu_scr.dat',0	;файл с надписью в меню
prtload 	db 'Sorry! You Don`t Have A File.','$';сообщение при ошибке загрузки
menu1		db 'START GAME$'
menu2_e 	db '   EASY   $'
menu3		db 'ABOUT GAME$'
menu4		db '   QUIT   $'
menu2_m 	db '  MEDIUM  $'
menu2_h 	db '   HARD   $'
;сообщения к первому уровню
mess_1_1	db 36,36,36,36,36,36,11,4,21,4,11,36,26,36,36,36,36,36,36,36
mess_1_2	db 36,2,7,4,12,8,2,0,11,36,36,5,0,2,19,14,17,24,36
mess_2_1	db 36,36,36,36,36,11,4,21,4,11,36,36,27,36,36,36,36,36,36,36
mess_2_2	db 36,36,36,36,36,8,13,3,20,18,19,17,24,36,36,36,36,36,36
mess_3_1	db 36,36,36,36,36,36,11,4,21,4,11,36,28,36,36,36,36,36,36,36
mess_3_2	db 36,36,13,20,2,11,4,0,17,36,18,19,0,19,8,14,13,36,36
mess_4_1	db 36,36,36,36,5,8,13,0,11,36,11,4,21,4,11,36,36,36,36,36
mess_4_2	db 36,36,19,7,4,36,18,10,24,38,18,2,17,0,15,4,17,36,36
mess_round1	db 36,36,36,36,36,17,14,20,13,3,36,36,14,13,4,36,36,36,36,36
mess_round2	db 36,36,36,36,36,17,14,20,13,3,36,36,19,22,14,36,36,36,36,36
mess_round3	db 36,36,36,36,17,14,20,13,3,36,36,19,7,17,4,4,36,36,36,36
;~~~~~~~~~~~~~~~ A B O U T  G A M E ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mess_info_as	db 2,34,13,16,12,13,2,18,34,8,3,15,26,34,14,13,10,13,33,34
		db 6,5,12,0,34,13,15,8,3,8,12,0,10,27,12,0,30,34,34,34
		db 8,4,5,30,32,8,16,9,18,16,16,17,2,5,12,12,13,3,13,34
		db 8,12,17,5,10,10,5,9,17,0,32,9,0,9,34,16,13,33,34,34
		db 14,5,15,12,8,9,0,34,22,5,10,13,2,5,22,5,16,9,13,33
		db 11,18,34,15,0,7,18,11,18,31,8,34,17,13,10,27,9,13,34,34
		db 22,5,10,13,2,5,9,34,16,34,12,5,22,5,10,13,2,5,33,34
		db 22,5,16,9,13,8,34,15,5,0,9,21,8,5,8,34,16,11,13,33
		db 6,5,17,34,14,15,13,17,8,2,13,16,17,13,30,17,27,34,34,34
		db 11,13,5,8,34,16,8,16,17,5,11,5,34,8,34,4,13,8,17,8
		db 4,13,34,9,13,12,21,0,31,31,31,34,34,34,34,34,34,34,34,34
		db 80 dup(34)
		db 34,34,34,34,34,34,34,33,36,0,35,36,33,34,34,34,34,34,34,34
mess_info_acg	db 80 dup(34)
		db 34,34,14,15,0,9,17,8,22,5,16,9,8,34,2,16,37,34,34,34
		db 34,34,34,34,3,15,0,19,8,22,5,16,9,13,5,34,34,34,34,34
		db 34,34,13,19,13,15,11,10,5,12,8,5,34,16,17,0,10,13,34,34
		db 34,15,5,0,10,27,12,26,11,32,1,10,0,3,13,4,0,15,30,34
		db 34,18,16,8,10,8,30,11,34,2,10,0,16,17,5,10,8,12,0,34
		db 34,34,9,15,0,16,13,9,33,0,12,4,15,5,30,34,34,34,34,34
		db 34,34,34,34,34,34,34,34,34,1,13,15,13,4,18,10,8,12,0,34
delay		dw 0
;--------------- глобальные константы --------------------------------------
halt_move	equ 2000		;задержка длительных нажатий
					;чем круче машина,тем больше константа
waiting 	equ 6			;число циклов задержки
d_segm		ends
;***************************************************************************
;			     LET'S  GO !!!				   *
;***************************************************************************
start:		mov al,ds:[82h]
		dec al
		cmp al,2eh
		jne not_key
		mov al,ds:[83h]
		dec al
		cmp al,66h
		jne not_key
		mov al,ds:[84h]
		dec al
		cmp al,6eh
		jne not_key
		mov al,ds:[85h]
		dec al
		cmp al,63h
		jne not_key
		push d_segm
		pop ds
		mov [god_mode],1	;если ключ /god тогда РЕЖИМ БОГА
		jmp main
not_key:	mov ax,d_segm
		mov ds,ax		;древний обычай
		jmp main		;переход в глобальный модуль
		include cyber.asm
		include intro.asm
		include about.asm
;****************************************************************************
;		ПРОЦЕДУРЫ , ПОДКЛЮЧАЕМЫЕ ЛОКАЛЬНЫЕ МОДУЛИ		      *
;****************************************************************************
;---------------  загрузка имени файла в FCB  ---------------
loadnameinfcb	proc
		mov cx,11
store_name:	mov al,[groundname+si]
		mov [imya+di],al
		inc si
		inc di
		loop store_name
		ret			;проще небывает...
loadnameinfcb	endp
;------------------------------------------------------------
loadnameinfcb3	proc
		mov cx,11
str_name:	mov al,[groundname3+si]
		mov [imya+di],al
		inc si
		inc di
		loop str_name
		ret
loadnameinfcb3	endp
;------------------------------------------------------------
loadnameinfcb2	proc
		mov cx,11
str_name2:	mov al,[groundname2+si]
		mov [imya+di],al
		inc si
		inc di
		loop str_name2
		ret
loadnameinfcb2	endp
;----------------  Load Fonts  ------------------------------
loadnameinfcbf	proc
		mov cx,11
store_namef:	mov al,[groundnamef+si]
		mov [imya+di],al
		inc si
		inc di
		loop store_namef
		ret
loadnameinfcbf	endp
;-------------------------------------------------------------
loadnameinfcbt	proc
		mov cx,11
store_namet:	mov al,[groundnamet+si]
		mov [imya+di],al
		inc si
		inc di
		loop store_namet
		ret
loadnameinfcbt	endp
;-------------------------------------------------------------
loadnameinmes	proc
		mov cx,11
sto_name:	mov al,[gra_mess+si]
		mov [imya+di],al
		inc si
		inc di
		loop sto_name
		ret
loadnameinmes	endp
;-------------------------------------------------------------
loadnamerus	proc
		mov cx,11
rus_rus:	mov al,[name_rus+si]
		mov [imya+di],al
		inc si
		inc di
		loop rus_rus
		ret
loadnamerus	endp
;-------------------------------------------------------------
loadnamepanel	proc
		mov cx,11
rus_int:	mov al,[panel_int+si]
		mov [imya+di],al
		inc si
		inc di
		loop rus_int
		ret
loadnamepanel	endp
;------------------------------------------------------------
loadnameinfcb4	proc
		mov cx,11
str_name4:	mov al,[groundname4+si]
		mov [imya+di],al
		inc si
		inc di
		loop str_name4
		ret
loadnameinfcb4	endp
;===========================================================================
;++++++++++  ЗАГРУЗКА СПРАЙТА В ПАМЯТЬ +++++++++++++++++++++++++++++++++++++
load_gra_s	proc
; in		   cx-Глобальный счётчик загрузки (вертикаль)
; in		   es:di-место в памяти под информацию
slibal: 	push cx 		;сохранить в CX
		mov ah,14h
		lea dx,fcbrec
		int 21h 		;загрузка
		cmp al,0
		jnz toloadmsgs		 ;if al=0 then OK
		mov cx,[lenzap] 	;локальный счётчик загрузки
changi: 	mov al,[dtastart+si]
		mov [es:[bp]+[di]],al	;определяем 20-ти разрядный адрес!
		inc si
		inc di
		loop changi
		xor si,si
		pop cx
		loop slibal
		ret			;выход из процедуры
toloadmsgs:	 jmp loadmsgs
;................  обработка ошибки при загрузке  ...................
loadmsgs:	 xor ax,ax
		mov al,3
		int 10h 		;EGA ON!
		lea dx,prtload
		mov ah,9
		int 21h 		;print message!
		pop cx
		pop es
		mov [message],1
		ret			;показываем на дверь
load_gra_s	endp
;++++++++++  ЗАГРУЗКА СПРАЙТА В ПАМЯТЬ ПО 20-РАЗРЯДНОМУ АДРЕСУ +++++++++++++
loadgra 	proc
; in		   cx-Глобальный счётчик загрузки (вертикаль)
; in		   es:di-место в памяти под информацию
slobal: 	push cx 		;сохранить в CX
		mov ah,14h
		lea dx,fcbrec
		int 21h 		;загрузка
		cmp al,0
		jnz toloadmsg		;if al=0 then OK
		mov cx,[lenzap] 	;локальный счётчик загрузки
change: 	mov al,[dtastart+si]
		mov [es:[bp]+[di]],al	;определяем 20-ти разрядный адрес!
		inc si
		inc di
		loop change
		xor si,si
		pop cx
		loop slobal
		mov ah,10h
		lea dx,fcbrec
		int 21h 		; З А К Р Ы Т И Е  Ф А Й Л А
		ret			;выход из процедуры
toloadmsg:	jmp loadmsg
;................  обработка ошибки при загрузке  ...................
loadmsg:	xor ax,ax
		mov al,3
		int 10h 		;EGA ON!
		lea dx,prtload
		mov ah,9
		int 21h 		;print message!
		pop cx
		pop es
		mov [message],1
		ret			;показываем на дверь
loadgra 	endp
;**************************************************************************
;		НАЛОЖЕНИЕ СПРАЙТОВ ПО  X  O  R				  *
;**************************************************************************
;		dx-vertical (0-199)					  *
;		di-horisontal (0-319)==>экранный адрес (stosB)		  *
;		si-смещение в буфере спрайтов				  *
;		ah-  0-clear :	1-draw					  *
;		ds-адрес спрайтов					  *
;   ===>   *	XOR_ADDR-адрес спрайтового буфера по XOR		  *
;		cx-length sprite to vertical				  *
;		bx-length sprite to horisontal				  *
;**************************************************************************
xoring		proc
		push dx
		push di
		push bx
		push ax
		push si
		push ds
		push ax
		push cx
		xor ax,ax
		mov cx,dx
addect: 	adc ax,320
		loop addect
		adc di,ax
		pop cx
		pop ax			;вычисление экранного адреса из X и Y
		xor bp,bp		;WARNING:20_TH address DESABLED!!!
		push 0a000h
		pop es
todethi:	push cx
		mov cx,bx
dethi:		cmp ah,0
		jz tocleari
		lodsb			;byte from buffer of sprites
		dec si
		cmp al,0
		jnz not_zero		;если чёрный,значит фон
		mov al,[es:di]
not_zero:	mov dl,[es:di]		;не чёрный
		xor dl,al		;ксорим
;---------------into XOR buffer--------------------
		push ds
		push d_segm
		pop ds
		push [xor_addr]
		pop ds
		mov [ds:di],dl		;запихиваем в буфер
		pop ds
;--------------------------------------------------
		jmp letisgo
tocleari:	mov al,[es:di]
;---------------from XOR buffer--------------------
		push ds
		push d_segm
		pop ds
		push [xor_addr]
		pop ds
		mov dl,[ds:di]		;выталкиваем из буфера
		pop ds
;--------------------------------------------------
		xor al,dl		;ксорим обратно
letisgo:	stosb
		inc si
		loop dethi
		mov dx,320
		sub dx,bx
		adc di,dx
		pop cx
		loop todethi
		pop ds
		pop si
		pop ax
		pop bx
		pop di
		pop dx
		ret
xoring		endp
;*************** процедура печати и удаления спрайта на экране ************
;		dx-vertical (0-199)					  *
;		di-horisontal (0-319)==>экранный адрес (stosB)		  *
;		si-смещение в буфере спрайтов				  *
;		bp-20_ти разрядное смещение в буфере спрайтов		  *
;		ah-  0-clear :	1-draw					  *
;		ds-адрес спрайтового буфера в XMS			  *
;   ===>   *	SPRBUF-адрес спрайтового буфера в XMS			  *
;		cx-length sprite to vertical				  *
;		bx-length sprite to horisontal				  *
;**************************************************************************
anim_new	proc
		push cx
		push dx
		push di
		push bx
		push ax
		push si
		push ds
		push ax
		push cx
		xor ax,ax
		mov cx,dx
addict: 	adc ax,320
		loop addict
		adc di,ax
		pop cx
		pop ax			;вычисление экранного адреса из X и Y
;		 push sprbuf
;		 pop ds
		xor bp,bp		;WARNING:20_TH address DESABLED!!!
		push 0a000h
		pop es
todeth: 	push cx
		mov cx,bx
deth:		cmp ah,0
		jz toclear
		mov al,[ds:[bp]+[si]]
		jmp letsgo
toclear:	mov al,0
letsgo: 	stosb
		inc si
		loop deth
		mov dx,320
		sub dx,bx
		adc di,dx
		pop cx
		loop todeth
		pop ds
		pop si
		pop ax
		pop bx
		pop di
		pop dx
		pop cx
		ret
anim_new	endp
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;!		SET PALETTE						    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
setpalette	proc
		mov dx,3c8h
		mov al,[color]
		out dx,al
		inc dx
		mov al,[red]
		out dx,al
		mov al,[green]
		out dx,al
		mov al,[blue]
		out dx,al
		ret
setpalette	endp
;============================================================================
;=		palette halt						    =
;============================================================================
pal_halt	proc
;--------------- 40000\1000000ms--------
		push ax
		push bx
		push cx
		push dx
		mov ah,86h
		mov cx,0000h
		mov dx,09c40h
		int 15h
		pop dx
		pop cx
		pop bx
		pop ax
		ret
pal_halt	endp
;***************  нарисовать заставку с адреса 9060h  ***********************
s_drive 	proc
		push es
		push ds
		push di
		push si
		push 9060h
		pop ds
		push 0a000h
		pop es
		xor di,di
		xor si,si
		mov cx,64000
		rep movsb
		pop si
		pop di
		pop ds
		pop es
		ret
s_drive 	endp
;----------------------------------------------------------------------------
readkey 	proc
		mov ah,1
		int 16h
		ret
readkey 	endp
;----------------------------------------------------------------------------
getch		proc
		mov ah,1		;xor ah,ah
		int 16h
		or al,al
		jnz noal
		xchg ah,al
		add al,32
		jmp short noah
noal:		xor ah,ah
		cmp al,32
		jb noah
		inc ah
noah:		or ah,ah
		ret
getch		endp
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;!		ОЧИСТКА ЭКРАНА						    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
clrscr		proc
		push es
		xor di,di
		push 0a000h
		pop es
		mov cx,64000
		mov al,0
		rep stosb
		pop es
		ret
clrscr		endp
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;!		LOADING BASIC BACKGROUND				    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
lbb		proc
		mov ah,0fh
		lea dx,fcbrec
		int 21h 		;OPEN FILE!
		cmp al,0
		jnz gotoofin		;if al<>0 then error
		mov ah,1ah
		mov dx,dtastart
		int 21h 		;activate DTA
		mov [block],0
		mov [lenzap],320
		mov [numczap],0
		mov cx,200		;данные для загрузки (вертикаль)
		xor di,di
		xor si,si
		push 9060h		;сегмент адреса
		pop es
		xor bp,bp		;BASE for 20-digital memory
		call loadgra		;загружаем фон (заставку)!!!
		mov ah,10h
		lea dx,fcbrec
		int 21h 		;close file
		cmp [message],0
		jz loadokok		;if message=1 then error
gotoofin:	jmp error_open
loadokok:	ret
lbb		endp
;----------------------------------------------------------------------------
;		DECODER_FONT		буфер 3430h			    -
;----------------------------------------------------------------------------
decoder_font	proc
		push bx
		push ax
		push di
		push si
		push ds
		push es
		push 3630h
		pop ds			;шрифты
		push 3430h		;буфер для печати
		pop es
		xor di,di
		xor ah,ah
		mov si,ax
		mov bl,7
		mul bl
		cmp si,22
		jb notbig
		add ax,1078;1232		;увеличение ряда
notbig: 	mov si,ax
		mov cx,8		;ряды
decod:		push cx
		mov cx,7
replace:	lodsb
		stosb
		loop replace
		add si,147
		pop cx
		loop decod		;переместили (я надеюсь)
		pop es
		pop ds
		pop si
		pop di
		pop ax
		pop bx
		ret
decoder_font	endp
;============================================================================
;		Печатаем сообщение для первого уровня			    =
;============================================================================
message_1	proc
		cmp [level],1
		jne more_11
		lea si,mess_1_1 	;данные сообщения
		jmp prt_prt
more_11:	cmp [level],2
		jne more_ya
		lea si,mess_2_1
		jmp prt_prt
more_ya:	cmp [level],3
		jne ggg_4
		lea si,mess_3_1
		jmp prt_prt
ggg_4:		lea si,mess_4_1
prt_prt:	mov cx,20		;кол-во символов в сообщении
		mov ah,1
		mov dx,80		;VER
		mov di,90		;HOR
		mov bx,7
prt_mes:	push cx
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
;--------------- halting -----------------
;--------------- 80000\1000000ms--------
		push ax
		push bx
		push cx
		push dx
		mov ah,86h
		mov cx,0001h
		mov dx,3880h
		int 15h
		pop dx
		pop cx
		pop bx
		pop ax
;--------------- halting -----------------
		pop cx
		loop prt_mes		;напечатали первую строку сообщения
;второе сообщение
		cmp [level],1
		jne more_12
		lea si,mess_1_2 	;данные сообщения
		jmp prt_prt2
more_12:	cmp [level],2
		jne more_see
		lea si,mess_2_2
		jmp prt_prt2
more_see:	cmp [level],3
		jne gggg_4
		lea si,mess_3_2
		jmp prt_prt2
gggg_4: 	lea si,mess_4_2
prt_prt2:	mov cx,19		;кол-вво символов в сообщении
		mov dx,100		;VER
		mov di,90		;HOR
prt_mes2:	push cx
		lodsb
		call decoder_font
		push si
		push ds
		push 3430h
		pop ds
		mov cx,8
		xor si,si
		call anim_new
		pop ds
		pop si
		adc di,7
;--------------- halting ----------------
;--------------- 80000\1000000ms--------
		push ax
		push bx
		push cx
		push dx
		mov ah,86h
		mov cx,0001h
		mov dx,3880h
		int 15h
		pop dx
		pop cx
		pop bx
		pop ax
;--------------- halting ----------------
		pop cx
		loop prt_mes2
		ret
message_1	endp
;============================================================================
;=		ПЕЧАТЬ РАУНДА						    =
;============================================================================
now_round	proc
		cmp [round],1
		ja more_1
		lea si,mess_round1	;данные сообщения
		jmp good_round
more_1: 	cmp [round],2
		ja more_2
		lea si,mess_round2
		jmp good_round
more_2: 	lea si,mess_round3
good_round:	mov cx,20		;кол-во символов в сообщении
		mov ah,1
		mov dx,80		;VER
		mov di,90		;HOR
		mov bx,7
prt_mes_r:	push cx
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
		loop prt_mes_r
;--------------- halting -----------------
;--------------- 3 sec---------------------
		push ax
		push bx
		push cx
		push dx
		mov ah,86h
		mov cx,002dh
		mov dx,0c6c0h
		int 15h
		pop dx
		pop cx
		pop bx
		pop ax
;--------------- halting -----------------
		ret
now_round	endp
;============================================================================
;		ВЫВОДИМ НА ЭКРАН ПОКАЗАТЕЛИ ЭНЕРГИИ			    =
;============================================================================
set_power	proc
		push es
		push 0a000h
		pop es
		mov dx,63680		;указатель первой шкалы
		mov bx,63985		;указатель второй шкалы
		mov al,40		;цвет
		mov cx,24		;в высоту CX
power_up:	push cx
		mov cx,15
		mov di,dx
		rep stosb
		sub di,335
		mov dx,di		;сохранение новых параметров
		mov cx,15
		mov di,bx
		rep stosb
		sub di,335
		mov bx,di
		pop cx
		cmp cx,17
		jae not_green
		mov al,49		;зелёная полоска
not_green:	;hlt
;--------------- halting --------------
;--------------- 80000\1000000ms--------
		push ax
		push bx
		push cx
		push dx
		mov ah,86h
		mov cx,0001h
		mov dx,3880h
		int 15h
		pop dx
		pop cx
		pop bx
		pop ax
;--------------- halting --------------
		loop power_up
		pop es
		ret
set_power	endp
;============================================================================
;		УМЕНЬШАЕМ ЭНЕРГИЮ У T101				    =
;============================================================================
power_down	proc
		push es
		push 0a000h
		pop es
		mov di,56625
		xor ah,ah
		mov al,24		;истинная высота укозателя
		sub al,[life_t101]	;на сколько уменьшаем
		xchg cx,ax		;AX-->CX
		mov al,0		;цвет фона
draw_row:	push cx
		mov cx,15		;ширина укозателя
		rep stosb		;draw line
		add di,305
		pop cx
		loop draw_row
		pop es
		ret
power_down	endp
;============================================================================
;		УМЕНЬШАЕМ ЭНЕРГИЮ У T1000				    =
;============================================================================
power_down_2	proc
		push es
		push 0a000h
		pop es
		mov di,56320
		xor ah,ah
		mov al,24		;истинная высота укозателя
		sub al,[life_t1000]	;на сколько уменьшаем
		xchg cx,ax		;AX-->CX
		mov al,0		;цвет фона
sdraw_row:	push cx
		mov cx,15		;ширина укозателя
		rep stosb		;draw line
		add di,305
		pop cx
		loop sdraw_row
		pop es
		ret
power_down_2	endp
;============================================================================
;		Загрузка спрайтов терминаторов				    =
;============================================================================
load_cyborgs	proc
		xor si,si
		xor di,di
		call loadnameinfcbt
		mov ah,0fh
		lea dx,fcbrec
		int 21h 		;OPEN FILE
		cmp al,0
		jnz gototofin
		mov ah,1ah
		mov dx,dtastart
		int 21h
		mov [block],0
		mov [lenzap],73
		mov [numczap],1
		mov ax,[alloc_term]
		mov es,ax		;адрес "терминаторов в ES"
		mov cx,3		;кол-во повторов загрузки
l_term: 	push es
		push cx
		mov cx,847
		xor bp,bp
		xor di,di
		xor si,si
		call load_gra_s
		pop cx
		pop ax
		add ax,3865
		mov es,ax
		loop l_term
		mov cx,385
		xor di,di
		xor si,si
		call loadgra
		mov ah,10h
		lea dx,fcbrec
		int 21h 		;close file
		ret		;непойму,как я умудрился её написать... :-|
gototofin:	jmp error_open
load_cyborgs	endp
;----------------------------------------------------------------------------
;		ПЕЧАТЬ НАЧАЛЬНОГО ПОЛОЖЕНИЯ БОЙЦОВ			    -
;----------------------------------------------------------------------------
print_fighters	proc
		push ds
;--------------- T1000 -------------------------
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,0
		mov [t1000_spr_si],si
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,1
		push ds
		push 4000h
		pop ds
		call xoring
		pop ds
		mov [t1000_spr_ds],4000h
;--------------- T101 ---------------------------
		mov di,[x_t101]
		mov si,44968
		mov [t101_spr_si],si
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,1
		push ds
		push 4f19h
		pop ds
		call xoring
		pop ds
		mov [t101_spr_ds],4f19h
		pop ds
		ret
print_fighters	endp
;****************************************************************************
;*		Decoder & Show Crypting Text				    *
;****************************************************************************
decoder 	proc
		push ds
		push c_segm
		pop ds
		push 4000h
		pop es
		xor di,di
		mov cx,bx		;загружаем счетчик данных
		rep movsb		;перемещаем данные в 4000:0000
		xor di,di
		mov cx,bx
recode: 	mov al,[es:di]
		xor al,25
		stosb
		loop recode		;раскриптовываем
		push 4000h
		pop ds
		mov ah,9
		mov dx,0
		int 21h 		;печатаем раскриптованный текст
		pop ds
		ret
decoder 	endp
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;!		Coded Copyright 					    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
copyright	db 31h,7ah,30h,39h,28h,20h,20h,20h,39h,39h,5ah,40h,5bh,5ch
		db 4bh,39h,5fh,50h,5eh,51h,4dh,39h,7ah,76h,7dh,7ch,7dh,39h
		db 7bh,60h,39h,34h,24h,58h,4ah,24h,34h,3dh
		;(c) 1999  CYBER FIGHT coded by -=AS=-
aspresent	db 34h,24h,58h,4ah,24h,34h,39h,39h,49h,4bh,5ch,4ah,5ch,57h
		db 4dh,3dh
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;		ИСПОЛНЕНИЕ ЗАДАННОЙ ФАЗЫ				    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
animation	proc
;--------------- СТОЙКА -------------------
		cmp [mode_t101],0
		jne next_1
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		mov [busy_t101],0
		mov [mod_t101],0
		mov ah,0ch
		int 21h
		ret
;---------------  BLOCK  -------------------------
next_1: 	cmp [mode_t101],1
		jne next_2
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0		;delete
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;delete old sprite
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds			;print block
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		mov ah,0ch
		int 21h
;--------------- 50000\1000000ms--------
		push ax
		push dx
		mov ah,86h
		mov cx,0000h
		mov dx,0c350h
		int 15h
		pop dx
		pop ax
cfc:		call getch
		cmp al,111
		je fdf
		mov [mode_t101],0
		mov [num_sprites],1
		mov [t101_new_si],44968
		mov [t101_new_ds],4f19h
fdf:		ret
;---------------  DOWN	----------------------
next_2: 	cmp [mode_t101],2
		jne nexxt_3
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		dec [num_sprites]
		cmp [num_sprites],0
		jnz con_u
		jmp dsd
nexxt_3:	jmp next_3
dsd:
		call getch
		cmp al,112
		jne ere
		mov [num_sprites],1
		mov [mode_t101],2
		mov [t101_new_si],16863
		mov [t101_new_ds],5e32h
		mov ah,0ch
		int 21h
		ret				;встаём!
ere:		cmp al,114
		jne gyg
		mov [mod_t101],7
		mov [mode_t101],3
		mov [num_sprites],2
		mov [t101_new_si],22484
		mov [t101_new_ds],5e32h
		ret
gyg:
		mov [num_sprites],1
		mov [mode_t101],4
		mov [t101_new_si],11242
		ret
con_u:		add [t101_new_si],5621
		ret
;--------------- PUNCH --------------------
next_3: 	cmp [mode_t101],3
		jne next_4
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		dec [num_sprites]
		cmp [num_sprites],0
		jnz also_punch
		mov [num_sprites],1
		mov [mode_t101],4
		sub [t101_new_si],5621
		ret
also_punch:	add [t101_new_si],5621
		ret
;---------------  BACKWARD PUNCH  --------------------
next_4: 	cmp [mode_t101],4
		jne next_5
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		jmp stop_mode_t101
		ret
;--------------- НЕЗНАЧИТЕЛЬНОЕ ПОПАДАНИЕ ---------------------
next_5: 	cmp [mode_t101],5
		jne next_6
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		cmp [x_t101],246	;!!!warning!!!
		jae stop_out		;!!!warning!!!
		add [x_t101],2
stop_out:	mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds			;draw new sprite in new place
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		dec [num_sprites]
		cmp [num_sprites],0
		jz sstop_ode_t101
		add [t101_new_si],5621
		ret
sstop_ode_t101: jmp stop_mode_t101
;--------------- ПАДЕНИЕ НА ПОЛ T101 --------------------------
next_6: 	cmp [mode_t101],6
		jne next_7
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		cmp [x_t101],246	;!!!warning!!!
		jae out_stopp		;!!!warning!!!
		add [x_t101],2
out_stopp:	mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds			;draw new sprite in new place
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		dec [num_sprites]
		cmp [num_sprites],0
		jz ttpop_ode_t101
		add [t101_new_si],5621
ttpop_ode_t101: ret
next_7: 	cmp [mode_t101],7
		jne next_8

next_8: 	cmp [mode_t101],8
		jne next_9

;--------------- LEFT ---------------------
next_9: 	cmp [mode_t101],9
		jne next_10
		mov ax,[x_t1000]
		add ax,74		;дистанция удара (pixels)
		cmp [x_t101],ax
		jbe stop_t101_2
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		jmp this_jump
next_10:	jmp next_10_2
stop_t101_2:	jmp stop_t101
this_jump:	sub [x_t101],2
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds			;print new sprite in new place
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		dec [num_sprites]
		cmp [num_sprites],0
		jz stop_mode_t101
		add [t101_new_si],5621
		ret
stop_mode_t101: mov [mode_t101],0
		mov [num_sprites],1
		mov [t101_new_si],44968
		mov [t101_new_ds],4f19h
		ret
stop_t101:	jmp stop_mode_t101;mov [busy_t101],0
		ret
;---------------  RIGHT  ----------------------
next_10_2:	cmp [x_t101],246
		jae stop_mode_t101
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		add [x_t101],2
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds			;draw new sprite in new place
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		dec [num_sprites]
;--------------- причудлив ли удар? ------------
		call getch
		cmp al,114		;"причудливый удар рукой"
		jne nnot_sp
;Да,причудлив.Стираем спрайт и перемещаем координаты на старое место
		cmp [num_sprites],0
		jnz spr_nz
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		sub [x_t101],2		;ОПАСНЫЙ СДВИГ НА 4(2)
cont_spr:	mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds			;draw new sprite in new place
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		jmp spr_ok
nnot_sp:	jmp not_sp
spr_nz: 	cmp [num_sprites],1
		ja spr_ok		;этот путь не реализуется!!! 8-|
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		sub [x_t101],2		;ОПАСНЫЙ СДВИГ НА 2
		jmp cont_spr
spr_ok: 	mov [num_sprites],2
		mov [mod_t101],5
		mov [mode_t101],3
		mov [t101_new_si],33726
		mov [t101_new_ds],5e32h
		ret
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
not_sp: 	cmp al,115		;"причудливый пинок"
		jne gget_right
;Стираем старый спрайт и координаты на старое место
		cmp [num_sprites],0
		jnz spr_nz_2
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		sub [x_t101],2		;WARNING!!!4(2)
cont_spr_2:	mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t101_new_ds]
		pop ds
		call xoring
		pop ds			;draw new sprite in new place
		mov ax,[t101_new_si]
		mov [t101_spr_si],ax
		mov ax,[t101_new_ds]
		mov [t101_spr_ds],ax
		jmp spr_ok_2
gget_right:	jmp get_right
spr_nz_2:	cmp [num_sprites],1
		ja spr_ok_2		;этот путь не реализуется!!! 8-|
		mov dx,[y_t1000]
		mov di,[x_t101]
		mov si,[t101_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t101]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t101_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		sub [x_t101],2
		jmp cont_spr_2
spr_ok_2:	mov [num_sprites],2
		mov [mod_t101],6
		mov [mode_t101],3
		mov [t101_new_si],44968
		mov [t101_new_ds],5e32h
		ret
get_right:	cmp [num_sprites],0
		jz sstop_mode_t101
		sub [t101_new_si],5621
		ret
sstop_mode_t101: jmp stop_mode_t101
animation	endp
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;		CHECK IMPACT						    @
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
check_impact	proc
		mov ax,[x_t101]
		sub ax,75
		mov bx,[x_t1000]
		cmp bx,ax
		jae to_work		;мразь рядом ? если нет,то выход...
no_work:	mov al,0		;NO DANGER!
		ret			;врага нет - проверки нет!
to_work:	cmp [busy_t1000],0
		jz no_work		;опасен ли ? NO - YES
		cmp [mod_t1000],3
		je finded3
		cmp [mod_t1000],4
		je finded4
		cmp [mod_t1000],5
		je finded5
		cmp [mod_t1000],6
		je finded6
		cmp [mod_t1000],7
		je finded7
		jmp no_work		;УРА!!! БИТЬ НЕ БУДУТ!!!
finded3:	cmp [t1000_spr_si],11242
		jne no_work
		jmp finded
finded4:	cmp [t1000_spr_si],22484
		jne no_work
		jmp finded
finded5:	cmp [t1000_spr_si],56210
		jne no_work
		jmp finded
finded6:	cmp [t1000_spr_si],5621
		jne no_work
		jmp finded
finded7:	cmp [t1000_spr_si],44968
		jne no_work
;--------------- наши действия ------------------
finded: 	cmp [busy_t101],0
		jz fucker
		jmp no_work		;I am OKay!
fucker: 	cmp [mode_t101],1
		jne nexted
		jmp no_work
nexted: 	cmp [mode_t101],2
		jne yipe
		jmp no_work
;--------------- Сейчас нас будут бить ногами по животу -------------------
yipe:		cmp [life_t101],2
		je final_kick		;последний удар по нам
		cmp [god_mode],1
		je we_immortals 	;you are immortal?
		sub [life_t101],2	;<<< УМЕНЬШЕНИЕ ЖИЗНЕЙ T101 >>>
we_immortals:	mov [busy_t101],1
		mov [mode_t101],5	;незначительное попадание
		mov [num_sprites],2
		mov [t101_new_si],0
		mov [t101_new_ds],6d4bh
		call animation
;--------------- 80000\1000000ms--------
		push ax
		push bx
		push cx
		push dx
		mov ah,86h
		mov cx,0001h
		mov dx,5f90h
		int 15h
		pop dx
		pop cx
		pop bx
		pop ax
;---------------------------------------
		mov [backw],2
		cmp [god_mode],1
		je immortals		;порверка на бессмертие
		call power_down 	;уменьшение энергии
immortals:	ret
final_kick:	sub [life_t101],2
		mov [busy_t101],1
		mov [mode_t101],6	;полная нейтрализция T101
		mov [num_sprites],3
		mov [t101_new_si],0
		mov [t101_new_ds],6d4bh
		call animation
		mov [kill_t101],1	;if KILL=1 then t101 must die!
		call power_down 	;уменьшение энергии
		ret
check_impact	endp
;############################################################################
;		A R N O L D   (  T  1 0 1  )				    #
;############################################################################
arnold		proc
		cmp [kill_t101],0	;запинали нас?
		jz t101_life		;НЕТ!
		cmp [num_sprites],0	;В НАСТОЯЩИЙ МОМЕНТ ЗАПИНЫВАЮТ 8-(
		jnz reepp
		mov [game_over],1	;ВСЁ...ЗАПИНАЛИ КАК ФУФАЙКУ...:-(
		ret
reepp:		jmp repp
t101_life:	call check_impact	;проверка на удар по T101
		call getch		;запрос клавиши
		jz funk
		mov [fun_key],0
		jmp f_ok
funk:		mov [fun_key],1
f_ok:		cmp ax,0064h		;if F10 then quit to Menu
		jne noex
		cmp [fun_key],0
		jz noex 		;если клавиша не функциональная-продолжаем
		mov [in_menu],1
		ret			;Exit To Menu
noex:		jmp repp
repp:		cmp [busy_t101],0
		jz togetch		;if zero then read mode
		call animation		;исполнение заданной фазы
		ret
togetch:	cmp al,61h
		jne totogetch
		ret
totogetch:	cmp [fun_key],1
		je fun_fun
		jmp no_kick
fun_fun:	cmp al,107		;LEFT
		jne no_left
		mov [mod_t101],9
		mov [busy_t101],1	;mode is on
		mov [mode_t101],9	;code 9 is move (ходьба)
		mov [num_sprites],2	;кол-во кадров
		mov [t101_new_si],16863
		mov [t101_new_ds],6d4bh
		call animation		;исполнение заданной фазы
		mov ah,0ch
		int 21h
		ret
no_left:	cmp al,109		;RIGHT
		jne no_right
		mov [mod_t101],10
		mov [busy_t101],1	;mode is on
		mov [mode_t101],10	;code 10 is move right
		mov [num_sprites],2	;how much sprites
		mov [t101_new_si],22484
		mov [t101_new_ds],6d4bh
		call animation		;activate current mode
		mov ah,0ch
		int 21h
		ret
no_right:	cmp al,111		;BLOCK
		jne no_block
		mov [mod_t101],1
		mov [busy_t101],1	;mode is on
		mov [mode_t101],1	;code 1 is block
		mov [num_sprites],1	;how much sprites
		mov [t101_new_si],56210
		mov [t101_new_ds],5e32h
		call animation
		mov ah,0ch
		int 21h
		ret
no_block:	cmp al,112
		jne no_down		;ПРИСЕД
		mov [mod_t101],2
		mov [busy_t101],1	;mode is on
		mov [mode_t101],2	;code 2 is down
		mov [num_sprites],2	;how much sprites
		mov [t101_new_si],11242
		mov [t101_new_ds],5e32h
		call animation
		mov ah,0ch
		int 21h
		ret
no_down:	cmp al,114		;УДАР РУКОЙ
		jne no_punch
		mov [mod_t101],3
		mov [busy_t101],1	;mode is set
		mov [mode_t101],3	;code 3 is punch (simply)
		mov [num_sprites],2	;how much sprites
		mov [t101_new_si],50589
		mov [t101_new_ds],4f19h
		call animation
		mov ah,0ch
		int 21h
		ret
no_punch:	cmp al,115		;ПИНОК
		jne no_kick
		mov [mod_t101],4
		mov [busy_t101],1	;mode is set
		mov [mode_t101],3	;code 3 is kick (simply)
		mov [num_sprites],2	;how much sprites
		mov [t101_new_si],0
		mov [t101_new_ds],5e32h
		call animation
		mov ah,0ch
		int 21h
		ret
no_kick:	mov ah,0ch
		int 21h
		ret
arnold		endp
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;		ИСПОЛНЕНИЕ ЗАДАННОЙ ФАЗЫ T1000				    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
move_t1000	proc
		cmp [wait_for_wait],0
		jnz dont_halt		;если T101 "стоИт",тогда задержка
;--------------- 80000\1000000ms--------
		push ax
		push bx
		push cx
		push dx
		mov ah,86h
		mov cx,0001h
		mov dx,5f90h
		int 15h
		pop dx
		pop cx
		pop bx
		pop ax
dont_halt:	mov [wait_for_wait],0
;--------------- СТОЙКА T1000-------------------
		cmp [mode_t1000],0
		jne next_1_t1000
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t1000_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_new_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,1
		push ds
		push [t1000_new_ds]
		pop ds
		call xoring
		pop ds
		mov ax,[t1000_new_si]
		mov [t1000_spr_si],ax
		mov ax,[t1000_new_ds]
		mov [t1000_spr_ds],ax
		mov [busy_t1000],0
		ret
next_1_t1000:
;---------------  BLOCK  -------------------------
		cmp [mode_t1000],1
		jne next_3_t1000
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,0		;delete
		push ds
		push [t1000_spr_ds]
		pop ds
		call xoring
		pop ds			;delete old sprite
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t1000_new_ds]
		pop ds
		call xoring
		pop ds			;print block
		mov ax,[t1000_new_si]
		mov [t1000_spr_si],ax
		mov ax,[t1000_new_ds]
		mov [t1000_spr_ds],ax
		jmp stop_mode_t1000
		ret
next_3_t1000:
;--------------- PUNCH --------------------
		cmp [mode_t1000],3
		jne next_4_t1000
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t1000_spr_ds]
		pop ds
		call xoring
		pop ds
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t1000_new_ds]
		pop ds
		call xoring
		pop ds
		mov ax,[t1000_new_si]
		mov [t1000_spr_si],ax
		mov ax,[t1000_new_ds]
		mov [t1000_spr_ds],ax
		dec [num_s_t1000]
		cmp [num_s_t1000],0
		jnz aso_punch
		mov [num_s_t1000],1
		mov [mode_t1000],4
		sub [t1000_new_si],5621
		ret
aso_punch:	add [t1000_new_si],5621
		ret
;---------------  BACKWARD PUNCH  --------------------
next_4_t1000:	cmp [mode_t1000],4
		jne next_6_t1000
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t1000_spr_ds]
		pop ds
		call xoring
		pop ds
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t1000_new_ds]
		pop ds
		call xoring
		pop ds
		mov ax,[t1000_new_si]
		mov [t1000_spr_si],ax
		mov ax,[t1000_new_ds]
		mov [t1000_spr_ds],ax
sto_mode_t1000: jmp stop_mode_t1000
		ret
;--------------- DETH OF THE CYBORG T1000 -----------------
next_6_t1000:	cmp [mode_t1000],6
		jne next_12_t1000
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t1000_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		cmp [x_t1000],0
		jz out_limit
		sub [x_t1000],2
out_limit:	mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t1000_new_ds]
		pop ds
		call xoring
		pop ds			;draw new sprite in new place
		mov ax,[t1000_new_si]
		mov [t1000_spr_si],ax
		mov ax,[t1000_new_ds]
		mov [t1000_spr_ds],ax
		dec [num_s_t1000]
		cmp [num_s_t1000],0
		jz oop_mode_t101
		add [t1000_new_si],5621
oop_mode_t101:	ret
;--------------- НЕЗНАЧИТЕЛЬНОЕ ПОПАДАНИЕ В T1000 ---------------
next_12_t1000:	cmp [mode_t1000],12
		jne next_9_t1000
;		cmp [x_t1000],0
;		je poop_mode_t101
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t1000_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		cmp [x_t1000],0
		jz stop_limit
		sub [x_t1000],2
stop_limit:	mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t1000_new_ds]
		pop ds
		call xoring
		pop ds			;draw new sprite in new place
		mov ax,[t1000_new_si]
		mov [t1000_spr_si],ax
		mov ax,[t1000_new_ds]
		mov [t1000_spr_ds],ax
		dec [num_s_t1000]
		cmp [num_s_t1000],0
		jz poop_mode_t101
		add [t1000_new_si],5621
		ret
poop_mode_t101: jmp stop_mode_t1000
next_9_t1000:
;--------------- RIGHT ---------------------
		cmp [mode_t1000],9
		jne next_10_t1000
		mov ax,[x_t101]
		sub ax,74		;дистанция удара (pixels)
		cmp [x_t1000],ax
		jae stp_t101_2
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t1000_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		jmp tthis_jump
next_10_t1000:	jmp next_10_2_t
stp_t101_2:	jmp stop_t1000
tthis_jump:	add [x_t1000],2
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t1000_new_ds]
		pop ds
		call xoring
		pop ds			;print new sprite in new place
		mov ax,[t1000_new_si]
		mov [t1000_spr_si],ax
		mov ax,[t1000_new_ds]
		mov [t1000_spr_ds],ax
		dec [num_s_t1000]
		cmp [num_s_t1000],0
		jz stop_mode_t1000
		add [t1000_new_si],5621
		ret
stop_mode_t1000: mov [mode_t1000],0
		mov [num_s_t1000],1
		mov [t1000_new_si],0
		mov [t1000_new_ds],4000h
		ret
stop_t1000:	jmp stop_mode_t1000
		ret
next_10_2_t:
;---------------  LEFT	----------------------
		cmp [x_t1000],0
		je stop_mode_t1000
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_spr_si]
		mov cx,77
		mov bx,73
		mov ax,[xor_t1000]
		mov [xor_addr],ax
		mov ah,0
		push ds
		push [t1000_spr_ds]
		pop ds
		call xoring
		pop ds			;clear old sprite
		sub [x_t1000],2
		mov dx,[y_t1000]
		mov di,[x_t1000]
		mov si,[t1000_new_si]
		mov cx,77
		mov bx,73
		mov ah,1
		push ds
		push [t1000_new_ds]
		pop ds
		call xoring
		pop ds			;draw new sprite in new place
		mov ax,[t1000_new_si]
		mov [t1000_spr_si],ax
		mov ax,[t1000_new_ds]
		mov [t1000_spr_ds],ax
		dec [num_s_t1000]
		cmp [num_s_t1000],0
		jz top_mode_t101
		sub [t1000_new_si],5621
		ret
top_mode_t101: jmp stop_mode_t1000
move_t1000	endp
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;		CHECK MY SELF T1000					    @
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
check_myself	proc
		mov ax,[x_t101]
		sub ax,75
		cmp ax,-2		;если переход за границу экрана...
		jne not_unsigned
		mov ax,0		;...тогда определяем границу
not_unsigned:	mov bx,[x_t1000]
		cmp bx,ax
		jae tot_work		;мразь рядом ? если нет,то выход...
not_work:	mov al,0		;NO DANGER!
		ret			;врага нет - проверки нет!
tot_work:	cmp [busy_t101],0
		jz not_work		;опасен ли ? NO - YES
		cmp [mod_t101],3
		je sfinded3
		cmp [mod_t101],4
		je sfinded4
		cmp [mod_t101],5
		je sfinded5
		cmp [mod_t101],6
		je sfinded6
		cmp [mod_t101],7
		je sfinded7
		jmp not_work		;УРА!!! БИТЬ НЕ БУДУТ!!!
sfinded3:	cmp [t101_spr_si],56210
		jne not_work
		jmp sfinded
sfinded4:	cmp [t101_spr_si],5621
		jne not_work
		jmp sfinded
sfinded5:	cmp [t101_spr_si],39347
		jne not_work
		jmp sfinded
sfinded6:	cmp [t101_spr_si],50589
		jne not_work
		jmp sfinded
sfinded7:	cmp [t101_spr_si],28105
		jne not_work
;--------------- наши действия ------------------
sfinded:	cmp [busy_t1000],0
		jz facker
		jmp not_work		;I am OKay!
facker: 	cmp [mode_t1000],1
		jne exted
		jmp not_work
exted:		cmp [mode_t1000],2
		jne ipe
		jmp not_work
;--------------- Сейчас нас будут бить ногами по животу -------------------
ipe:		cmp [life_t1000],2
		je final_ick		;последний удар по нам
		sub [life_t1000],2	;<<< УМЕНЬШЕНИЕ ЖИЗНЕЙ T1000 >>>
		mov [busy_t1000],1
		mov [mode_t1000],12	;незначительное попадание
		mov [num_s_t1000],2
		mov [t1000_new_si],16863
		mov [t1000_new_ds],4f19h
		call move_t1000
		mov [backw],4
		call power_down_2	;уменьшение энергии
		ret
final_ick:	sub [life_t1000],2
		mov [busy_t1000],1
		mov [mode_t1000],6	;полная нейтрализция T101
		mov [num_s_t1000],3
		mov [t1000_new_si],16863
		mov [t1000_new_ds],4f19h
		call move_t1000
		mov [kill_t1000],1	;if KILL=1 then t1000 must die!
		call power_down_2	;уменьшение энергии
		ret
check_myself	endp
;############################################################################
;		CYBER CONTROL	T1000					    #
;############################################################################
cyber_control	proc
		cmp [kill_t1000],0
		jz t1000_life
		cmp [num_s_t1000],0
		jnz p_l_draw
		mov [win],1
		ret
t1000_life:	call check_myself	;проверка на удар
		call cyber_brain	;искусственный интеллект T1000
p_l_draw:	cmp [busy_t1000],0
		jz kill_him		;есть дело?..тогда занимаемся им...
		call move_t1000
		ret
kill_him:	mov [mod_t1000],al
		cmp al,10		;ВПРАВО
		jne no_go_left
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],9	;left (10)
		mov [num_s_t1000],2	;how much sprites
		mov [t1000_new_si],33726
		mov [t1000_new_ds],4f19h
		call move_t1000
		ret
no_go_left:	cmp al,9		;ВЛЕВО
		jne no_go_right
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],10	;right (9)
		mov [num_s_t1000],2	;how much sprites
		mov [t1000_new_si],39347
		mov [t1000_new_ds],4f19h
		call move_t1000
		ret
no_go_right:	cmp al,1
		jne no_go_block
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],1	;block (1)
		mov [num_s_t1000],1	;how much sprites
		mov [t1000_new_si],11242
		mov [t1000_new_ds],4f19h
		call move_t1000
		ret
no_go_block:	cmp al,2
		jne no_go_down
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],3	;sit(down) (2)
		mov [num_s_t1000],2	;how much sprites
		mov [t1000_new_si],28105
		mov [t1000_new_ds],4000h
		call move_t1000
		ret
no_go_down:	cmp al,3
		jne no_go_punch
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],3	;punch simply (3)
		mov [num_s_t1000],2	;how much sprites
		mov [t1000_new_si],5621
		mov [t1000_new_ds],4000h
		call move_t1000
		ret
no_go_punch:	cmp al,4
		jne no_go_kick
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],3	;kick simply (4)
		mov [num_s_t1000],2	;how much sprites
		mov [t1000_new_si],16863
		mov [t1000_new_ds],4000h
		call move_t1000
		ret
no_go_kick:	cmp al,7
		jne no_go_downpunch
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],3	;downpunch (7)
		mov [num_s_t1000],2	;how much sprites
		mov [t1000_new_si],39347
		mov [t1000_new_ds],4000h
		call move_t1000
		ret
no_go_downpunch: cmp al,5
		jne no_go_spunch
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],3	;punch special (5)
		mov [num_s_t1000],2	;how much sprites
		mov [t1000_new_si],50589
		mov [t1000_new_ds],4000h
		call move_t1000
		ret
no_go_spunch:	cmp al,6
		jne no_go_skick
		mov [busy_t1000],1	;mode is on
		mov [mode_t1000],3	;kick special (6)
		mov [num_s_t1000],2	;how much sprites
		mov [t1000_new_si],0
		mov [t1000_new_ds],4f19h
		call move_t1000
		ret
no_go_skick:	ret

cyber_control	endp
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;		ПРОЦЕДУРА  БОЯ !					    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
level_1_p	proc
		mov [in_menu],0 	;выход в меню по ESC
		mov [busy_t101],0	;нет фазы
		mov [busy_t1000],0	;нет фазы
		mov [mode_t101],0	;нет действия
		mov [mode_t1000],0	;нет действия
		mov [mod_t101],0	;нет команд
		mov [mod_t1000],0	;нет команд
		mov [life_t101],24	;жизни T101
		mov [life_t1000],24	;жизни T1000
		mov [kill_t101],0	;t101 is life...
		mov [kill_t1000],0	;t1000 is life...
		mov [game_over],0	;not game over
		mov [win],0		;not we wins
		mov [backw],0		;отступ назад T1000
		mov ax,0c00h
		int 21h 		;очистка буфера клавиатуры
sis:		call arnold		;управление "АРНОЛЬДОМ"
		cmp [game_over],0	;если нас уложили,то выход
		jz coon_fight
		ret
coon_fight:	cmp [in_menu],0
		jz con_fight
		ret
con_fight:	cmp [win],0		;если мы выиграли,то выход
		jz cont_fighting
		ret
cont_fighting:	call cyber_control	;управление интеллектом T1000
		jmp sis
		ret
level_1_p	endp
;----------------------------------------------------------------------------
;-		LOAD MESSAGE   "LOAD"					    -
;----------------------------------------------------------------------------
lo_mes		proc
		xor di,di
		xor si,si
		call loadnameinmes
		mov ah,0fh
		lea dx,fcbrec
		int 21h
		cmp al,0
		jz ok_by_mes
		jmp error_open
ok_by_mes:	mov ah,1ah
		mov dx,dtastart
		int 21h
		mov [block],0
		mov [lenzap],96
		mov [numczap],1
		mov cx,55
		xor di,di
		xor si,si
		push 4000h
		pop es
		xor bp,bp
		call loadgra
		mov ah,10h
		lea dx,fcbrec
		int 21h 			;close file
		cmp [message],0
		jz load_m
		jmp fin
load_m: 	mov dx,120
		mov di,112
		mov si,0
		mov ah,1
		push ds
		push 4000h
		pop ds
		mov cx,55
		mov bx,96
		call anim_new
		pop ds
		ret
lo_mes		endp
;############################################################################
;#		И Н Т Е Р Ф Е Й С   (ПАНЕЛЬ)				    #
;############################################################################
panel		proc
		xor di,di
		xor si,si
		call loadnamepanel
		mov ah,0fh
		lea dx,fcbrec
		int 21h
		cmp al,0
		jz ok_by_panel
		jmp error_open
ok_by_panel:	mov ah,1ah
		mov dx,dtastart
		int 21h
		mov [block],0
		mov [lenzap],286
		mov [numczap],1
		mov cx,24
		xor di,di
		xor si,si
		push 9060h
		pop es
		xor bp,bp
		call loadgra
		mov ah,10h
		lea dx,fcbrec
		int 21h 			;close file
		cmp [message],0
		jz load_panel
		jmp fin
load_panel:	mov dx,176			;ver
		mov di,17			;hor
		mov si,0
		mov ah,1
		push ds
		push 9060h
		pop ds
		mov cx,24
		mov bx,286
		call anim_new
		pop ds
		ret
panel		endp
;============================================================================
;||		Проверка На Целостность Программного Пакета		   ||
;============================================================================
connect 	proc
		jmp start_check
try_open:	mov ah,3dh			;open
		mov al,0
		int 21h
		ret
try_close:	mov ah,3eh			;close
		int 21h
		ret
error_open:	mov ax,0003h
		int 10h
		mov ah,9			;error & exit to DOS
		lea dx,prtload
		int 21h
		pop ax				;непонял?...подумай получше!
		mov ax,4c00h
		int 21h 			;EXIT NOW!!!
;--------------------------------------------------
start_check:	lea dx,bmp_name 		;as.dat
		call try_open
		jc error_open
		xchg ax,bx
		call try_close
;--------------------------------------------------
		lea dx,bmp_acg			;acg.dat
		call try_open
		jc error_open
		xchg ax,bx
		call try_close
;--------------------------------------------------
		lea dx,assoft_name		;assoft.dat
		call try_open
		jc error_open
		xchg ax,bx
		call try_close
;--------------------------------------------------
		lea dx,overas_name		;overas.dat
		call try_open
		jc error_open
		xchg ax,bx
		call try_close
;--------------------------------------------------
		lea dx,cyber_name		;cyber.dat
		call try_open
		jc error_open
		xchg ax,bx
		call try_close
;--------------------------------------------------
		lea dx,mnu_name 		;menu_scr.dat
		call try_open
		jc error_open
		xchg ax,bx
		call try_close
;--------------------------------------------------
		lea dx,g_over_name		;gameover.dat
		call try_open
		jc error_open
		xchg ax,bx
		call try_close
		ret
connect 	endp
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;		ВЫВОД	G A M E  O V E R				    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
game__over	proc
		mov ah,0ch
		int 21h 		;clear keyboard
		mov ah,3dh
		mov al,0
		lea dx,g_over_name
		int 21h 		;open file
		jnc g_o_ok
		ret
g_o_ok: 	call cyber_ok		;show image
		ret
game__over	endp
;****************************************************************************
;*		ПЕРВЫЙ УРОВЕНЬ	(THE GAME SHOP) 			    *
;****************************************************************************
level_1 	proc
;подготовка к загрузке фона первого уровня
		xor si,si
		xor di,di
		call loadnameinfcb	;перенос filename.ext в FCB
		call lbb
;подготовка к загрузке шрифтов в память
		xor di,di
		xor si,si
		call loadnameinfcbf	;загрузка активного имени файла
		mov ah,0fh
		lea dx,fcbrec
		int 21h 		;OPEN FILE
		cmp al,0
		jnz gotofin
		mov ah,1ah
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
		jmp con
gotofin:	jmp error_open		;увеличение дальности переходов
con:		call message_1		;печать  о местонахождении и цели боя
r_k:		call readkey		;проверка на нажатие клавиши
		jz r_k
		mov ax,0c00h
		int 21h
		mov [round],0
		mov [diet101],0
		mov [diet1000],0
		call lo_mes
		call load_cyborgs	;загрузка ТЕРМИНАТОРОВ
next_round:	call clrscr		;очистка экрна
		inc [round]
		call now_round
		call s_drive		;выводим заставку первого уровня!!!
		call panel		;рисуем игровую панель
		mov [y_t1000],95
		mov [x_t1000],50
		mov [x_t101],195	;set cyborgs coords
		call print_fighters	;печать начального положения бойцов
		call set_power		;вывести показатель энергии на экран
		call level_1_p		;ENGINE
		cmp [in_menu],0
		jz r_k_2
		ret
r_k_2:		mov ah,7
		int 21h
		cmp al,32
		je key_grip
		cmp al,13
		jne r_k_2
key_grip:	mov ax,0c00h
		int 21h
		cmp [win],1
		jne we_die
		inc [diet1000]
		jmp cont_comp
we_die: 	inc [diet101]
cont_comp:	cmp [round],2
		je r_2
		cmp [round],3
		je r_3
		xor di,di
		xor si,si
		call loadnameinfcb
		call lbb
		jmp next_round
r_2:		cmp [diet1000],2
		je r_3
		cmp [diet101],2
		je r_3
		xor di,di
		xor si,si
		call loadnameinfcb
		call lbb
		jmp next_round
r_3:
		ret
level_1 	endp
;****************************************************************************
;*		ВТОРОЙ УРОВЕНЬ						    *
;****************************************************************************
level_2 	proc
;подготовка к загрузке фона первого уровня
		xor si,si
		xor di,di
		call loadnameinfcb3	;перенос filename.ext в FCB
		call lbb
;подготовка к загрузке шрифтов в память
		xor di,di
		xor si,si
		call loadnameinfcbf	;загрузка активного имени файла
		mov ah,0fh
		lea dx,fcbrec
		int 21h 		;OPEN FILE
		cmp al,0
		jnz gotofink
		mov ah,1ah
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
		jmp conk
gotofink:	jmp error_open		;увеличение дальности переходов
conk:		call message_1		;печать  о местонахождении и цели боя
r_kk:		call readkey		;проверка на нажатие клавиши
		jz r_kk
		mov ax,0c00h
		int 21h
		mov [round],0
		mov [diet101],0
		mov [diet1000],0
		call lo_mes
		call load_cyborgs	;загрузка ТЕРМИНАТОРОВ
next_round2:	call clrscr		;очистка экрна
		inc [round]
		call now_round
		call s_drive		;выводим заставку первого уровня!!!
		call panel		;рисуем игровую панель
		mov [y_t1000],95
		mov [x_t1000],50
		mov [x_t101],195	;set cyborgs coords
		call print_fighters	;печать начального положения бойцов
		call set_power
		call level_1_p		;ENGINE
		cmp [in_menu],0
		jz r_k_22
		ret
r_k_22: 	mov ah,7
		int 21h
		cmp al,32
		je key_grip2
		cmp al,13
		jne r_k_22
key_grip2:	mov ax,0c00h
		int 21h
		cmp [win],1
		jne we_die2
		inc [diet1000]
		jmp cont_comp2
we_die2:	inc [diet101]
cont_comp2:	cmp [round],2
		je r_22
		cmp [round],3
		je r_33
		xor di,di
		xor si,si
		call loadnameinfcb3
		call lbb
		jmp next_round2
r_22:		cmp [diet1000],2
		je r_33
		cmp [diet101],2
		je r_33
		xor di,di
		xor si,si
		call loadnameinfcb3
		call lbb
		jmp next_round2
r_33:
		ret
level_2 	endp
;****************************************************************************
;*		ТРЕТИЙ УРОВЕНЬ						    *
;****************************************************************************
level_3 	proc
;подготовка к загрузке фона первого уровня
		xor si,si
		xor di,di
		call loadnameinfcb2	;перенос filename.ext в FCB
		call lbb
;подготовка к загрузке шрифтов в память
		xor di,di
		xor si,si
		call loadnameinfcbf	;загрузка активного имени файла
		mov ah,0fh
		lea dx,fcbrec
		int 21h 		;OPEN FILE
		cmp al,0
		jnz gotofin3
		mov ah,1ah
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
		jmp con3
gotofin3:	jmp error_open		;увеличение дальности переходов
con3:		call message_1		;печать  о местонахождении и цели боя
r_kkk:		call readkey		;проверка на нажатие клавиши
		jz r_kkk
		mov ax,0c00h
		int 21h
		mov [round],0
		mov [diet101],0
		mov [diet1000],0
		call lo_mes
		call load_cyborgs	;загрузка ТЕРМИНАТОРОВ
next_round3:	call clrscr		;очистка экрна
		inc [round]
		call now_round
		call s_drive		;выводим заставку первого уровня!!!
		call panel		;рисуем игровую панель
		mov [y_t1000],95
		mov [x_t1000],50
		mov [x_t101],195	;set cyborgs coords
		call print_fighters	;печать начального положения бойцов
		call set_power
		call level_1_p		;ENGINE
		cmp [in_menu],0
		jz r_k_23
		ret
r_k_23: 	mov ah,7
		int 21h
		cmp al,32
		je key_grip23
		cmp al,13
		jne r_k_23
key_grip23:	mov ax,0c00h
		int 21h
		cmp [win],1
		jne we_die3
		inc [diet1000]
		jmp cont_comp3
we_die3:	inc [diet101]
cont_comp3:	cmp [round],2
		je r_23
		cmp [round],3
		je r_332
		xor di,di
		xor si,si
		call loadnameinfcb2
		call lbb
		jmp next_round3
r_23:		cmp [diet1000],2
		je r_332
		cmp [diet101],2
		je r_332
		xor di,di
		xor si,si
		call loadnameinfcb2
		call lbb
		jmp next_round3
r_332:
		ret
level_3 	endp
;****************************************************************************
;*		ЧЕТВЁРТЫЙ УРОВЕНЬ					    *
;****************************************************************************
level_4 	proc
;подготовка к загрузке фона первого уровня
		xor si,si
		xor di,di
		call loadnameinfcb4	;перенос filename.ext в FCB
		call lbb
;подготовка к загрузке шрифтов в память
		xor di,di
		xor si,si
		call loadnameinfcbf	;загрузка активного имени файла
		mov ah,0fh
		lea dx,fcbrec
		int 21h 		;OPEN FILE
		cmp al,0
		jnz gotofin4
		mov ah,1ah
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
		jmp con4
gotofin4:	jmp error_open		;увеличение дальности переходов
con4:		call message_1		;печать  о местонахождении и цели боя
r_kk4:		call readkey		;проверка на нажатие клавиши
		jz r_kk4
		mov ax,0c00h
		int 21h
		mov [round],0
		mov [diet101],0
		mov [diet1000],0
		call lo_mes
		call load_cyborgs	;загрузка ТЕРМИНАТОРОВ
next_round4:	call clrscr		;очистка экрна
		inc [round]
		call now_round
		call s_drive		;выводим заставку первого уровня!!!
		call panel		;рисуем игровую панель
		mov [y_t1000],95
		mov [x_t1000],50
		mov [x_t101],195	;set cyborgs coords
		call print_fighters	;печать начального положения бойцов
		call set_power
		call level_1_p		;ENGINE
		cmp [in_menu],0
		jz r_k_24
		ret
r_k_24: 	mov ah,7
		int 21h
		cmp al,32
		je key_grip24
		cmp al,13
		jne r_k_24
key_grip24:	mov ax,0c00h
		int 21h
		cmp [win],1
		jne we_die4
		inc [diet1000]
		jmp cont_comp4
we_die4:	inc [diet101]
cont_comp4:	cmp [round],2
		je r_24
		cmp [round],3
		je r_334
		xor di,di
		xor si,si
		call loadnameinfcb4
		call lbb
		jmp next_round4
r_24:		cmp [diet1000],2
		je r_334
		cmp [diet101],2
		je r_334
		xor di,di
		xor si,si
		call loadnameinfcb4
		call lbb
		jmp next_round4
r_334:
		ret
level_4 	endp
;****************************************************************************
;		В Ы Х О Д   В	D O S					    *
;****************************************************************************
fin:		call svga_view	;реклама при выходе
		mov ax,0003h
		int 10h
		mov bx,38
		push ds
		push c_segm
		pop ds
		lea si,copyright
		pop ds
		call decoder	;печатаем мой copyright
		mov al,0
		mov ah,4ch
		int 21h 	;EXIT TO DOS!!!
;****************************************************************************
;*			G L O B A L   M O D U L E			    *
;****************************************************************************
main:		call connect	;проверка на целостность программного пакета
		mov ah,03h  ;────┐
		mov al,05h  ;	 │
		mov bh,00h  ;	 ├───> УСКОРИТЕЛЬ КЛАВИАТУРЫ!!!
		mov bl,00h  ;	 │
		int 16h     ;────┘
		call intro_pal
finist: 	cmp [startup],4
		jne start_the_game
		jmp fin
start_the_game: xor ax,ax
		mov al,13h
		int 10h 		;VGA ON!
;--------------- LEVEL 1 ----------------------
		mov [level],1		;метка первго уровня
		call clrscr		;clear screen
		call level_1		;play
		call screen_lined	;эффект уборки экрана
		cmp [in_menu],0
		jz go_lev_2
		call game__over 	;надпись
		call main_m
		jmp finist		;(menu)
go_lev_2:	cmp [diet1000],2
		je go_lev_2_2		;goto level 2
		call game__over 	;надпись
		call main_m
		jmp finist		;(menu)
;--------------- LEVEL 2 ----------------------
go_lev_2_2:	mov [level],2		;метка второго уровня
		call clrscr		;clear screen
		call level_2		;play
		call screen_lined	;эффект уборки экрана
		cmp [in_menu],0
		jz go_lev_3
		call game__over
		call main_m		;(menu)
		jmp finist
go_lev_3:	cmp [diet1000],2
		je go_lev_3_3
		call game__over
		call main_m		;(menu)
		jmp finist
;--------------- LEVEL 3 -----------------------
go_lev_3_3:	mov [level],3		;метка третьего уровня
		call clrscr		;clear screen
		call level_3
		call screen_lined	;эффект уборки экрана
		cmp [in_menu],0
		jz go_lev_over
		call game__over
		call main_m		;(menu)
		jmp finist
go_lev_over:	cmp [diet1000],2
		je go_lev_4_3
		call game__over
		call main_m		;(menu)
		jmp finist
;--------------- LEVEL 4 -----------------------
go_lev_4_3:	mov [level],4		;метка четёртого уровня
		call clrscr		;clear screen
		call level_4
		call screen_lined	;эффект уборки экрана
		cmp [in_menu],0
		jz go_lev_ver
		call game__over
		call main_m		;(menu)
		jmp finist
go_lev_ver:	cmp [diet1000],2
		je go_over
		call game__over
		call main_m		;(menu)
		jmp finist
;--------------- COMPLETE -----------------------
go_over:	mov ah,3dh
		mov al,0
		lea dx,overas_name
		int 21h
		jc not_file
		call ok_fin
not_file:	call main_m
		jmp finist

		jmp fin
c_segm		ends
		end
start