		org 100h
;największy bit znajduje się w prawym górnym rogu ekranu, a najmniejszy na samym dole po prawej
;wynik wydaje się poprawny
section .text 
		mov dx,hello		;wypisujemy info
		mov ah,09h
		int 21h

		mov ah,0ah		;wpisujemy liczbe
		mov dx,liczba
		int 21h
		
		mov al, [liczba+1]	;sprawdzamy czy wprowadzono poprawnie liczbe
		cmp al,2
		jb zakres		;jesli liczba wprowadzonych liczb jest mniejsza od2
					;to skaczmy
		mov al,[liczba+2]	;do al wrzucamy pierwsza liczbe
		mov [wal],al		;z al sciagamy liczbe

		mov bl,48		;sprawdzamy wazniejsza cyfre
		sub al,bl
				

		cmp al,3		;sprawdzamy czy sie zmiesci w zakresie
		ja zakres		;jesli zmienna nie jest liczba to

		mov al,[liczba+3]	;wrzucamy 2 liczbe do al
		mov [wal+1],al		;z al sciagamy liczbe
		sub al,bl		;odejmujemy 48
		cmp al,9	
		ja zakres		;jesli liczba jest z poza przedzialu 0-9 to nara
		mov dx,hello2		;twoja liczba to:
		mov ah,09h
		int 21h
		

		mov dx,liczba+2		;wypisyjemy liczbe
		mov ah,09h
		int 21h

		mov dx,space		;formatujemy ekran
		mov ah,09h
		int 21h	

		


		mov al,[wal+1]		;wczytujemy mlodsza cyfre
		sub al,bl		;odejmujemy zero
		mov [tmp],al 		;zapisujemy do tmp
		
		mov al,[wal]
		sub al,bl
		mov cx,10
		
petla:		add [tmp+1],al
		loop petla	
				
		mov al,[tmp+1]
		add [tmp],al
		
		xor eax,eax

		mov al,[tmp]
			
					;jesli liczba jest wieksza od 34 
		cmp al,34		;to konczymy
		ja zakres
		

		mov al,[tmp]		;w [tmp] jest liczba ktora weszla	
		cmp al,2		
		jb zero
		
		cmp al,2
		je zero2
		

		xor ecx,ecx
		mov cl,[tmp]		;do licznika wpisujemy do co weszlo
					;zmniejszamy licznik o 1
		
		xor ebx,ebx
		xor eax,eax
		mov al,[tmp]	
		mov [a],eax		;do a przypisujemy msb wyniku ktory siedzi w eax
		
; w zalozeniu to powinno dzialac		
		
silnia:		dec ecx		
		mov eax,[a]		;sciagamy lsb mnoznika do rejestru eax
		mov [b],ecx		;do b przypisujemy wartosc rejestru ecx, czyli liczbe przez ktora bedziemy mnozyc
;russian pesant alg
		cmp ecx,1		;jesli rejestr ecx jest 1 to mozna przerwac
		je koniec
		
jeden:		and al,1		;sprawdzamy czy liczba jest parzysta
		jz par			;jesli jest par, to skok i omijamy dodawanie
;dodawanie
		mov edx,[b]
		adc [wynik],edx		;jesli nie to do wyniku dodajemy b
		mov edx,[b+4]
		adc [wynik+4],edx	;i do msb wyniku dodajemy b + to co wypadnie z [wynik]
		mov edx,[b+8]		;i kolejny bajt
		adc [wynik+8],edx	;dodany do kolejnego bajtu wyniku + cf
		mov edx,[b+12]		;and again
		adc [wynik+12],edx	
		mov eax,[a]		;wczytujemy lsb [a]
		cmp eax,1		;jesli a jest 1 to mnozymy przez kolejna liczbe
		je next
		
;dzielenie i mnozenie
par:		clc		
		rcr dword [a+12],1	;to co nizej		
		rcr dword [a+8],1	;MSB dzielimy		
		rcr dword [a+4],1	;lapiemy to co wypadnie i dzielimy mniejszy bajt			
		rcr dword [a],1		;i to samo
		clc			;czyscimy flage
		rcl dword [b],1		;mnozymy lsb *2
		rcl dword [b+4],1	;i to samo, tylko ze w razie wyskoczenia 1 lapiemy
		rcl dword [b+8],1	;i jeszcze jeden 
		rcl dword [b+12],1	;i jeszcze jeden 
		mov eax,[a]		;zapisujemy nowa wartosc [a] do eax
		jmp jeden
next:		mov eax,[wynik]		;nastepna liczba
		mov [a],eax		;do [a] przypisujemy lsb wyniku ktory za chwile bedzie mnozony
		mov eax,[wynik+4]	
		mov [a+4],eax		;i to samo z msb wyniku do a+1
		mov eax,[wynik+8]	
		mov [a+8],eax		;i to samo dla a+2
		mov eax,[wynik+12]	;i jeszcze!
		mov [a+12],eax
		xor edx,edx		;zerujemy rejestr edx
		mov [wynik+12],edx
		mov [wynik+8],edx
		mov [wynik+4],edx	;i zerujemy wynik i wynik+1 aby tam zapisywac kolejne wyniki
		mov [wynik],edx
		mov [b],edx
		mov [b+4],edx
		mov [b+8],edx
		mov [b+12],edx
		jmp silnia		;jesli cx nie jest 0 to skocz
koniec:		

		xor eax,eax
		xor edx,edx
		xor ebx,ebx
		xor ecx,ecx
		
		mov cl,32
		
;wypisujemy	
		clc
		mov cl,32
wypisz4:	shl dword [a+12],1
		rcl eax,1
		adc eax,48		
		mov [out],eax
		mov dx,out
		mov ah,09h
		int 21h
		xor eax,eax
		loop wypisz4
		
		mov cl,32
wypisz3:	shl dword [a+8],1
		rcl eax,1
		adc eax,48		
		mov [out],eax
		mov dx,out
		mov ah,09h
		int 21h
		xor eax,eax
		loop wypisz3
		
		clc
		mov cl,32
wypisz:	 	shl dword [a+4],1
		rcl eax,1
		adc eax,48		
		mov [out],eax
		mov dx,out
		mov ah,09h
		int 21h
		xor eax,eax
		loop wypisz

		clc
		mov cl,32
wypisz2:	shl dword [a],1
		rcl eax,1
		adc eax,48		
		mov [out],eax
		mov dx,out
		mov ah,09h
		int 21h
		xor eax,eax
		loop wypisz2

		mov ax,4C00h
		int 21h

zero2:		mov dx,zr2
		mov ah,09h
		int 21h
		mov ax,4C00h
		int 21h

zero:		mov dx,zr
		mov ah,09h
		int 21h
		
		mov ax,4C00h
		int 21h
		
zakres:		mov dx,bug
		mov ah,09h
		int 21h
	
		mov ax,4C00h
		int 21h
section .data

hello:		db	"podaj dwie cyfry!",13,10,'$'
hello2:		db	"twoja liczba to:",32,'$'
liczba: 	db	3			;max ilosc liczb ktroe mozna podac
		db 	0			;ilosc wprowadzonych znakow
		times	5 db "$"		;wypelniamy tablice $
space:		db	13,10,'$'
wal:		db      0,0,'$'
tmp:		db	0,0,'$'
tmp1:		dd	0,0
bug:		db	"cos poszlo zle",13,10,'$'
zr:		db	" Wynik :1 $"
zr2:		db	" Wynik :2 $"
wynik:		dd	0,0,0,0
a:		dd	0,0,0,0
b:		dd	0,0,0,0
result:		dd	0,0,0,0
out:		dd	0,32,'$'

