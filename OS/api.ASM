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
 mov ah,0ch  ;�����
 mov bh,0 ;������������
 mov cx,10;x
 mov dx,10 ;y
 mov al,02h ;������� ����
 int 12h ;�������������

Sound:
                mov     dx,12h          ; ���������� ���������� ������� (18 ��)
                cmp     ax,dx           ; ���� AX <= 18 ��,
                jbe     @@done          ; �� �� �����, ����� �������� ������������ ��� �������
                xchg    cx,ax           ; CX = �������
                in      al,61h          ; �������� �������� �� ������������ �������� ����� B ����������� 8255
                or      al,3            ; ������������� ���� 0 � 1 (�������� ������ � ������������ 2-� ����� ��� ��������� ��������� �������)
                out     61h,al          ; ������� �������� � ����������� �������
                mov     al,10110110b    ; ����������� ����� �������: ����� 2; ������� �������� ������� ����, ����� �������; ����� 3 (������������� ��������� ���������); �������� �����
                out     43h,al          ; ������� �������� � ���� �������
                mov     ax,34DDh        ; DX:AX = 1193181 - ������� ������ �������
                div     cx              ; �������� �������� ������� AX = DX:AX / CX
                out     42h,al          ; ������� ������� ���� �������� �� 2-� ����� �������
                mov     al,ah
                out     42h,al          ; ������� ������� ����
@@done:         ret

 
;-- NoSound: ���������� ����� ------------------------------------------------------------------------------------------
; ������ �������� AX
NoSound:
                in      al,61h          ; �������� �������� �� ������������ �������� ����� B ����������� 8255
                and     al,not 3        ; ���������� ���� 0 � 1 (��������� ������ � ������������� 2-�� ������ ������� ��� ��������� ��������� �������)
                out     61h,al          ; ������� �������� � ����������� ������� ����� B ����������� 8255
                ret



CPU_Info:
 user_print_cpu_info:
        ; ��������� �� ������
        mov     esi, cpu_info
        mov     edi,esi
        cld
 
        ; ��������� ���������� � ����������
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

        ;��������� ������
        mov cx, 24        ;cx ���������� ��������� ��������

        mov bp, cpu_info  ;bp ����� ������
        ret

 user_print_title:
        mov cx, 26      ;cx ���������� ��������� ��������

        mov bp, title   ;bp ����� ������
        ret
 title db '<<<Hardware information>>>', 0

 cpu_info db 100, "$"


