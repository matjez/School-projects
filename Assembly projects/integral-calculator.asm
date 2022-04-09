format PE Console 4.0
entry start
include 'win32ax.inc'
include 'win_macros.inc'


section '.text' code readable executable
;Grupa f

start:
  cinvoke printf, <"Podaj a w zakresie od -9.99 do 9.99: ">
  cinvoke scanf, <"%lf">, a
  cinvoke printf, <"Podaj b w zakresie od -9.99 do 9.99: ">
  cinvoke scanf, <"%lf">, b
  cinvoke printf, <"Podaj n w zakresie od 1 do 999: ">
  cinvoke scanf, <"%lf">, n

licz_dx:
        finit                           ; inicjalizacja FPU
        fld [b]                         ; wrzucenie pobranej zmiennej b do st(0)
        fsub [a]                        ; odejmowanie liczby z góry stosu od podanej zmiennej - (b-a)
        fdiv [n]                        ; dzielenie liczby z góry storu(st(0)) przez n - ((b-a)/n)
        fstp [odl]                      ; zapisywanie st(0) w zmiennej [odl]

pobierz_x0:
        finit                           ; inicjalizacja FPU
        fld [b]                         ; zaladuj liczbe rzeczywista ze zmiennej b
        fsub [a]                        ; odejmowanie liczby z gory stosu b-a
        fld [licznik]                   ; zaladuj liczbe rzeczywista ze zmiennej licznik     
        fdiv [n]                        ; dzielenie liczby z góry stosu przez n (b-a)/n
        fmul st0, st1                   ; mnozenie liczb st0 i st1
        fadd [a]                        ; dodawanie liczby z gory stosu a+b

        fstp [xa]                       ; zapisywanie st(0) w zmiennej [xa]

;Zwiekszenie licznika;
        finit
        fld1                            ; st(0) = 1 
        fld [licznik]                   ; wrzucanie zmiennej licznik do st(0) przez co st(1) = 1.0
        fadd st0, st1                   ; dodawanie 
        fstp [licznik]                  ; wrzucanie wyniku dodawania z st(0) do zmiennej licznik

        jmp pobierz_x1

pobierz_x0_1:                           ; pobieranie wartoœci x(i)

        finit                           ; inicjalizacja FPU
        fld [xb]                        
        fstp [xa]                       

pobierz_x1:                             ; pobieranie wartoœci x(i+1)
        finit
        fld [b]
        fsub [a]                        ; odejmowanie st(0) od [a]
        fld [licznik]                   ; st(0) = [licznik]
        fdiv [n]                        ; dzielenie st(0) przez n
        fmul st0, st1                   ; mnozenie st(1) i st(0)
        fadd [a]                        ; [a] + st(0)

        fstp [xb]                       ; [xb] = st(0)


 ;Zwiekszenie licznika;
        finit
        fld1                            ; za³aduj 1, st(0) = 1.0
        fld [licznik]                   ; st(0) = [licznik]
        fadd st0, st1                   ; dodaj st0 do st1
        fstp [licznik]                  ; zapisywanie st(0) w zmiennej [licznik]

podstawa:
        finit
        fld [xa]                        ; st(0) = [xa]

        fmul [xa]                       
        fmul [xa]                       ; st(0) = xa * xa *xa 

        fld1
        fld1
        faddp                           ; dodawanie st(0) i st(1)  = 2, gdzie st(2) = x^3, po wykonaniu st(1) = st()

        fmulp                           ; mnozenie st(0) i st(1)                           

        fld1                            ; st(0) = 1
        fsubp                           ; st(0) = st(1) - st(0)

        fstp [f1]

podstawa_1:
        finit
        fld [xb]

        fmul [xb]
        fmul [xb]

        fld1
        fld1
        faddp

        fmulp

        fld1
        fsubp

        fstp [f2]

obliczanie_wyniku:
        finit
        fld1
        fld1
        faddp                           ; dodawanie st(0) i st(1)  = 2,
        fld [f1]                        ; st(0) = [f1], st(1) = 2
        fadd [f2]                       ; st(0) = [f2] + st(0), st()
        fdiv st0, st1

        fmul [odl]                      ; st(0) * [odl]

        fadd [wynik]                    ; [wynik] + st(0)

        fstp [wynik]                    ; zapisywanie st(0) w zmiennej [wynik]

sprawdz: ;sprawdza licznik z n (liczbÄ… przedziaÅ‚Ã³w);
        finit
        fld [n]                         ; st(0) = [n]
        fld [licznik]                   ; st(0) = [licznik]
        fcomi st0, st1                  ; porównaj st0 z st1 i ustaw flagi procesora
        jae koniec                      ; skok do koniec gdy powyzej lub rowno
        jmp pobierz_x0_1                ; skok do pobierz_x0_1

koniec:
  cinvoke printf, <"a = %.3lf">,dword[a], dword[a+4]
  wyswietl endl
  cinvoke printf, <"b = %.3lf">,dword[b], dword[b+4]
  wyswietl endl
  cinvoke printf, <"n = %.0lf">,dword[n], dword[n+4]
   wyswietl endl
  cinvoke printf, <"wynik = %.3lf">,dword[wynik], dword[wynik+4]
  wyswietl endl

        invoke getch
        invoke ExitProcess


  section '.data' data readable writeable

    a dq 0
    b dq 0
    n dq 0
    odl dq 0
    wynik dq 0
    xa dq 0
    xb dq 0
    licznik dq 0
    f1 dq 0
    f2 dq 0
    endl db 13,10

