;zadanie 2 kolo czarno_biale
		org 100h
;faza 1 przypisujemy zmienne

		mov ax,[r]
		neg ax
		mov [x],ax

		xor eax,eax
		mov bx,[r]
		shl bx,1
		mov ax,2
		sub ax,bx
		mov [err],ax

;faza 2 przechodzimy do rysowania
		xor eax,eax
		xor ebx,ebx


		mov ax,11h		;tryb graficzny
		int 10h
		
		mov ax,0a000h
		mov es,ax
		mov di,00

		
		
		mov cx,[x]

rysuj:		mov ax,[xm]		;obliczamy x w pierwszym kroku
		sub ax,[x]
		sar ax,3
		clc
		mov [tmp],ax		;i zapisujemy do tmp
		mov ax,[ym]		;obliczamy y
		add ax,[y]		
		mov bx,80		
		imul bx			;mnozymy y przez 80 bo 80*8 =640
		add ax,[tmp]		;i dodajemy do pozycji x
		mov di,ax		;zapisujemy pozycje do di
		mov al,255
		mov [es:di],al		;rysujemy
;nastepna poz
		xor eax,eax
		mov ax,[xm]		;obliczamy x
		sub ax,[y]
		sar ax,3
		clc
		mov [tmp],ax		;i zapisujemy do tmp
		mov ax,[ym]		;obliczamy y
		sub ax,[x]		
		imul bx			;mnozymy y przez 320
		add ax,[tmp]		;i dodajemy do pozycji x
		mov di,ax		;zapisujemy pozycje do di
		mov al,255
		mov [es:di],al		;rysujemy

;nastepna poz
		xor eax,eax
		mov ax,[xm]		;obliczamy x
		add ax,[x]
		sar ax,3
		clc
		mov [tmp],ax		;i zapisujemy do tmp
		mov ax,[ym]		;obliczamy y
		sub ax,[y]		
		imul bx			;mnozymy y przez 320
		add ax,[tmp]		;i dodajemy do pozycji x
		mov di,ax		;zapisujemy pozycje do di
		mov al,255
		mov [es:di],al		;rysujemy

;nastepna poz
		xor eax,eax
		mov ax,[xm]		;obliczamy x
		add ax,[y]
		sar ax,3
		clc
		mov [tmp],ax		;i zapisujemy do tmp
		mov ax,[ym]		;obliczamy y
		add ax,[x]		
		imul bx			;mnozymy y przez 320
		add ax,[tmp]		;i dodajemy do pozycji x
		mov di,ax		;zapisujemy pozycje do di
		mov al,255
		mov [es:di],al		;rysujemy
		
		xor eax,eax		;gdy juz skonczylismy rysowac
		mov ax,[err]
		mov [r],ax

		mov ax,[r]
		cmp ax,[y]
		jng r_mnR_y
		jmp nie_r

r_mnR_y:	mov ax,[err]		;sprawdzamy co trzeba zwiekszyc a co nie
		mov bx,[y]
		inc bx
		mov [y],bx
		shl bx,1
		inc bx
		add ax,bx
		mov [err],ax	

	
nie_r:		mov ax,[r]
		cmp ax,[x]
		jg r_wieksze_x	
		mov ax,[err]
		cmp ax,[y]
		jg r_wieksze_x
		jmp next

r_wieksze_x:	mov ax,[err]
		mov bx,[x]
		inc bx
		mov [x],bx
		shl bx,1
		inc bx
		add ax,bx
		mov [err],ax
		inc cx

next:		cmp cx,0
		je end
		jmp rysuj
end:
		xor ah,ah
		int 16h

		mov ax,3
		int 10h

		

		mov ax,4c00h
		int 21h
section .data
hello:		db	"xo jest wieksze!",13,10,'$'
hello2:		db	"x1 jest wieksze!",13,10,'$'
xm:		dw	320	;srodek
ym:		dw	240	;srodek
x:		dw	0	;tmp
y:		dw	0  	;tmp
r:		dw	20	;promien
tmp:		dw	0	;zmienna pomocnicza
err:		dw	0	;error

