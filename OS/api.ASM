;apis
Color_White:
  mov bl, 0fh
  int 10h

Color_Red:
  mov bl, 04h
  int 10h

Color_Green:
  mov bl, 02h
  int 10h

Color_Yellow:
  mov bl, 03h
  int 10h

Color_Blue:
  mov bl, 01h
  int 10h

SetCurPoz:
   mov ah,2h
   xor bh,bh
   int 10h

Print:
  mov ax, 1301h
  int 10h; ?????????? ??? ??????

Clean:
  mov ax, 3
  int 10h

GUI_Mode:
 mov ah,0ch  ;точка
 mov bh,0 ;видеостаница
 mov cx,10;x
 mov dx,10 ;y
 mov al,02h ;зеленый цвет
 int 12h ;инициализаци€

Sound:
                mov     dx,12h          ; минимально допустима€ частота (18 √ц)
                cmp     ax,dx           ; если AX <= 18 √ц,
                jbe     @@done          ; то на выход, чтобы избежать переполнени€ при делении
                xchg    cx,ax           ; CX = частота
                in      al,61h          ; получаем значение из управл€ющего регистра порта B контроллера 8255
                or      al,3            ; устанавливаем биты 0 и 1 (включить спикер и использовать 2-й канал дл€ генерации импульсов спикера)
                out     61h,al          ; выводим значение в управл€ющий регистр
                mov     al,10110110b    ; управл€ющее слово таймера: канал 2; сначала записать младший байт, затем старший; режим 3 (пр€моугольный генератор импульсов); двоичное слово
                out     43h,al          ; выводим значение в порт таймера
                mov     ax,34DDh        ; DX:AX = 1193181 - частота работы таймера
                div     cx              ; значение счЄтчика таймера AX = DX:AX / CX
                out     42h,al          ; выводим младший байт счетчика во 2-й канал таймера
                mov     al,ah
                out     42h,al          ; выводим старший байт
@@done:         ret

 
;-- NoSound: отключение звука ------------------------------------------------------------------------------------------
; ћен€ет значение AX
NoSound:
                in      al,61h          ; получаем значение из управл€ющего регистра порта B контроллера 8255
                and     al,not 3        ; сбрасываем биты 0 и 1 (отключить спикер и использование 2-го канала таймера дл€ генерации импульсов спикера)
                out     61h,al          ; выводим значение в управл€ющий регистр порта B контроллера 8255
                ret



CPU_Info:
 user_print_cpu_info:
        ; указатель на строку
        mov     esi, cpu_info
        mov     edi,esi
        cld
 
        ; прочитать информацию о процессоре
        mov     eax, 80000002h
        push    eax
        stosd
        xchg    eax,ebx
        stosd
        xchg    eax,ecx
        stosd
        xchg    eax,edx
        stosd
        pop     eax
        inc     eax
        cmp     eax,80000004h

        ;настройка печати
        mov cx, 24        ;cx количество выводимых символов

        mov bp, cpu_info  ;bp вывод строки
        ret

 user_print_title:
        mov cx, 26      ;cx количество выводимых символов

        mov bp, title   ;bp вывод строки
        ret
 title db '<<<Hardware information>>>', 0

 cpu_info db 100, "$"


