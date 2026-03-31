[org 0x0100]
jmp start
lanes:dw 26,37,49
print_stripes:
   mov cx,24
   mov di,68
   mov ax,0x8020
   mov [es:di],ax
   mov [es:di+22],ax ;this is for right lane
   add di,160
   mov ax,0xFF20
left_printing:
   push cx
   mov cx,3 
looping:
   mov [es:di],ax
   mov [es:di+22],ax
   add di,160
   loop looping
   mov ax,0x8020
   pop cx
   sub cx,3
   cmp cx,0
   je finish
   mov [es:di],ax
   mov [es:di+22],ax
   add di,160
   sub cx,1
   cmp cx,0
   je finish
   mov [es:di],ax
   mov [es:di+22],ax
   add di,160
   
   sub cx,1
   mov ax,0xFF20
   cmp cx,0
   jne left_printing ; left_printing
finish
   ret


clrscr:
  mov ax,0xb800
  mov es,ax
  mov di,0
  mov cx,25
  
outerloop:
  push cx
  
  ;first left border from col 0 to 17
  mov cx,18
  mov ax,0x0720
  rep stosw
  ;now left green grass from col 18 to 23
  mov cx,6
  mov ax,0x2820
  rep stosw
  ;now road printing
  ;first left lane from col 24 to 33
  mov cx,10
  mov ax,0x8020          ; <-- changed to dark gray (light-black) background
  rep stosw
  ;now leaving one column(34) for strips printing
  mov ax,0x0720
  mov [es:di],ax
  add di,2
  ;now printing second lane from 35 to 44
  mov cx,10
  mov ax,0x8020          ; <-- changed to dark gray (light-black) background
  rep stosw
  ;now again one column (45)for strips
  mov ax,0x0720
  mov [es:di],ax
  add di,2
  ;now third lane from 46 to 55
  mov cx,10
  mov ax,0x8020          ; <-- changed to dark gray (light-black) background
  rep stosw
  ;now printing right green grass from 56 to 61
  mov cx,6
  mov ax,0x2820
  rep stosw
  ;now right black screen
  mov cx,18
  mov ax,0x0720
  rep stosw
  ;now going for next row
  pop cx
  loop outerloop
  
  ret
choco_car_printing:  ;height of car is 6 rows and width is 6 cols
   
    push bp
    mov bp,sp
    mov di,[bp+4] ;now this contains top left corner of our main car
    mov ax,0xb800
    mov es,ax
    cmp dx,0
    je ours
    jmp enemies
ours:
    mov ax,0x4420
    jmp formation
enemies:
     mov ax,0x1120
formation:
    mov cx,6
    rep stosw
    mov di,[bp+4];now for row 2
    push ax
    add di,160
    mov [es:di],ax
    add di,2
    mov ax,0x0720
    mov cx,4
    rep stosw
    pop ax
    mov [es:di],ax
    mov di,[bp+4]
    add di,320 ;row 3
    mov cx,6
    rep stosw
    mov di,[bp+4] ;row 4
    add di,480
    mov cx,6
    rep stosw
    ;ignoring row 5
    push ax
    mov di,[bp+4]
    add di,640
    mov [es:di],ax
    add di,2
    mov ax,0x0720
    mov cx,4
    rep stosw
 
    pop ax
    mov [es:di],ax
    mov di,[bp+4]
    add di,800
    mov cx,6
    rep stosw
    ;now putting headlights 
    cmp dx,0
    je our_car
    jmp enemy_car
our_car:
    mov di,[bp+4]
    add di,2
    mov al,'*'
    mov ah,0x4F
    mov [es:di],ax
    add di,6
    mov [es:di],ax
    pop bp
    ret 2
enemy_car:
    mov di,[bp+4]
    add di,802
    mov al,'*'
    mov ah,0x1F
    mov [es:di],ax
    add di,6
    mov [es:di],ax
    pop bp
    ret 2

delay:
     push cx
     mov cx,64
outrloop:
       push cx
       mov cx,55000
  innerloop:
       loop innerloop
      pop cx
      loop outrloop
     pop cx
     ret
get_random_0_to_2:
       push dx

    mov ax, 0x40
    mov es, ax
    mov dx, [es:0x6C]     ; read BIOS tick count (changes continuously)
    and dx, 0x0003        ; get low 2 bits (0–3)
    cmp dx, 3             ; if 3, wrap to 2
    jne ok
    mov dx, 2
ok:
    mov ax, dx            ; result in AX (0, 1, or 2)

    pop dx
       ret


oponent_printing:
        call get_random_0_to_2
        shl ax,1
        mov si,ax
        mov bx,[lanes+si]
       
        mov di,160
        shl bx,1
        add di,bx
        push di
        mov dx,1
        call choco_car_printing
        call delay 
         ret




start:
   ; enable 16 background colors (disable blinking)  <-- added
   mov ax,0x1003         ; BIOS: set blink/background intensity
   mov bl,0              ; 0 = disable blink, enable bright backgrounds
   int 0x10              ; <-- added
   
infinity:
   call clrscr
   call print_stripes
   mov ax,2932   ;here row number is 18 and option is either 26*2 for left lane ,36*2 for middle lane and 
   push ax
   mov dx,0
   call choco_car_printing
   call oponent_printing
   jmp infinity
   mov ax,0x4c00
   int 0x21
