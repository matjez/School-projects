format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'            
;Grupa f: y = a + b % c

macro bajt_w_prawo bajt 
{
    rcr [bajt + 5 * 1], 1
    rcr [bajt + 4 * 1], 1
    rcr [bajt + 3 * 1], 1
    rcr [bajt + 2 * 1], 1
    rcr [bajt + 1 * 1], 1
    rcr [bajt + 0 * 1], 1
}

macro bajt_w_lewo bajt 
{
    rcl [bajt + 0 * 1], 1
    rcl [bajt + 1 * 1], 1
    rcl [bajt + 2 * 1], 1
    rcl [bajt + 3 * 1], 1
    rcl [bajt + 4 * 1], 1
    rcl [bajt + 5 * 1], 1
}


section '.text' code readable executable
start:
        clrscr
                                        ;Pobranie a:             
        wyswietl tekst1
        call pob_hex
        mov [a+5],al                    ;Najstarszy bajt zmiennej a
        call pob_hex                    ;przejscie do pobierania liczb
        mov [a+4],al
        call pob_hex
        mov [a+3],al      
        call pob_hex
        mov [a+2],al
        call pob_hex
        mov [a+1],al
        call pob_hex
        mov [a+0],al                     ;Najmlodszy bajt zmiennej a

;Pobranie b:
        wyswietl nowa_linia
        wyswietl tekst2
        call pob_hex
        mov [b+5],al                     ;Najstarszy bajt zmiennej b
        call pob_hex
        mov [b+4],al
        call pob_hex
        mov [b+3],al      
        call pob_hex
        mov [b+2],al
        call pob_hex
        mov [b+1],al
        call pob_hex
        mov [b+0],al                      ;Najmlodszy bajt zmiennej b
 
;Pobranie c:
        wyswietl nowa_linia
        wyswietl tekst3
        call pob_hex
        mov [c+5],al                    ;Najstarszy bajt zmiennej c
        call pob_hex
        mov [c+4],al
        call pob_hex
        mov [c+3],al      
        call pob_hex
        mov [c+2],al
        call pob_hex
        mov [c+1],al
        call pob_hex
        mov [c+0],al                     ;Najmlodszy bajt zmiennej c



czy_zero:                             ;Sprawdzanie czy c = 0, bo dzielimy przez zero
        mov al, [c+0]
        cmp al, 0
        jne reszta
        mov al, [c+1]
        cmp al, 0
        jne reszta
        mov al, [c+2]
        cmp al, 0
        jne reszta
        mov al, [c+3]
        cmp al, 0
        jne reszta
        mov al, [c+4]
        cmp al, 0
        jne reszta
        mov al, [c+5]
        cmp al, 0
        wyswietl tekst5                           ;Jesli 0 to zakoncz program
        wyswietl nowa_linia                 
        jmp zakoncz



reszta:
        mov dx, 0                               ;licznik przesuniec

reszta_1:
        bajt_w_lewo c                           ;przesuniecie w lewo o 1 bit i sprawdzanie CF
        jc reszta_2                             ;jesli CF = 1 to idz do reszta_2
        inc dx                                  ;zwieksz licznik przesuniec
        jmp reszta_1

reszta_2:
        bajt_w_prawo c                          ;przesuniecie w prawo o 1

reszta_3:                                       ;Porownywanie dzielnej z dzielnikiem (b z c)
        mov al, [b+5]
        cmp al, [c+5]
        jb ustaw_carry                          ;jesli dzielna mniejsza od dzielnika przejdz do ustaw_carry: nastepnie przesun o 1 bit w prawo
        ja odejmowanie                          ;jesli wieksza przejdz do odejmowanie:
        mov al, [b+4]
        cmp al, [c+4]
        jb ustaw_carry
        ja odejmowanie
        mov al, [b+3]
        cmp al, [c+3]
        jb ustaw_carry
        ja odejmowanie
        mov al, [b+2]
        cmp al, [c+2]
        jb ustaw_carry
        ja odejmowanie
        mov al, [b+1]
        cmp al, [c+1]
        jb ustaw_carry
        ja odejmowanie
        mov al, [b+0]
        cmp al, [c+0]
        jae odejmowanie
ustaw_carry:
        clc                                     ;ustawienie CF=0
        jmp reszta_4

odejmowanie:
        mov ecx,6                               ;licznik petli loop
        mov esi,0                               ;licznik indeksow
        clc                                     ;ustawienie CF=0

odejmowanie_2:
        mov al,[b+esi]
        mov bl,[c+esi]
        sbb al,bl                               ;odejmowanie arytmetyczne zmiennej b ze zmienna c, z pozyczka
        mov [b+esi],al          
        inc esi                                 ;inkrementowanie zmiennej zmieniajacej indeksy tablic zmiennych b i c
        loop odejmowanie_2
        stc                                     ;ustawienie CF = 1;

reszta_4:        
        cmp dx, 0                       
        je dodawanie                            ;jesli licznik = 0, skacze do dodawanie
        dec dx                                  ;zmniejsz licznik przesuniec
        bajt_w_prawo c                          ;przesuniecie bitowe w prawo z uwzglednieniem CF
        jmp reszta_3


dodawanie:
;Dodawanie wielobajtowych zmiennych (w petli)
        wyswietl nowa_linia
        wyswietl tekst4

        mov ecx,6
        mov esi,0
        clc
powtorz_1:
        push ecx                                ;zabezpieczenie rejestru ecx
        mov al,[a+esi]
        mov dl,[b+esi]
        adc al,dl
        mov [wynik+esi],al                      ;Najmlodszy bajt zmiennej
        inc esi
        pop ecx
        loop powtorz_1
                                                ;Wyswietlenie wynik i zabezpieczenie przed przepelnieniem         
        jc przepelnienie                        
        push wynik
        call wysw_wynik
    jmp koniec

przepelnienie:
        wyswietl blad
        wyswietl nowa_linia

koniec:
    ustaw_kursor 6,1

zakoncz:                                        ;Koniec programu

  call pob_hex
  end_prog



wysw_wynik:
    pop ebp
    pop ebx
    push ebp

    mov ecx,6
    mov esi,5
powtorz_2:
       mov al,[ebx+esi]
       call wysw_hex                            ;si=5 -najstarszy bajt zmiennej
       dec esi
       loop powtorz_2
ret

pobierz_cyfre:
        pob_znak

        cmp al, 8                               ;backspace
        je start
        cmp al, 27                              ;esc
        je zakoncz
        cmp al,'0'
        jb pobierz_cyfre
        cmp al,'9'
        jbe cyfr
        cmp al,'A'
        jb pobierz_cyfre
        cmp al,'F'
        jbe lit_d
        cmp al,'a'
        jb pobierz_cyfre
        cmp al,'f'
        ja pobierz_cyfre
lit_m:       
        push ax
        wysw_znak al                            ;wyswietlenie macro
        pop ax
        sub al,87
        jmp zwrot
lit_d:         
        push ax
        wysw_znak al                            ;wyswietlenie macro
        pop ax
        sub al,55
        jmp zwrot
cyfr:          
        push ax
        wysw_znak al                            ;wyswietlenie macro
        pop ax
        sub al,48 
zwrot:         
        ret                                     ; 4 mlodsze bity rejestru al zawieraja wartosc
                                                ; jednej liczby heksadecymalnej


pob_hex:
        call pobierz_cyfre
        shl al,4
        push ax
        call pobierz_cyfre
        pop dx
        add al,dl
        ret

wysw_hex:
        push ax
        shr al,4
        cmp al,10
        jb zwrot_2
        add al,55                               ; Kody ascii liter
        jmp zwrot_3
zwrot_2:
        add al,48
zwrot_3:                     
        wysw_znak al

        pop ax
        and al,15
        cmp al,10 
        jb zwrot_4   
        add al,55                               ; Kody ascii liter
        jmp zwrot_5
zwrot_4:
        add al,48
zwrot_5:                     
        wysw_znak al
        ret

section '.data' data readable writeable
        a   db 0, 0, 0, 0, 0, 0
        b   db 0, 0, 0, 0, 0, 0
        c   db 0, 0, 0, 0, 0, 0
        wynik   db 0, 0, 0, 0, 0, 0
        nowa_linia db 13,10,NULL
        tekst_wynik   db 'y = a '
        tekst1  db 'a = ',NULL
        tekst2  db 'b = ',NULL
        tekst3  db 'c = ',NULL
        tekst4  db 'y = ',NULL
        tekst5  db 13, 10, '***', NULL
        blad db 13, 10, 'Przekroczono zakres liczb',NULL
