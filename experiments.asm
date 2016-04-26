;=======================================================

; ;17.3 字符串的输入
; assume cs:code

; data segment
; 	db 128 dup (0)
; data ends

; code segment
; start:
; 	mov ax, data
; 	mov ds, ax
; 	mov si, 0

; 	mov dh, 12
; 	mov dl, 39

; 	call getstr

; 	mov ax, 4c00h
; 	int 21h
; ;-----------接受字符串输入------------------------------
; getstr:	push ax
	
; getstrs:	mov ah, 0
; 	int 16h
; 	cmp al, 20h
; 	jb nochar
; 	mov ah, 0
; 	call charstack
; 	mov ah, 2
; 	call charstack
; 	jmp getstrs

; nochar:	cmp ah, 0eh
; 	je backspace
; 	cmp ah, 1ch
; 	je return
; 	jmp getstrs

; backspace:	mov ah, 1
; 	call charstack
; 	mov ah, 2
; 	call charstack
; 	jmp getstrs

; return:	mov al, 0
; 	mov ah, 0
; 	call charstack
; 	mov ah, 2
; 	call charstack

; 	pop ax
; 	ret
; ;-----------子程序：字符串入栈，出现，显示--------------
; charstack:	jmp short charstart

; table	dw charpush, charpop, charshow
; top	dw, 0

; charstart:	push ax
; 	push bx
; 	push dx
; 	push ds
; 	push es
; 	push si
; 	push di

; 	cmp ah, 2
; 	ja sret
; 	mov bl, ah
; 	mov bh, 0
; 	add bx, bx
; 	jmp word ptr table[bx]

; charpush:	mov bx, top
; 	mov [si][bx], al
; 	inc top
; 	jmp sret

; charpop:	cmp top, 0
; 	je sret
; 	dec top
; 	mov bx, top
; 	mov al, [si][bx]
; 	jmp sret

; charshow:	mov bx, 0B800h
; 	mov es, bx
; 	mov al, 160
; 	mov ah, 0
; 	mul dh
; 	mov di, ax
; 	add dl, dl
; 	mov dh, 0
; 	add di, dx

; 	mov bx, 0

; charshows:	cmp bx, top
; 	jne noempty
; 	mov byte ptr es:[di], ' '
; 	jmp sret

; noempty:	mov al, [si][bx]
; 	mov es:[di], al
; 	mov byte ptr es:[di+2], ' '
; 	inc bx
; 	add di, 2
; 	jmp charshows

; sret:	pop di
; 	pop si
; 	pop es
; 	pop ds
; 	pop dx
; 	pop bx
; 	pop ax
; 	ret
; ;=======================================================
; ;=======================================================
; code ends

; end start







; ;17.2 接收用户的键盘输入...
; assume cs:code

; code segment

; start:	mov ah, 0
; 	int 16h

; 	mov ah, 1
; 	cmp al, 'r'
; 	je red
; 	cmp al, 'g'
; 	je green
; 	cmp al, 'b'
; 	je blue

; 	jmp short sret

; red:	shl ah, 1
; green:	shl ah, 1
; blue:	mov bx, 0B800h
; 	mov es, bx
; 	mov bx, 1
; 	mov cx, 2000
; s:	and byte ptr es:[bx], 11111000B
; 	or es:[bx], ah
; 	add bx, 2
; 	loop s
; 	jmp short start

; sret:	mov ax, 4c00h
; 	int 21h
; code ends

; end start



; ;实验16 编写包含多个功能子程序的中断例程
; assume cs:code

; stack segment
; 	db 128 dup (0)
; stack ends

; code segment
; start:	mov ax, stack
; 	mov ss, ax
; 	mov sp, 128		;初始化栈

; ;-----------新int 7ch安装程序---------------------------
; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset setscreen 	;ds:[si] 源

; 	mov ax, 0
; 	mov es, ax
; 	mov di, 200h		;es:[di] 目的

; 	mov cx, offset setscreenend - offset setscreen
; 	cld
; 	rep movsb
; ;=======================================================
; ;-----------中断向量设置程序----------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov word ptr es:[7ch*4], 200h
; 	mov word ptr es:[7ch*4+2], 0
; ;=======================================================
	
; 	mov ah, 3
; 	int 7ch

; 	mov ax, 4c00h
; 	int 21h

; ;-----------int 7ch 源程序-----------------------------------
; 	ORG 200h		;伪指令，表示下一条指令从偏移地址200h开始
; 			;正好和安装后的偏移地址相同
; 			;如果没有ORG 200h，此中断例程被安装之后，标号所代表的地址变了
; 			;和之前编译器编译的有区别
; setscreen:	jmp short set

; table	dw sub1, sub2, sub3, sub4

; set:	push ax
; 	push bx

; 	cmp ah, 3
; 	ja setret
; 	mov bl, ah
; 	mov bh, 0
; 	add bx, bx		;根据ah中的功能号计算对应子程序在table表中的地址

; 	call word ptr table[bx]	;调用对应的子程序

; setret:	pop bx
; 	pop ax

; 	iret
; ;-----------sub-----------------------------------------
; sub1:	push bx
; 	push cx
; 	push es

; 	mov bx, 0b800h
; 	mov es, bx
; 	mov bx, 0
; 	mov cx, 2000

; sub1s:	mov byte ptr es:[bx], ' '
; 	add bx, 2
; 	loop sub1s

; 	pop es
; 	pop cx
; 	pop bx
; 	ret


; sub2:	push bx
; 	push cx
; 	push es

; 	mov bx, 0b800h
; 	mov es, bx
; 	mov bx, 1

; 	mov cx, 2000
; sub2s:	and byte ptr es:[bx], 11111000B
; 	or es:[bx], al
; 	add bx, 2
; 	loop sub2s

; 	pop es
; 	pop cx
; 	pop bx
; 	ret


; sub3:	push bx
; 	push cx
; 	push es

; 	mov bx, 0b800h
; 	mov es, bx
; 	mov bx, 1

; 	mov cl, 4
; 	shl al, cl

; 	mov cx, 2000
; sub3s:	and byte ptr es:[bx], 10001111B
; 	or es:[bx], al
; 	add bx, 2
; 	loop sub3s

; 	pop es
; 	pop cx
; 	pop bx
; 	ret


; sub4:	push bx
; 	push cx
; 	push ds
; 	push es
; 	push si
; 	push di

; 	mov bx, 0b800h
; 	mov ds, bx
; 	mov si, 160		;ds:[si] 源
; 	mov es, bx
; 	mov di, 0		;ds:[si] 目的
; 	cld

; 	mov cx, 24
; sub4s:	push cx
; 	mov cx, 160
; 	rep movsb
; 	pop cx
; 	loop sub4s

; 	mov cx, 80
; 	mov si, 0
; sub4s1:	mov byte ptr [160*24+si], ' '
; 	add si, 2
; 	loop sub4s1

; 	pop di
; 	pop si
; 	pop es
; 	pop ds
; 	pop cx
; 	pop bx
; 	ret

; setscreenend:
; 	nop
; ;=======================================================
; code ends

; end start




; ;16.4 实现一个子程序setscreen
; assume cs:code

; stack segment
; 	db 128 dup (0)
; stack ends

; code segment
; start:	mov ax, stack
; 	mov ss, ax
; 	mov sp, 128		;初始化栈

; 	mov ah, 0
; 	call setscreen
; 	call delay 		;清屏

; 	mov ah, 1
; 	mov al, 2
; 	call setscreen
; 	call delay 		;设置前景色

; 	mov ah, 2
; 	mov al, 2
; 	call setscreen
; 	call delay 		;设置后景色

; 	mov ah, 3
; 	call setscreen
; 	call delay 		;向上滚动一行
	
; 	mov ax, 4c00h
; 	int 21h
; ;-----------delay源程序---------------------------------
; delay:	push ax
; 	push dx

; 	mov dx, 5
; 	mov ax, 0
; circulate:	sub ax, 1
; 	sbb dx, 0
; 	cmp ax, 0
; 	jne circulate
; 	cmp dx, 0
; 	jne circulate

; 	pop dx
; 	pop ax
; 	ret
; ;=======================================================
; ;-----------setscreen-----------------------------------
; setscreen:	jmp short set

; table	dw sub1, sub2, sub3, sub4

; set:	push ax
; 	push bx

; 	cmp ah, 3
; 	ja setret
; 	mov bl, ah
; 	mov bh, 0
; 	add bx, bx		;根据ah中的功能号计算对应子程序在table表中的地址

; 	call word ptr table[bx]	;调用对应的子程序

; setret:	pop bx
; 	pop ax
; 	ret
; ;-----------sub-----------------------------------------
; sub1:	push bx
; 	push cx
; 	push es

; 	mov bx, 0b800h
; 	mov es, bx
; 	mov bx, 0
; 	mov cx, 2000

; sub1s:	mov byte ptr es:[bx], ' '
; 	add bx, 2
; 	loop sub1s

; 	pop es
; 	pop cx
; 	pop bx
; 	ret


; sub2:	push bx
; 	push cx
; 	push es

; 	mov bx, 0b800h
; 	mov es, bx
; 	mov bx, 1

; 	mov cx, 2000
; sub2s:	and byte ptr es:[bx], 11111000B
; 	or es:[bx], al
; 	add bx, 2
; 	loop sub2s

; 	pop es
; 	pop cx
; 	pop bx
; 	ret


; sub3:	push bx
; 	push cx
; 	push es

; 	mov bx, 0b800h
; 	mov es, bx
; 	mov bx, 1

; 	mov cl, 4
; 	shl al, cl

; 	mov cx, 2000
; sub3s:	and byte ptr es:[bx], 10001111B
; 	or es:[bx], al
; 	add bx, 2
; 	loop sub3s

; 	pop es
; 	pop cx
; 	pop bx
; 	ret


; sub4:	push bx
; 	push cx
; 	push ds
; 	push es
; 	push si
; 	push di

; 	mov bx, 0b800h
; 	mov ds, bx
; 	mov si, 160		;ds:[si] 源
; 	mov es, bx
; 	mov di, 0		;ds:[si] 目的
; 	cld

; 	mov cx, 24
; sub4s:	push cx
; 	mov cx, 160
; 	rep movsb
; 	pop cx
; 	loop sub4s

; 	mov cx, 80
; 	mov si, 0
; sub4s1:	mov byte ptr [160*24+si], ' '
; 	add si, 2
; 	loop sub4s1

; 	pop di
; 	pop si
; 	pop es
; 	pop ds
; 	pop cx
; 	pop bx
; 	ret
; ;=======================================================
; code ends

; end start





; ;16.3 直接定址表
; ;编写子程序，计算sin(x)...
; assume cs:code

; stack segment
; 	db 128 dup (0)
; stack ends

; code segment

; start:	mov ax, stack
; 	mov ss, ax
; 	mov sp, 128

; 	mov ax, 60
; 	call showsin

; 	mov ax, 4c00h
; 	int 21h

; ;-----------showsin源程序-------------------------------
; showsin:	jmp short show
	
; table 	dw ag0, ag30, ag60, ag90, ag120, ag150, ag180
; ag0	db '0', 0
; ag30	db '0.5', 0
; ag60	db '0.866', 0
; ag90	db '1', 0
; ag120	db '0.866', 0
; ag150	db '0.5', 0
; ag180	db '0', 0

; show:	push ax
; 	push bx
; 	push cx
; 	push es
; 	push di

; 	mov ah, 0
; 	mov bl, 30
; 	div bl
; 	mov bl, al
; 	mov bh, 0
; 	add bx, bx
; 	mov bx, table[bx]

; 	mov ax, 0b800h
; 	mov es, ax
; 	mov di, 160*12 + 39*2

; shows:	mov ah, cs:[bx]
; 	cmp ah, 0
; 	je showret
; 	mov es:[di], ah
; 	add di, 2
; 	inc bx
; 	jmp short shows

; showret:	pop di
; 	pop es
; 	pop cx
; 	pop bx
; 	pop ax
; 	ret
; ;=======================================================
; code ends

; end start






; ;16.3 直接定址表
; ;编写子程序，以十六进制的形式在屏幕中间显示给定的字节型数据
; assume cs:code
; stack segment
; 	db 128 dup (0)
; stack ends
; code segment

; start:	mov ax, stack
; 	mov ss, ax
; 	mov sp, 128

; 	mov al, 11000001B
; 	call showbyte

; 	mov ax, 4c00h
; 	int 21h

; ;-----------shorbyte源程序------------------------------
; showbyte:	jmp short show
; 	table db '0123456789ABCDE'

; show:	push ax
; 	push bx
; 	push cx
; 	push es
; 	push di

; 	mov ah, al
; 	mov cl, 4
; 	shr ah, cl
; 	and al, 00001111B	;ah al分别保存两个数字

; 	mov bx, 0b800h
; 	mov es, bx
; 	mov di, 160*12 + 39*2	;从es:[di]开始输出

; 	mov bl, ah
; 	mov bh, 0
; 	mov ah, table[bx]	;将ah数字转换为表示其的ascii码
; 	mov es:[di], ah	;显示

; 	mov bl, al
; 	mov bh, 0
; 	mov al, table[bx]	;将al数字转换为表示其的ascii码
; 	mov es:[di+2], al	;显示

; 	pop di
; 	pop es
; 	pop cx
; 	pop bx
; 	pop ax

; 	ret
; ;=======================================================
; code ends

; end start




; ;实验15 安装新的int 9中断例程
; assume cs:code

; stack segment
; 	db 128 dup (0)
; stack ends

; code segment
; start:
; 	mov ax, stack
; 	mov ss, ax
; 	mov sp, 128		;初始化栈

; ;-----------新int 9安装程序-----------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov di, 204h	;es:[di] 新的int 9中断例程安装地址

; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset int9	;ds:[si] int 9中断例程所在内存首地址

; 	mov cx, offset int9end - offset int9
; 	cld
; 	rep movsb
; ;-----------设置中断向量--------------------------------
; 	push es:[9*4]
; 	pop es:[200h]
; 	push es:[9*4 + 2]
; 	pop es:[202h]	;将原int 9中断例程入口地址保存在0:200单元处

; 	cli
; 	mov word ptr es:[9*4], 204h
; 	mov word ptr es:[9*4+2], 0
; 	sti
; ;=======================================================

; 	mov ax, 4c00h
; 	int 21h

; ;-----------新int 9源程序-------------------------------
; int9:	push ax
; 	push bx
; 	push cx
; 	push es

; 	in al, 60h

; 	mov bx, 0
; 	mov es, bx

; 	pushf
; 	pushf
; 	pop bx
; 	and bh, 11111100B
; 	push bx
; 	popf
; 	call dword ptr es:[200h];对int指令进行模拟，调用原来的int9中断指令

; 	cmp al, 9eh
; 	jne int9ret 	;如果不是F1，则直接返回
	
; 	mov bx, 0b800h
; 	mov es, bx
; 	mov bx, 0
; 	mov cx, 2000
; s:	mov byte ptr es:[bx], 'A'
; 	add bx, 2
; 	loop s 	;如果是F1，改变显示的颜色

; int9ret:	pop es
; 	pop cx
; 	pop bx
; 	pop ax
; 	iret
; int9end:	nop

; ;=======================================================
; code ends

; end start







; ;15.5 安装新的int 9中断例程
; assume cs:code

; stack segment
; 	db 128 dup (0)
; stack ends

; code segment
; start:
; 	mov ax, stack
; 	mov ss, ax
; 	mov sp, 128		;初始化栈

; ;-----------新int 9安装程序-----------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov di, 204h	;es:[di] 新的int 9中断例程安装地址

; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset int9	;ds:[si] int 9中断例程所在内存首地址

; 	mov cx, offset int9end - offset int9
; 	cld
; 	rep movsb
; ;-----------设置中断向量--------------------------------
; 	push es:[9*4]
; 	pop es:[200h]
; 	push es:[9*4 + 2]
; 	pop es:[202h]	;将原int 9中断例程入口地址保存在0:200单元处

; 	cli
; 	mov word ptr es:[9*4], 204h
; 	mov word ptr es:[9*4+2], 0
; 	sti
; ;=======================================================

; 	mov ax, 4c00h
; 	int 21h

; ;-----------新int 9源程序-------------------------------
; int9:	push ax
; 	push bx
; 	push cx
; 	push es

; 	in al, 60h

; 	mov bx, 0
; 	mov es, bx

; 	pushf
; 	pushf
; 	pop bx
; 	and bh, 11111100B
; 	push bx
; 	popf
; 	call dword ptr es:[200h];对int指令进行模拟，调用原来的int9中断指令

; 	cmp al, 3bh
; 	jne int9ret 	;如果不是F1，则直接返回
	
; 	mov bx, 0b800h
; 	mov es, bx
; 	mov bx, 1
; 	mov cx, 2000
; s:	inc byte ptr es:[bx]
; 	add bx, 2
; 	loop s 	;如果是F1，改变显示的颜色

; int9ret:	pop es
; 	pop cx
; 	pop bx
; 	pop ax
; 	iret
; int9end:	nop

; ;=======================================================
; code ends

; end start







; ;15.4 编写int 9中断例程
; assume cs:code

; stack segment
; 	db 128 dup (0)
; stack ends

; data segment
; 	dw 0, 0
; data ends

; code segment
; start:
; 	mov ax, stack
; 	mov ss, ax
; 	mov sp, 128		;初始化栈

; 	mov ax, data
; 	mov ds, ax		;初始化ds指向data段

; 	mov ax, 0
; 	mov es, ax		;初始化es指向中断向量表所在的0段

; 	cli
; 	push es:[9*4]
; 	pop ds:[0]
; 	push es:[9*4+2]
; 	pop ds:[2]		;将原来的int 9中断例程的入口地址保存在ds:0、ds:2单元中
; 	sti

; 	mov word ptr es:[9*4], offset int9
; 	mov es:[9*4+2], cs

; 	mov ax, 0b800h
; 	mov es, ax
; 	mov di, 12*160 + 39*2	;字符显示的位置
; 	mov byte ptr es:[di+1], 00000010B
; 	mov ah, 'a'
; display:	mov es:[di], ah
; 	call delay 		;调用延迟函数
; 	inc ah
; 	cmp ah, 'z'
; 	jna display

; 	;回复原来的int 9中断
; 	cli
; 	mov ax, 0
; 	mov es, ax
; 	mov ax, data
; 	mov ds, ax
; 	push ds:[0]
; 	pop es:[9*4]
; 	push ds:[2]
; 	pop es:[9*4+2]
; 	sti

; 	mov ax, 4c00h
; 	int 21h
; ;-----------新int9源程序--------------------------------
; int9:	push ax
; 	push bx
; 	push es

; 	in al, 60h
; 	;模拟int9指令调用原来的int 9
; 	pushf 		;标志寄存器入栈
; 	pushf
; 	pop bx
; 	and bh, 11111100B
; 	push bx
; 	popf 		;设置IF=0，TF=0
; 	call dword ptr ds:[0]	;调用原来的int 9中断例程

; 	cmp al, 1
; 	jne int9ret

; 	mov ax, 0b800h
; 	mov es, ax
; 	inc byte ptr es:[di+1]

; int9ret:	pop es
; 	pop bx
; 	pop ax
; 	iret
; ;=======================================================
; ;-----------delay源程序---------------------------------
; delay:	push ax
; 	push dx

; 	mov dx, 5
; 	mov ax, 0
; circulate:	sub ax, 1
; 	sbb dx, 0
; 	cmp ax, 0
; 	jne circulate
; 	cmp dx, 0
; 	jne circulate

; 	pop dx
; 	pop ax
; 	ret
; ;=======================================================
; code ends

; end start





; ;实验14 访问CMOS RAM
; assume cs:code

; data segment
; 	db 'yy/mm/dd hh:mm:ss', '$'
; data ends

; stack segment
; 	db 128 dup (0)
; stack ends

; code segment
; start:
; 	mov ax, stack
; 	mov ss, ax
; 	mov sp, 128

; 	mov ax, data
; 	mov ds, ax
	

; 	;显示年月日
; 	mov si, 0
; 	mov cx, 3
; 	mov al, 9
; ymd:	push cx
; 	push ax
; 	out 70h, al
; 	in al, 71h

; 	mov ah, al
; 	mov cl, 4
; 	shr ah, cl
; 	and al, 00001111B

; 	add ah, 30h
; 	add al, 30h

; 	mov ds:[si], ah
; 	mov ds:[si+1], al
; 	add si, 3
; 	pop ax
; 	dec al
; 	pop cx
; 	loop ymd

; 	;显示时分秒
; 	mov si, 9
; 	mov cx, 3
; 	mov al, 4
; hms:	push cx
; 	push ax
; 	out 70h, al
; 	in al, 71h

; 	mov ah, al
; 	mov cl, 4
; 	shr ah, cl
; 	and al, 00001111B
; 	add ah, 30h
; 	add al, 30h

; 	mov ds:[si], ah
; 	mov ds:[si+1], al
; 	add si, 3
; 	pop ax
; 	sub al, 2
; 	pop cx
; 	loop hms

; 	mov dx, 0
; 	;ds:[dx]指向字符串
; 	mov ah, 9
; 	int 21h

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start



; ;检测点14.2
; assume cs:code

; code segment
; start:
; 	mov ax, 1
; 	shl ax, 1
; 	mov bx, ax
; 	mov cl, 2
; 	shl ax, cl
; 	add ax, bx

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start


; ;检测点14.1(2)
; assume cs:code

; code segment
; start:
; 	mov al, 2
; 	out 70h, al
; 	mov al, 0
; 	out 7ch, al

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start



; ;检测点14.1(1)
; assume cs:code

; code segment
; start:
; 	mov al, 2
; 	out 70h, al
; 	in al, 71h

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start






; ;实验13 编写、应用中断例程(3)
; assume cs:code

; code segment
; s1:	db 'Good, better, best,', '$'
; s2:	db 'Never let it rest,', '$'
; s3:	db 'Till good is better,', '$'
; s4:	db 'And better, best.', '$'
; s:	dw offset s1, offset s2, offset s3, offset s4
; row:	db 2, 4, 6, 8

; start:
; 	mov ax, cs
; 	mov ds, ax
; 	mov bx, offset s
; 	mov si, offset row

; 	mov cx, 4
; ok:	mov bh, 0
; 	mov dh, ds:[si]
; 	mov dl, 0
; 	mov ah, 2
; 	int 10h	;置光标

; 	mov dx, ds:[bx]
; 	mov ah, 9
; 	int 21h

; 	add bx, 2
; 	inc si

; 	loop ok

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start




; ;实验13 编写、应用中断例程(2)
; assume cs:code

; code segment
; start:
; ;-----------lp安装程序----------------------------------
; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset lp	;ds:[si] 源地址

; 	mov ax, 0
; 	mov es, ax
; 	mov di, 200h	;es:[si] 目的地址

; 	mov cx, offset lpend - offset lp
; 	cld
; 	rep movsb
; ;=======================================================
; ;-----------设置中断向量--------------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov word ptr es:[7ch*4], 200h
; 	mov word ptr es:[7ch*4+2], 0
; ;=======================================================
; 	mov ax, 0b800h
; 	mov es, ax
; 	mov di, 160 * 12	;es:[di] 开始显示

; 	mov bx, offset s - offset se

; 	mov cx, 80
; s:	mov byte ptr es:[di], '!'
; 	add di, 2
; 	int 7ch

; se:	nop
; 	mov ax, 4c00h
; 	int 21h

; ;-----------lp源程序------------------------------------
; lp:
; 	push bp
; 	mov bp, sp
; 	dec cx
; 	jcxz ok
; 	add ss:[bp+2], bx

; ok:	pop bp
; 	iret

; lpend:	nop
; ;=======================================================
; code ends

; end start




; ;实验13 编写、应用中断例程(1)
; assume cs:code

; data segment
; 	db "welcome to masm!", 0
; data ends

; code segment
; start:
; ;-----------display安装程序-----------------------------
; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset display 	;ds:[si] 源地址

; 	mov ax, 0
; 	mov es, ax
; 	mov di, 200h	;es:[si] 目的地址

; 	mov cx, offset displayend - offset display
; 	cld
; 	rep movsb
; ;=======================================================
; ;-----------设置中断向量--------------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov word ptr es:[7ch*4], 200h
; 	mov word ptr es:[7ch*4+2], 0
; ;=======================================================
	
; 	mov dh, 10
; 	mov dl, 10
; 	mov cl, 2
; 	mov ax, data
; 	mov ds, ax
; 	mov si, 0
; 	int 7ch

; 	mov ax, 4c00h
; 	int 21h

; ;-----------display源程序-------------------------------
; display:	
; 	mov ax, 0b800h
; 	mov es, ax

; 	mov al, 160
; 	mul dh
; 	mov di, ax
; 	mov al, 2
; 	mul dl
; 	add di, ax		;es:[di] 显示位置

; 	mov ch, cl

; dis:	mov cl, ds:[si]
; 	cmp cl, 0
; 	je ok
; 	mov es:[di], cx
; 	add di, 2
; 	inc si
; 	jmp dis
; ok:	iret

; displayend:	nop
; ;=======================================================

; code ends

; end start



; ;13.7 DOS中断例程应用
; assume cs:code

; data segment
; 	db 'Welcome to masm!', '$'
; data ends

; code segment
; start:
; 	mov ah, 2
; 	mov bh, 0
; 	mov dh, 5
; 	mov dl, 12
; 	int 10h

; 	mov ax, data
; 	mov ds, ax
; 	mov dx, 0
; 	mov ah, 9
; 	int 21h

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start


; ;13.6 BIOS中断例程应用
; assume cs:code

; code segment
; start:
; 	mov ah, 2	;置光标
; 	mov bh, 0	;第 0 页
; 	mov dh, 5	;第 5 行
; 	mov dl, 12	;第 12 列
; 	int 10h	;对应的中断例程

; 	mov ah, 9	;在光标显示字符
; 	mov al, 'a'	;字符
; 	mov bh, 0	;第 0 页
; 	mov bl, 01001010b	;颜色属性
; 	mov cx, 80	;字符重复个数
; 	int 10h	;对应的中断例程

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start



; ;捡测点13.1 (2)
; assume cs:code

; data segment
; 	db 'conversation', 0
; data ends

; code segment
; ;-----------jump安装程序--------------------------------
; start:
; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset jump 	;ds:[si] 源地址

; 	mov ax, 0
; 	mov es, ax
; 	mov di, 200h	;es:[si] 目的地址

; 	mov cx, offset jumpend - offset jump
; 	cld
; 	rep movsb
; ;=======================================================
; ;-----------设置中断向量--------------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov word ptr es:[7ch*4], 200h
; 	mov word ptr es:[7ch*4+2], 0
; ;=======================================================
; 	mov ax, data
; 	mov ds, ax
; 	mov si, 0
; 	mov ax, 0b800h
; 	mov es, ax
; 	mov di, 12*160 + 3 * 2
	
; 	mov bx, offset display - offset displayend
; display:	
; 	cmp byte ptr [si], 0
; 	je displayend
; 	mov ah, 10000010B
; 	mov al, [si]
; 	mov es:[di], ax
; 	inc si
; 	add di, 2
; 	int 7ch

; displayend:	
; 	mov ax, 4c00h
; 	int 21h

; ;-----------jump源程序----------------------------------
; jump:	push bp
; 	mov bp, sp
; 	add [bp+2], bx
; 	pop bp
; 	iret
; jumpend:	nop
; ;=======================================================
; code ends

; end start





; ;13.3 用7ch中断例程完成loop指令的功能
; assume cs:code

; code segment
; start:
; ;-----------lp安装程序----------------------------------
; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset lp	;ds:[si] 源地址

; 	mov ax, 0
; 	mov es, ax
; 	mov di, 200h	;es:[di] 目的地址

; 	mov cx, offset lpend - offset lp
; 	cld
; 	rep movsb
; ;=======================================================
; ;-----------设置中断向量表------------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov word ptr es:[7ch*4], 200h
; 	mov word ptr es:[7ch*4+2], 0
; ;=======================================================
; 	mov ax, 0b800h
; 	mov es, ax
; 	mov di, 160 * 12	;es:[di]开始显示的位置

; 	mov bx, offset display - offset displayend
; 	mov cx, 80
; display:	mov byte ptr es:[di], '!'
; 	add di, 2
; 	int 7ch

; displayend:	nop

; 	mov ax, 4c00h
; 	int 21h

; ;-----------lp源程序------------------------------------
; lp:	push bp
; 	mov bp, sp
; 	dec cx
; 	jcxz lpiret
; 	add [bp+2], bx
; 	;add [sp+2], bx ;error:must be index or base register

; lpiret:	pop bp
; 	iret

; lpend:	nop
; ;=======================================================
; code ends

; end start


; ; 13.2 问题二
; assume cs:code

; data segment
; 	db 'conversation', 0
; data ends

; code segment
; start:
; ;-----------capital安装程序-----------------------------
; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset capital 	;ds:[si] 源地址

; 	mov ax, 0
; 	mov es, ax
; 	mov di, 200h	;es:[di] 目的地址
	
; 	mov cx, offset capitalend - offset capital
; 	cld
; 	rep movsb
; ;=======================================================
; ;-----------设置中断向量表------------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov word ptr es:[7ch*4], 200h
; 	mov word ptr es:[7ch*4+2], 0

; ;=======================================================
; 	mov ax, data
; 	mov ds, ax
; 	mov si, 0
; 	int 7ch
; 	mov ax, 4c00h
; 	int 21h
; ;-----------capital程序源代码---------------------------
; capital:	push cx
; 	push si

; change:	mov ch, 0
; 	mov cl, ds:[si]
; 	jcxz capitalret
; 	and cl, 11011111B
; 	mov ds:[si], cl
; 	inc si
; 	jmp change

; capitalret:	pop si
; 	pop cx
; 	iret

; capitalend:	nop
; ;=======================================================
; code ends

; end start





; 13.2 问题一
; assume cs:code

; code segment
; start:
; ;-----------sqr安装程序---------------------------------
; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset sqr 	;ds:[si] 源地址

; 	mov ax, 0
; 	mov es, ax
; 	mov di, 200h	;es:[di] 目的地址

; 	mov cx, offset sqrend - offset sqr
; 	cld
; 	rep movsb
; ;=======================================================
; ;-----------设置中断向量表------------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov word ptr es:[7ch*4], 200h
; 	mov word ptr es:[7ch*4+2], 0
; ;=======================================================
; 	mov ax, 3456
; 	int 7ch
; 	add ax, ax
; 	adc dx, dx

; 	mov ax, 4c00h
; 	int 21h
; ;-----------sqr程序源代码-------------------------------
; sqr:	mul ax
; 	iret
; sqrend:
; 	nop
; ;=======================================================
; code ends

; end start





; ;实验12 编写0号中断的处理程序
; ;重新编写一个0号中断处理程序，它的功能是在屏幕中间显示“overflow!”
; ;然后返回到操作系统
; assume cs:code

; code segment
; start:
; ;-----------do0安装程序---------------------------------
; 	mov ax, cs
; 	mov ds, ax
; 	mov si, offset do0 	;ds:[si] 源地址

; 	mov ax, 0
; 	mov es, ax
; 	mov di, 200h	;es:[di] 目的地址

; 	mov cx, offset do0end - offset do0
; 	cld
; 	rep movsb
; ;=======================================================
; ;-----------设置中断向量表------------------------------
; 	mov ax, 0
; 	mov es, ax
; 	mov word ptr es:[0*4], 200h
; 	mov word ptr es:[0*4 + 2], 0
; ;=======================================================
	
; 	mov ax, 1000h
; 	mov bx, 1
; 	div bh

; 	mov ax, 4c00h
; 	int 21h

; ;-----------do0程序源代码-------------------------------
; do0:	
; 	jmp short do0start
; 	db "overflow!", 0

; do0start:	mov ax, 0b800h
; 	mov es, ax
; 	mov di, 12*160 + 35*2	;从es:[di]开始显示

; 	mov ax, cs
; 	mov ds, ax
; 	mov si, 202h	;ds:[si] 显示的字符串

; display:	mov ch, 0
; 	mov cl, ds:[si]
; 	jcxz displayend
; 	mov ch, 10000010B
; 	mov es:[di], cx
; 	inc si
; 	add di, 2
; 	jmp display

; displayend:	mov ax, 4c00h
; 	int 21h
; do0end:	
; 	nop
; ;=======================================================
; code ends

; end start








; ;实验11-编写子程序
; assume cs:code

; data segment
; 	db 'Beginners All-purpose Symbolic Instruction Code.', 0
; data ends

; code segment
; start:
; 	mov ax, data
; 	mov ds, ax
; 	mov si, 0
; 	call letterc

; 	mov ax, 4c00h
; 	int 21h

; ;-------------------------------------------------------------------
; letterc:;ds:[si]开始的小写字母转变为大写字母
; 	push cx

; change:	mov ch, 0
; 	mov cl, ds:[si]
; 	jcxz changeRet
; 	cmp cl, 'a'
; 	jb next
; 	cmp cl, 'z'
; 	ja next
; 	sub cl, 20h
; 	mov ds:[si], cl

; next:	inc si
; 	jmp change

; changeRet:	pop cx
; 	ret

; code ends

; end start




; ;课程设计1
; assume cs:codesg, ds:datasg, ss:stacksg

; datasg segment
; 	db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
; 	db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
; 	db '1993', '1994', '1995'
; 	;以上表示21年的21个字符串
; 	dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 87479, 140417, 197514
; 	dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
; 	;以上表示21年公司收入的21个dword型数据
; 	dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
; 	dw 11542, 14430, 15257, 17800
; 	;以上表示21年公司雇员人数的21个word型数据
; datasg ends

; tablesg segment
; 	          ;'0123456789ABCDEF'
; 	db 21 dup ('year summ ne ?? ')
; tablesg ends

; ;栈段，多层循环中保存cx
; stacksg segment
; 	db 128 dup (0)
; stacksg ends

; stringsg segment
; 	db 10 dup ('0'), 0
; stringsg ends

; codesg segment
; start:	;初始化栈
; 	mov ax, stacksg
; 	mov ss, ax
; 	mov sp, 128

; 	call input_table
; 	call clear_screen
; 	call output_table

; 	mov ax, 4c00h
; 	int 21h

; ;-------------------------------------------------------------------
; show_year:	;将ds:[si]开始的四个字符的年份写入es:[di]开始的内存中
; 	;将用到的寄存器压入栈
; 	push cx
; 	push ax
; 	push bx
; 	push bp
; 	push di

; 	add di, 3 * 2	;这儿修改年份开始列
; 	mov bx, 0	;bx用来指示显示器内存的位置（每次加2）
; 	mov bp, 0	;bp用来指示原数据的位置（每次加1）
; 	mov cx, 4	;循环四次显示4个字符
; showYear:
; 	mov al, ds:[si+bp]
; 	mov es:[di+bx], al
; 	inc bp
; 	add bx, 2
; 	loop showYear
	
; 	pop di
; 	pop bp
; 	pop bx
; 	pop ax
; 	pop cx

; 	ret
; ;===================================================================
; ;-------------------------------------------------------------------
; long_div:	
; 	mov cx, 10
; 	push ax
; 	mov bp, sp

; 	mov ax, dx
; 	mov dx, 0
; 	div cx
; 	push ax
; 	mov ax, ss:[bp]
; 	div cx
; 	mov cx, dx
; 	pop dx

; 	add sp, 2
; 	add cx, 30h
; 	mov es:[bx], cl
; 	dec bx

; 	ret
; ;-------------------------------------------------------------------
; isShortDiv:;[dx][ax]以十进制写入es:[bx]中 bx递减 的除法实现
; 	mov cx, dx
; 	jcxz shortDiv
; 	call long_div
; 	jmp isShortDiv
	
; divRet:	ret

; shortDiv:
; 	mov cx, 10
; 	div cx			;除法非常消耗cpu性能
; 	add dx, 30h
; 	mov es:[bx], dl
; 	mov dx, 0
; 	dec bx
; 	mov cx, ax
; 	jcxz divRet
; 	jmp shortDiv
; ;-------------------------------------------------------------------
; input_string:
; 	;将dx，ax的内容以十进制的形式写入stringsg的段中
; 	push ax
; 	push cx
; 	push dx
; 	push ds
; 	push es
; 	push si
; 	push di

; 	mov bx, stringsg
; 	mov es, bx
; 	mov bx, 9
; 	call isShortDiv

; 	pop di 
; 	pop si 
; 	pop es
; 	pop ds
; 	pop dx
; 	pop cx
; 	pop ax	

; 	ret
; ;-------------------------------------------------------------------
; show_string:	;将ds:[si]开始不为零的字符串写入es:[di]中
; 	push bx
; 	push cx
; 	push ds
; 	push es
; 	push si
; 	push di

; showString:	mov ch, 0
; 	mov cl, ds:[bx+1]
; 	jcxz show_string_ret
; 	mov es:[di], cl 
; 	add di, 2
; 	inc bx
; 	jmp showString
; show_string_ret:
; 	pop di
; 	pop si
; 	pop es
; 	pop ds
; 	pop cx
; 	pop bx
; 	ret
; ;-------------------------------------------------------------------
; show_sum:	;以十进制形式显示ds:[si+5]开始的四个字节的内容（数值显示）
; 	push ax
; 	push bx
; 	push dx
; 	push ds
; 	push si
; 	push di
; 	mov ax, ds:[si+5]
; 	mov dx, ds:[si+7]
; 	call input_string	;这句结束之后string中是十进制的字符了
; 			;结束之后bx指向string中第一个有意义的字符
; 	mov ax, stringsg
; 	mov ds, ax			
; 	mov si, 0		;ds:[si]

; 	add di, 15 * 2	;es:[di] 这儿修改总收入开始列
; 	call show_string

; 	pop di
; 	pop si
; 	pop ds
; 	pop dx
; 	pop bx
; 	pop ax
; 	ret
; ;-------------------------------------------------------------------
; show_num:	
; 	push ax
; 	push bx
; 	push dx
; 	push ds
; 	push si
; 	push di

; 	mov ax, ds:[si+10]
; 	mov dx, 0
; 	call input_string 	;这句结束之后string中是十进制的字符了
; 			;结束之后bx指向string中第一个有意义的字符

; 	mov ax, stringsg
; 	mov ds, ax			

; 	add di, 30 * 2	;es:[di] 这儿修改雇员数开始列
; 	call show_string

; 	pop di
; 	pop si
; 	pop ds
; 	pop dx
; 	pop bx
; 	pop ax
; 	ret
; ;-------------------------------------------------------------------
; show_salary:	
; 	push ax
; 	push bx
; 	push dx
; 	push ds
; 	push si
; 	push di

; 	mov ax, ds:[si+13]
; 	mov dx, 0
; 	call input_string 	;这句结束之后string中是十进制的字符了
; 			;结束之后bx指向string中第一个有意义的字符

; 	mov ax, stringsg
; 	mov ds, ax			

; 	add di, 45 * 2	;es:[di] 这儿修改人均收入开始列
; 	call show_string

; 	pop di
; 	pop si
; 	pop ds
; 	pop dx
; 	pop bx
; 	pop ax
; 	ret
; ;-------------------------------------------------------------------
; output_table:
; 	;要显示的内容都在ds:[si]开始的16*21字节内
; 	mov ax, tablesg
; 	mov ds, ax
; 	mov si, 0		;ds:[si]
	
; 	mov ax, 0B800h
; 	mov es, ax
; 	mov di, 160 * 3;es:[di]开始显示

; 	mov cx, 21
; outputTable:
; 	call show_year
; 	call show_sum
; 	call show_num
; 	call show_salary
; 	add si, 16
; 	add di, 160
; 	loop outputTable
; 	ret
; ;===================================================================
; ;-------------------------------------------------------------------
; clear_screen:
; 	push ax
; 	push ds
; 	push si
; 	push cx

; 	mov ax, 0B800h
; 	mov ds, ax
; 	mov si, 0		;ds:[si]
; 	mov ax, 0700h	;ax是NULL的ascii码

; 	mov cx, 2000
; clearScreen:
; 	mov ds:[si], ax
; 	add si, 2
; 	loop clearScreen

; 	pop cx
; 	pop si
; 	pop ds
; 	pop ax
; 	ret
; ;===================================================================
; ;-------------------------------------------------------------------
; input_table:
; 	push ax
; 	push bx
; 	push cx
; 	push dx
; 	push ds
; 	push es
; 	push si
; 	push di

; 	mov bx, datasg
; 	mov ds, bx
; 	mov si, 0		;年份与收入所在内存的起始地址
; 	mov di, 21 * 4 * 2	;雇员人数所在内存的起始地址

; 	mov bx, tablesg
; 	mov es, bx
; 	mov bx, 0		;数据目的内存的起始地址

; 	mov cx, 21
; transfer:	;移动年份
; 	push ds:[si+0]
; 	pop es:[bx+0]
; 	push ds:[si+2]
; 	pop es:[bx+2]
; 	;移动收入
; 	mov ax, ds:[si+84]
; 	mov dx, ds:[si+86]
; 	mov es:[bx+5], ax
; 	mov es:[bx+7], dx
; 	;移动员工数量
; 	push ds:[di+0]
; 	pop es:[bx+10]

; 	;计算平均收入并移动
; 	div word ptr es:[bx+10]
; 	mov es:[bx+13], ax

; 	add si, 4
; 	add di, 2
; 	add bx, 16
; 	loop transfer

; 	pop di 
; 	pop si
; 	pop es
; 	pop ds
; 	pop dx
; 	pop cx
; 	pop bx
; 	pop ax
; 	ret
; ;===================================================================

; codesg ends

; end start




; ;实验10-数值显示
; assume cs:codesg

; datasg segment
; 	db 10 dup (0)
; datasg ends

; stacksg segment
; 	db 128 dup (0)
; stacksg ends

; codesg segment
; start:	mov bx, stacksg	;初始化栈
; 	mov ss, bx
; 	mov sp, 128

; 	;转换的参数
; 	mov ax, 9768h	;要转换数的低位
; 	mov dx, 5ah		;要转换数的高位
; 	mov bx, datasg
; 	mov ds, bx		;转换结果保存的地方
; 	mov si, 0
; 	call dtoc

; 	;显示的参数
; 	mov dh, 8	;显示在屏幕的哪一行
; 	mov dl, 3	;显示在屏幕的哪一列
; 	mov cl, 10000010B	;闪烁1，背景3，高亮1，前景3
; 	call show_str

; 	mov ax, 4c00h
; 	int 21h


; ;--------------------------------------------------------------------
; dtoc:	push di
; 	push cx
; 	mov di, 0		;循环次数

; circulate:	mov cx, 10
; 	call divdw
; 	add cx, 30h
; 	push cx
; 	inc di

; 	mov cx, ax
; 	jcxz jump_out

; 	jmp circulate


; ;---------------------------------------------
; jump_out:	
; 	mov cx, di	
; ;--------------------------
; write:	pop ds:[si]
; 	inc si
; 	loop write
; 	mov byte ptr ds:[si], 0		;以0结尾
; 	mov si, 0
; ;==========================
; ;=============================================
; 	pop cx
; 	pop di
; 	ret
; ;=====================================================================


; ;---------------------------------------------------------------------
; divdw:	push bx	;用来暂存中间商

; 	push ax	;将被除数低16位入栈

; 	mov ax, dx
; 	mov dx, 0
; 	div cx	;div之后dx中存放余数，ax中存放高位除以除数的商

; 	mov bx, ax	;暂存商，累加到最终结果的dx中

; 	pop ax

; 	div cx	;div之后dx存放余数，ax中存放商

; 	mov cx, dx
; 	mov dx, bx

; 	pop bx

; 	ret
; ;=====================================================================

; show_str:	push es
; 	push di
; 	push ax

; 	mov ax, 0B800h
; 	mov es, ax

; 	mov al, 0a0h
; 	dec dh
; 	mul dh
; 	mov di, ax

; 	mov al, 2
; 	dec dl
; 	mul dl
; 	add di, ax	;es:[di]

; 	mov al, cl
; show_char:	mov ch, 0
; 	mov cl, ds:[si]
; 	jcxz ok
; 	mov ch, al
; 	mov es:[di], cx
; 	add di, 2
; 	inc si
; 	jmp show_char

; ok:	pop ax
; 	pop di
; 	pop es
; 	ret

; codesg ends

; end start





; ;实验10-解决除法溢出的问题
; assume cs:codesg, ds:datasg, ss:stacksg

; datasg segment
; 	dd 1234567
; datasg ends

; stacksg segment
; 	db 128 dup (0)
; stacksg ends

; codesg segment
; start:	mov ax, stacksg	;初始化栈
; 	mov ss, ax
; 	mov sp, 128

; 	mov ax, datasg
; 	mov ds, ax

; 	mov ax, 0D687h
; 	mov dx, 0012h
; 	mov cx, 0ah
; 	call divdw

; 	mov ax, 4c00h
; 	int 21h
; ;----------------------------------------------------
; divdw:	push bx	;用来暂存中间商
; 	push ax	;将被除数低16位入栈

; 	mov ax, dx
; 	mov dx, 0
; 	div cx	;div之后dx中存放余数，ax中存放高位除以除数的商

; 	mov bx, ax	;暂存商，累加到最终结果的dx中

; 	pop ax

; 	div cx	;div之后dx存放余数，ax中存放商

; 	mov cx, dx
; 	mov dx, bx

; 	pop bx
; 	ret
; codesg ends

; end start

; ;实验10-显示字符串
; assume cs:codesg, ds:datasg, ss:stacksg

; stacksg segment
; 	db 64 dup (0)
; stacksg ends

; datasg segment
; 	db 'Welcome to masm!', 0
; datasg ends

; codesg segment
; start:	mov ax, stacksg	;初始化栈
; 	mov ss, ax
; 	mov sp, 64
	
; 	mov dh, 8		;dx
; 	mov dl, 3
; 	mov cl, 2		;cx
; 	mov ax, datasg
; 	mov ds, ax		;ds:[si]
; 	mov si, 0

; 	call show_str

; 	mov ax, 4c00h
; 	int 21h
; ;------------------------------------------------------
; show_str:	push es
; 	push di
; 	push ax

; 	mov ax, 0B800h
; 	mov es, ax

; 	mov al, 0a0h
; 	dec dh
; 	mul dh
; 	mov di, ax

; 	mov al, 2
; 	dec dl
; 	mul dl
; 	add di, ax	;es:[di]

; 	mov al, cl
; show_char:	mov ch, 0
; 	mov cl, ds:[si]
; 	jcxz ok
; 	mov ch, al
; 	mov es:[di], cx
; 	add di, 2
; 	inc si
; 	jmp show_char

; ok:	pop ax
; 	pop di
; 	pop es
; 	ret
; ;=======================================================
; codesg ends

; end start

; ;实验9
; assume cs:codesg, ds:datasg, ss:stacksg

; datasg segment
; 	   ;0123456789ABCDEF
; 	db 'welcome to masm!'
; 	db 00000010B
; 	db 10100100B
; 	db 11110001B
; datasg ends

; stacksg segment
; 	db 128 dup (0)
; stacksg ends

; codesg segment
; start:	mov ax, stacksg	;初始化栈
; 	mov ss, ax
; 	mov sp, 128

; 	jmp show_masm

; ;----------------------------------------
; next:	mov ax, 4c00h
; 	int 21h

; ;----------------------------------------
; show_masm:	
; 	mov ax, datasg
; 	mov ds, ax

; 	mov ax, 0B800h
; 	mov es, ax
; 	mov di, 160*11 + 32*2	;es:[di]

; 	mov bx, 16		;ds:[bx]
; 	mov cx, 3
; show_line:	push cx
; 	push di
; 	mov si, 0		;ds:[si]
; 	mov cx, 16
; 	mov dh, [bx]

; show_str:	mov dl, [si]
; 	mov es:[di], dx
; 	add di, 2
; 	inc si
; 	loop show_str

; 	inc bx
; 	pop di
; 	add di, 160
; 	pop cx
; 	loop show_line

; 	jmp next
; codesg ends

; end start


; ;实验8
; assume cs:codesg
; codesg segment

; 	mov ax, 4c00h
; 	int 21h

; start:
; 	mov ax, 0

; s:	nop
; 	nop
; 	mov di, offset s
; 	mov si, offset s2
; 	mov ax, cs:[si]
; 	mov cs:[di], ax

; s0:	jmp short s

; s1:	mov ax, 0
; 	int 21h
; 	mov ax, 0

; s2:	jmp short s1
; 	nop
; codesg ends
; end start


;附录3
; assume cs:codesg
; codesg segment
; s:	jmp s
; 	jmp short s
; 	jmp near ptr s
; 	jmp far ptr s
; codesg	 ends
; end

; assume cs:codesg
; codesg segment
; s:	db 100 dup (0b8h, 0, 0)
; 	;jmp short s
; 	jmp s
; 	jmp near ptr s
; 	jmp far ptr s
; codesg	ends
; end

; assume cs:code
; code segment
; begin:
; 	jmp short s
; 	jmp s
; 	jmp near ptr s
; 	jmp far ptr s
; s:	mov ax, 0
; code ends
; end begin

; assume cs:code
; code segment
; begin:
; 	;jmp short s
; 	jmp s
; 	jmp near ptr s
; 	jmp far ptr s
; 	db 100 dup (0b8h, 0, 0)
; s:	mov ax, 2
; code ends
; end begin

; ;第八章实验7
; assume cs:codesg, ds:datasg, ss:stacksg

; datasg segment
; 	db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
; 	db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
; 	db '1993', '1994', '1995'
; 	;以上表示21年的21个字符串
; 	dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 87479, 140417, 197514
; 	dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
; 	;以上表示21年公司收入的21个dword型数据
; 	dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
; 	dw 11542, 14430, 15257, 17800
; 	;以上表示21年公司雇员人数的21个word型数据
; datasg ends

; table segment
; 	db 21 dup ('year summ ne ?? ')
; table ends

; ;栈段，多层循环中保存cx
; stacksg segment
; 	dw 0, 0, 0, 0, 0, 0, 0, 0
; stacksg ends

; codesg segment
; start:
; 	;初始化栈
; 	mov ax, stacksg
; 	mov ss, ax
; 	mov sp, 10h
; 	;初始化原数据指针
; 	mov ax, datasg
; 	mov ds, ax
; 	mov bx, 0
; 	;初始化指向table指针
; 	mov ax, table
; 	mov es, ax
; 	mov bp, 0

; 	;移动年份与收入
; 	mov si, 0;表示年份与总收入的偏移量（因为两个都是4字节，可以一起表示）
; 	mov di, 0;表示雇员数据的偏移量
; 	mov cx, 21

; s0:	push cx

; 	mov cx, 2
; 	s1:	;mov word ptr es:[bp].0[di], ds:[bx].0[si]
; 		;mov不能直接内存到内存，必须reg中转
; 		mov ax, ds:[bx].0[si];移动年份
; 		mov es:[bp].0[di], ax;无显性短地址使用[bp]时段地址默认保存在ss中，所以要显性给出段地址
; 		;mov word ptr es:[bp].5[di], ds:[bx].84[si]
; 		mov ax, ds:[bx].84[si];移动公司总收入
; 		mov es:[bp].5[di], ax
; 		inc si
; 		inc si;年份与收入的偏移量
; 		inc di
; 		inc di;table中的偏移量
; 		loop s1
; 	mov di, 0;根据table的结构化数据，偏移量要重置
; 	add bp, 10h;将bp指向table下一个结构项
; 	pop cx
; 	loop s0

; 	;移动雇员人数
; 	mov si, 0
; 	mov bp, 0
; 	mov cx, 21
; s2:	;mov word ptr es:[bp].10, ds:[bx].168[si]
; 	mov ax, ds:[bx].168[si]
; 	mov es:[bp].10, ax
; 	inc si
; 	inc si
; 	add bp, 10h
; 	loop s2

; 	;计算人均收入
; 	mov bp, 0
; 	mov cx, 21
; 	;32位除以16位
; s3:	mov ax, es:[bp].5;低位保存在ax中
; 	mov dx, es:[bp].7;高位保存在dx中
; 	div word ptr es:[bp].10;div 内存
; 	mov es:[bp].13, ax;将商移动到内存中
; 	add bp, 10h;指向下一个结构项
; 	loop s3

; 	mov ax, 4c00h
; 	int 21h

; codesg ends

; end start

; ;问题7.9
; assume cs:codesg, ds:datasg, ss:stacksg

; stacksg segment
; 	dw 0, 0, 0, 0, 0, 0, 0, 0
; stacksg ends

; datasg segment
; 	db '1. display      '
; 	db '2. brows        '
; 	db '3. replace      '
; 	db '4. modify       '
; datasg ends

; codesg segment
; start:
; 	mov ax, stacksg
; 	mov ss, ax
; 	mov sp, 10h

; 	mov ax, datasg
; 	mov ds, ax
; 	mov bx, 0

; 	mov cx, 4
; s0:	push cx
; 	mov si, 3

; 	mov cx, 4
; 	s1:	mov al, [bx+si]
; 		and al, 11011111B
; 		mov [bx+si], al
; 		inc si
; 		loop s1

; 	add bx, 10h
; 	pop cx
; 	loop s0

; 	mov ax, 4c00h
; 	int 21h
; codesg ends

; end start

; ;问题7.7/7.8
; assume cs:codesg, ds:datasg, ss:stacksg

; datasg segment
; 	db 'ibm             '
; 	db 'dec             '
; 	db 'dos             '
; 	db 'vax             '
; datasg ends

; stacksg segment
; 	dw 0, 0, 0, 0, 0, 0, 0, 0
; stacksg ends

; codesg segment
; start:
; 	mov ax, stacksg
; 	mov ss, ax
; 	mov sp, 10h

; 	mov ax, datasg
; 	mov ds, ax
; 	mov bx, 0

; 	mov cx, 4
; s0:	push cx
; 	mov si, 0
; 	mov cx, 3
; 	s1:	mov al, [bx+si]
; 		and al, 11011111B
; 		mov [bx+si], al
; 		inc si
; 		loop s1
; 	add bx, 16
; 	pop cx
; 	loop s0

; 	mov ax, 4c00h
; 	int 21h
; codesg ends

; end start

; ;问题7.6
; assume cs:codesg, ds:datasg

; datasg segment
; 	db '1. file         '
; 	db '2. edit         '
; 	db '3. search       '
; 	db '4. view         '
; 	db '5. options      '
; 	db '6. help         '
; datasg ends

; codesg segment
; start:
; 	mov ax, datasg
; 	mov ds, ax
; 	mov si, 3
; 	mov bx, 0

; 	mov cx, 6
; s:	mov al, [bx+si]
; 	and al, 11011111B
; 	mov [bx+si], al
; 	add bx, 16
; 	loop s

; 	mov ax, 4c00h
; 	int 21h
; codesg ends

; end start


;第七章大小写字母转换
; assume cs:codesg, ds:datasg

; datasg segment
; 	db 'BaSiC'
; 	db 'iNfOrMaTiOn'
; datasg ends

; codesg segment
; start:
; 	mov ax, datasg
; 	mov ds, ax

; 	mov bx, 0

; 	mov cx, 5
; s1:	mov al, [bx]
; 	and al, 11011111B
; 	mov [bx], al
; 	inc bx
; 	loop s1

; 	mov cx, 11
; s2:	mov al, [bx]
; 	or al, 00100000B
; 	mov [bx], al
; 	inc bx
; 	loop s2

; 	mov ax, 4c00h
; 	int 21h
; codesg ends

; end start


; ;实验5 - （6）
; assume cs:code

; a segment
; 	dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh, 0ffh
; a ends

; b segment
; 	dw 0, 0, 0, 0, 0, 0, 0, 0
; b ends

; code segment
; start:
; 	mov ax, a
; 	mov ds, ax
; 	mov ax, b
; 	mov ss, ax
; 	mov sp, 10h

; 	mov bx, 0

; 	mov cx, 8
; s:	push [bx]
; 	inc bx
; 	inc bx
; 	loop s

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start

;实验5 - （5）
; assume cs:code

; a segment
; 	db 1, 2, 3, 4, 5, 6, 7, 8
; a ends

; b segment
; 	db 1, 2, 3, 4, 5, 6, 7, 8
; b ends

; c segment
; 	db 0, 0, 0, 0, 0, 0, 0, 0
; c ends

; code segment
; start:
; 	mov ax, a
; 	mov ds, ax

; 	mov bx, 0

; 	mov cx, 8
; s:	mov al, 0
; 	add al, [bx]
; 	add al, [bx+16]
; 	mov [bx+32], al
; 	inc bx
; 	loop s

; 	mov ax, 4c00h
; 	int 21h
; code ends

; end start

;实验5 - （1）（2）（3）（4）
; assume cs:code, ds:data, ss:stack

; code segment
; start:
; 	mov ax, stack
; 	mov ss, ax
; 	mov sp, 16

; 	mov ax, data
; 	mov ds, ax

; 	push ds:[0]
; 	push ds:[2]
; 	pop ds:[2]
; 	pop ds:[0]

; 	mov ax, 4c00h
; 	int 21h
; code ends

; data segment
; 	dw 0123h, 0456h;, 0789h, 0abch, 0defh, 0fedh, 0cbah, 0987h
; data ends

; stack segment
; 	dw 0, 0;, 0, 0, 0, 0, 0, 0
; stack ends

; end start