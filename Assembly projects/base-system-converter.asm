format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'

section '.text' code readable executable
start:
	clrscr
	wyswietl description
	ustaw_kursor 0, 28

input_check:
	pob_znak
	
	cmp al, 1Bh		;ESC
	je end_program
	
	cmp al, 8h		;BACKSPACE
	je backspace

	cmp al, 0Dh		;ENTER
	je enter_check

	cmp [counter], 4d	  ;Czy 4 znaki
	je input_check
	
	cmp al,'0'
	jb  input_check
	cmp al,'9'
	jbe check_hex_num
	cmp al,'A'
	jb  input_check
	cmp al,'F'
	jbe check_hex_lower
	cmp al,'a'
	jb  input_check
	cmp al,'f'
	ja  input_check

	wysw_znak al
	sub al, 87d		 ;ascii -> liczba
	jmp save_hex_num

check_hex_lower:
	wysw_znak al
	sub al, 55d		 ;ascii -> liczba
	jmp save_hex_num       


check_hex_num:
	wysw_znak al

	sub al, 48d		  ;ascii -> litera

save_hex_num:
	inc [counter]
	shl [hex_num],4
	add [hex_num],ax

	jmp input_check

backspace: 
	cmp[counter],0		  
	je input_check

	dec[counter]

	wysw_znak al		;idz w lewo
	wysw_znak ' '		;wpisz pusty znak
	wysw_znak al		
	shr[hex_num],4
	jmp input_check

enter_check: 
	

binary:
	ustaw_kursor 2,0
	wyswietl bin_description 
	mov ax, [hex_num]
	mov ecx,16

binary_check:

	rcl ax,1			; przesuwanie w lewo z bitem Carry
	jc carry_equal_one		; jesli bit Carry rowny 1 to jmp carry_equal_one
	mov bl, '0'			; jesli bit Carry rowny 0 to bl = '0'
	jmp binary_output		; nastepnie wypisz bl w funkcji binary_output

carry_equal_one:
	mov bl, '1'

binary_output:
	wysw_znak bl
	loop binary_check

oct:
	ustaw_kursor 3,0
	wyswietl oct_description
	mov ax, [hex_num]		
	shr ax,15
	add ax,30h
	wysw_znak al			;1 cyfra oct


	mov ax,[hex_num]	 
	shl ax,1
	shr ax,13
	add ax,30h
	wysw_znak al			;2 cyfra oct


	mov ax,[hex_num]	 
	shl ax,4
	shr ax,13
	add ax,30h
	wysw_znak al			;3 cyfra oct


	mov ax,[hex_num]	 
	shl ax,7
	shr ax,13
	add ax,30h
	wysw_znak al			;4 cyfra oct


	mov ax,[hex_num]	 
	shl ax,10
	shr ax,13
	add ax,30h
	wysw_znak al			;5 cyfra oct
	
	mov ax,[hex_num]	 
	shl ax,13
	shr ax,13
	add ax,30h
	wysw_znak al			;6 cyfra oct

hex:
	ustaw_kursor 2,0
	wyswietl hex_description

	mov ax,[hex_num]		 ;1 cyfra hex
	shr ax,12			;przesun o 12 bitow w prawo == wyzeruj wszystkie bity po prawej stronie pierwszej liczby
	cmp ax,10			;porownanie z liczbow? 10 
	jb ety1 			; jesli mniejsze od 10 to ety1:
	add ax,55			; kody ascii liter
	jmp ety2
ety1:
	add ax,30h
ety2:
	wysw_znak al	    

	mov ax,[hex_num]		 ;2 cyfra hex
	shl ax,4			;przesun w lewo o 4
	shr ax,12			;przesun w prawo o 12
	cmp ax,10
	jb ety3
	add ax,55			;kody ascii liter
	jmp ety4
ety3:
	add ax,30h
ety4:
	wysw_znak al 

	mov ax,[hex_num]		;3 cyfra hex
	shl ax,8			;w lewo o 8
	shr ax,12			;w prawo o 12
	cmp ax,10
	jb ety5
	add ax,55			; kody ascii liter
	jmp ety6
ety5:
	add ax,30h
ety6:
	wysw_znak al 

	mov ax,[hex_num]		;4 cyfra hex
	and ax,000Fh			;Wyzeruj 12 bitow po lewej, zostaw 4 z prawej
	cmp ax,10
	jb ety7
	add ax,55			; kody ascii liter
	jmp ety8
ety7:
	add ax,30h
ety8:
	wysw_znak al	  

decimal:
	ustaw_kursor 4,0
	wyswietl dec_description

check_sign:
	mov ax, [hex_num]
	shr ax,15

	cmp al,0
	je add_plus

	jmp add_minus

add_plus:
	mov ax, [hex_num]
	jmp show_dec

add_minus:
	wysw_znak '-'
	mov ax, [hex_num]

	shl ax,1
	shr ax,1

show_dec:

	mov bx, 10		      ; dzielnik = 10
	mov cx, 0		      ; dlugosc petli

dec_loop_divide_by_10:
	mov dx, 0
	div bx			      ; ax / bx
	add dx, 30h		      ; liczba -> ascii
	push dx 		      ; wrzucanie na stos reszty z dzielenia liczby
	inc cx			      ; zwiekszenie cx o 1, ile razy petla ma sie wykonac
	cmp ax, 0		      ; por�wnanie dzielnej z zerem
	jne dec_loop_divide_by_10

dec_show:			      ; wyswiettlanie ze stosu
	pop dx
	wysw_znak dl
	LOOP dec_show						      

end_program:
	pob_znak
	end_prog

section '.data' data readable writeable

	hex_num dw 0h			;podana liczba
	counter dw 0d			;licznik znakow(4)

	description db 'Wpisz 4 cyfry szesnastkowo: ',10,13,NULL

	bin_description db '[wartosc BIN]: ',NULL
	oct_description db 13,10,'[wartosc OCT]: ',NULL
	dec_description db 13,10,'[wartosc DEC]: ',NULL
	hex_description db 13,10,'[wartosc HEX]: ',NULL
	   
