;****************************************************************************
;*		ИСКУССТВЕННЫЙ ИНТЕЛЛЕКТ     Technology By -=AS=-	    *
;****************************************************************************
cyber_brain	proc
		cmp [busy_t1000],0
		jz start_think
		ret				;если стоим , тогда думать...
start_think:	cmp [backw],0
		jz moveon
		mov al,9
		dec [backw]
		ret		
moveon:		mov ax,[x_t101]
		sub ax,75
		cmp ax,-2
		jne not_minus
		mov ax,0
not_minus:	mov bx,[x_t1000]
		cmp bx,ax
		jae getthepoint			;скотина рядом,принять решение
		mov al,10			;ДВИГАТЬСЯ НА СОПЕРНИКА
		ret
getthepoint:	cmp [mod_t101],3
		je go_3				;punch simple
		cmp [mod_t101],4
		je go_4				;kick simple
		cmp [mod_t101],5
		je go_5				;punch special
		cmp [mod_t101],6
		je go_6				;kick spacial
		cmp [mod_t101],7
		je go_7				;down punch
		cmp [mod_t101],1
		je go_1				;block
		cmp [mod_t101],2
		je go_2				;down
		jmp go_none			;действия если Арнольд стоИт
go_3:		jmp go__3
go_4:		jmp go__3
go_5:		jmp go__5
go_6:		jmp go__5
go_7:		jmp go__7
go_1:		jmp go__1
go_2:		jmp go__1
;--------------- SITUATION PUNCH & KICK SIMPLY ----------------------
go__3:		push ds
		pop es
		lea di,mindfield
		mov al,1			;БЛОК
		stosb
		mov al,1
		stosb
		cmp [type_game],1
		jne next_type
		mov cx,2			;CX-length buffer
		mov bx,2			;BX-how many commands in buffer
		call mind			;выбор действия
		ret
next_type:	cmp [type_game],2
		jne next_type1
		mov cx,3
		mov bx,2
		call mind
		ret
next_type1:	mov cx,4
		mov bx,2
		call mind
		ret
;--------------- SITUATION PUNCH & KICK SPECIAL ----------------------
go__5:		push ds
		pop es
		lea di,mindfield
		mov al,1			;БЛОК
		stosb
		mov al,9			;НАЗАД
		stosb
		cmp [type_game],1
		jne next_kick1
		mov cx,2
		mov bx,2
		call mind
		ret
next_kick1:	cmp [type_game],2
		jne next_kick2
		mov cx,3
		mov bx,2
		call mind
		ret
next_kick2:	mov cx,4
		mov bx,2
		call mind
		ret
;--------------- SITUATION PUNCH FROM SIT POSITION -------------
go__7:		push ds
		pop es
		lea di,mindfield
		mov al,9
		stosb
		mov al,3
		stosb
		mov al,4
		stosb
		mov al,5
		stosb
		mov al,6
		stosb
		cmp [type_game],1
		jne next_sit
		mov cx,5
		mov bx,5
		call mind
		ret
next_sit:	cmp [type_game],2
		jne next_sit1
		mov cx,6
		mov bx,5
		call mind
		ret
next_sit1:	mov cx,7
		mov bx,5
		call mind
		ret
;--------------- SITUATION BLOCK ------------------------
go__1:		push ds
		pop es
		lea di,mindfield
		mov al,3
		stosb
		mov al,4
		stosb
		mov al,5
		stosb
		mov al,6
		stosb
		mov al,7
		stosb
		mov cx,5
		mov bx,5
		call mind
		ret
;--------------- БЕЗДЕЙСТВИЕ ПРОТИВНИКА------------------
go_none:	push ds
		pop es
		lea di,mindfield
		mov al,3
		stosb
		mov al,4
		stosb
		mov al,5
		stosb
		mov al,6
		stosb
		mov al,7
		stosb
		cmp [type_game],1
		jne next_none1
		mov cx,5
		mov bx,5
		call mind
		ret
next_none1:	cmp [type_game],2
		jne next_none2
		mov cx,6
		mov bx,5
		call mind
		ret
next_none2:	mov cx,7
		mov bx,5
		call mind
		ret
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;!		M I N D							    !
;!--------------------------------------------------------------------------!
;!	CX-ДЛИНА БУФЕРА ИНТЕЛЛЕКТА					    !
;!	BX-КОЛИЧЕСТВО КОМАНД В БУФЕРЕ , ОСТАЛЬНЫЕ НУЛИ...		    !
;!--------------------------------------------------------------------------!
;!   RETURN:    AL-ПРИНЯТОЕ РЕШЕНИЕ					    !
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
mind		proc
		lea si,mindfield
		cmp cx,bx
		je buf_equal		;буфер не нуждается в частичном обнулении
		xor dx,dx		;проверочный счётчик длины буфера
		add si,bx		;смещение до обнуления
		add dx,bx		;оптимизация проверочного счётчика
zerouing:	inc dx
		mov byte ptr[ds:si],0	;обнуление ячейки
		cmp dx,cx
		jne zerouing		;обнуление не закончено
buf_equal:	xchg cx,bx
		mov ah,2ch
		int 21h			;GET SYSTEM TIME
		xor ah,ah
		mov al,dl
		cbw
		xor dx,dx
		xchg cx,ax	
		lea si,mindfield
compare_check:	cmp cx,bx
		jbe last_check		;последняя проверка буфера
		sub cx,bx
		jmp compare_check
last_check:	inc dx
		mov al,[ds:si]
		inc si
		cmp dx,cx
		jb last_check
		ret
mind		endp
cyber_brain	endp