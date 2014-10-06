;zadanie 2 linia czarno_biala
		org 100h
;faza 1 sprawdzamy ktory x jest wiekszy

		mov ax,[x0]
		cmp ax,[x1]
		ja  x0_wieksze		;jesli x0 wieksze to skok
		
		xor eax,eax		;od x1 odejmujemy x0

		mov ax,[x1]		;jesli nie to obliczamy abs dla x1
		sub ax,[x0]
		mov [absx],ax
		mov cx,1		
		mov [sx],cx		;i do sx zapisujemy 1
		jmp spr_y


x0_wieksze:	sub ax,[x1]		;jesli x0 jest wieksze to od x0 odejmujemy x1 
		mov [absx],ax
		mov cx,-1		;i do cx zapisujemy -1
		mov [sx],cx

;teraz sprawdzamy y
spr_y:
		xor eax,eax		;dla pewnosci zerujemy rejestry
		xor ecx,ecx
	
		mov ax,[y0]
		cmp ax,[y1]
		ja  y0_wieksze		;jesli y0 wieksze to skok
		
		xor eax,eax		;od y1 odejmujemy y0

		mov ax,[y1]		;jesli nie to obliczamy abs dla y1
		sub ax,[y0]
		neg ax
		mov [absy],ax
		mov cx,1		
		mov [sy],cx		;i do sy zapisujemy 1
		jmp rysowanko


y0_wieksze:	sub ax,[y1]		;jesli y0 jest wieksze to od y0 odejmujemy y1
		neg ax 
		mov [absy],ax		
		mov cx,-1		;i do cx zapisujemy -1
		mov [sy],cx	

rysowanko:	xor eax,eax		;na wszelki wypadek zerujemy
		xor ecx,ecx	
		
		mov ax,[absx]		;zapisujemy nasz blad rysowania
		add ax,[absy]
		mov [err],ax

		xor eax,eax

		mov ax,11h		;przechodzimy do trybu graficznego
		int 10h
		
		mov ax,0a000h
		mov es,ax		;zapisujemy gorny adres 
		xor eax,eax
		mov bx,[y0]		;obliczamy poczatek linii
		mov ax,80
		imul bx
		sar dword[x0],3
		add ax,[x0]
		mov di,ax

		mov al,255		;domyslny kolor	
		mov cx,100
;rysujemy
		xor eax,eax
rysuj:
		mov [es:di],al		;wypisujemy piksla w danym miejscu di, z kolorkiem dl
		xor eax,eax

		mov ax,[x0]		;sprawdzamy czy mozna skonczyc rysowanie
		cmp ax,[x1]
		je x_rowne		;pozycje x sa rowne
		jmp nie_rowne

x_rowne:	mov ax,[y0]		;to sprawdzamy czy y sa rowne
		cmp ax,[y1]
		je y_rowne		;jesli tak to koniec
		
nie_rowne:	
		xor eax,eax
		mov ax,[err]		;sciagamy nasz err i mnozymy *2
		shl ax,1
		mov [e2],ax		;i wrzucamy do e2

		mov ax,[e2]		;dla pewnosci		
		cmp ax,[absy]		;porownujemy nasz blad z absy 
		jnl e2_wiekszy_dy	;e2 jest wiekszy, rowny z dy
		jmp e2_mniejsze_dy

e2_wiekszy_dy:  mov ax,[err]		;obliczamy nowe pozycje x0 i y0
		add ax,[absy]
		mov [err],ax
		mov ax,[x0]
		add ax,[sx]
		mov [x0],ax
	
e2_mniejsze_dy:	xor eax,eax	
		mov ax,[e2]
		cmp ax,[absx]
		jng e2_mniejsze_dx
		jmp e2_wieksze_dx

e2_mniejsze_dx: mov ax,[err]
		add ax,[absx]
		mov [err],ax
		mov ax,[y0]
		add ax,[sy]
		mov [y0],ax
e2_wieksze_dx: 
		xor eax,eax
		xor ebx,ebx
		mov bx,[y0]			;obliczamy poczatek linii
		mov ax,80
		imul bx
		mov cx,[x0]
		sar cx,3
		add ax,cx
		mov di,ax			;obliczamy gdzie ma sie wyrysowac
		mov al,15
		jmp rysuj
y_rowne:
		xor ah,ah
		int 16h

		mov ax,3
		int 10h

		mov ax,4c00h
		int 21h
section .data
hello:		db	"xo jest wieksze!",13,10,'$'
hello2:		db	"x1 jest wieksze!",13,10,'$'
x0:		dw	0	;kolumna poczatkowa
y0:		dw	0	;wiersz poczatkowu
x1:		dw	640	;kolumna koncowa
y1:		dw	480  	;wiersz koncowa
absx:		dw	0	;wartosc bezwzgl z x0 x1
absy:		dw	0	;wartosc bezwzgl z y0 y1
sx:		dw	0	;x0<x1?1:-1 dzieki temu wiemy czy x sie zwieksza czy maleje
sy:		dw	0	;y0<y2?1:-1 dzieki temu wiemy czy y rosnie czy maleje
err:		dw	0	;error
e2		dw	0	;error2
tmp		dw	0	
