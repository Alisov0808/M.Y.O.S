org 7c00h  ;BIOS ?????????? ?????? 512 ???? ??????? ??????? MBR ? ??? ?? ?????? 0x00007C00
         ;(0x07C0:0x0000 ? ??????? ????????? ??????), ????? ???????????? ???? ?????????? ??????????
start:
        cli             ;????????? ??????????
        xor ax,ax       ;???????? ??????? ??
        mov ds,ax       ;??????????? ??????? ?????? ?? ??????? ?????
        mov es,ax       ;??????????? ??????? es ?? ??????? ?????
        mov ss,ax       ;??????????? ??????? ????? ?? ??????? ?????
        mov sp,07C00h   ;??????? sp ????????? ?? ??????? ??????? ?????
        sti         ;????????? ??????????
            
        mov ax, 0002h   ;??????? ????? - ??????? 00h ?????????? 10h 
        int 10h
         
        mov dx,0h
        call SetCursorPos
         
        mov bp, msg             
        mov cx, 13
        call PrintMes   ;????? ?? ????? ?????? msg
         
        add dh,1        ;????????? ?? ???? ?????? ????
        call SetCursorPos
        mov bp, Con             ;????? ?? ????? ?????? Con
        mov cx, 23
        call PrintMes
                 
         mov ah,10h
         int 16h
                 
Continue:
       jmp Kernel
                 
Kernel:

       mov bp, var
        mov cx, 1
        call PrintMes   ;????? ?? ????? ?????? msg
    lea bx,[buffer]
    pusha
    mov [edd_segment], ds 
    mov [edd_offset], bx 
    mov si, edd_packet
    mov ax,1
    mov [edd_nsecs],ax
    mov ah, 042h
    mov dl,0E0h

    int 13h
    mov [var],ah
    ;////

    jnc no_errors


     add dh,1
    mov bp,var
    mov cx,len
    call PrintMes
    jmp $


no_errors:

        jmp 0000:0500h      ;??????? ?? 0000:0500h, ???? ???????? ?????? ??????
 
;===================== ???????????? ===================================

Try_Read:
 var db '',0
 len = $-var
edd_packet:
    edd_len:    dw  16
    edd_nsecs:  dw  0   ;   Number of sectors to transfer
    edd_offset: dw  0
    edd_segment:dw  0
    edd_lba:    dd  1


boot_drive: db  0E0h  ;CD Rom

PrintMes:                   ;? ????????  bp - ??????, ? ???????? cx - ????? ???? ??????
        mov bl,04h          ;? ????????  bl- ???????
        mov ax,1301h        ; ??????? 13h ?????????? 10h
        int 10h
        ret
        ;----------------------------------
SetCursorPos:        ;????????? ??????? : ??????? 02h ?????????? 10h
        mov ah,2h
        xor bh,bh
        int 10h 
        ret
            
 

;===================== ????????? ?????????===================== 
        msg db 'OS Loading...',0     
        Con db 'Press Enter to Continue',0
        Ld db 'Kernel load... Starting',0
        Error db 'Error while loading kernel!!!',0
        ErrorLen = $-Error
times(512-2-($-07C00h)) db 0
db 055h,0AAh ;?????????, ??????????????? ? ?????????? ???????????? ???????
buffer: