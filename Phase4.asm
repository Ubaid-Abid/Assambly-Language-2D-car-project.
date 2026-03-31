[org 0x0100]

jmp start
prev_pos:dw 66
enemy_pos:dw 66,104,142,180,218
prev_coin_pos:dw 66
coin_time:dw 0
car_pos:dw 54555
rand_seed: dw 0
fuel_counter:dw 0
light_shade:
   mov ax,0x000A
   jmp flow
normal1:
  mov ax,0x0007
  jmp resume1
normal2:
   mov ax,0x0007
   jmp resume2
normal3:
  mov ax,0x0007
  jmp resume3
normal4:
   mov ax,0x0007
   jmp resume4
print_row:
    cmp bx,0
    jne light_shade
    mov ax,0x0078
flow: push cx
    mov cx,66
    rep stosb
    push ax
   mov cx,36
   mov ax,0x0007
   rep stosb
   mov cx,2
   mov ax,[bp-2]
   cmp ax,15
   jb normal1
   mov ax,0x00ff
resume1:
   rep stosb
   mov ax,0x0007
   mov cx,36
   rep stosb
   mov cx,2
   mov ax,[bp-2]
   cmp ax,15
   jb normal2
   mov ax,0x00ff
 resume2: rep stosb
   mov ax,0x0007
    mov cx,36
    rep stosb
    mov ax,[bp-2]
    cmp ax,15
    jb normal3
    mov ax,0x00ff
resume3: mov cx,2
    rep stosb
    mov cx,36
    mov ax,0x0007
    rep stosb
    mov cx,2
    mov ax,[bp-2]
    cmp ax,15
    jb normal4
    mov ax,0x00ff
 resume4:    
    rep stosb
    mov cx,36
    mov ax,0x0007
    rep stosb
    pop ax
    mov cx,66
    rep stosb
    pop cx
    ret
clrscr:
     mov cx,200
     mov dx,40
     mov ax,0A000h
     mov es,ax
     mov di,0
     mov bx,0
     push bp
     mov bp,sp
     sub sp,2
      mov ax,7
     mov word[bp-2],ax
each_row:
    call print_row
    sub word[bp-2],1
    mov ax,0
    cmp word[bp-2],ax
    je reset
wapis: sub dx,1
     cmp dx,0
     je changeColor
     loop each_row
     add sp,2
     pop bp
     ret
reset:
   mov ax,40
   mov word[bp-2],ax
   jmp wapis
changeColor:
     not bx
     mov dx,40
     loop each_row
     add sp,2
      pop bp
     mov di,255
     mov cx,63
     mov al,0x00
     rep stosb
     mov cx,10
 l2:
    add di,320
    mov byte[es:di],al
    loop l2
    std
    mov cx,63
    rep stosb
    cld
   mov cx,10
l3:
   sub di,320
   mov byte[es:di],al
   loop l3
   mov di,255
   add di,321
   mov al,0x06
   mov cx,9
l4:
   push cx
   mov cx,62
   rep stosb
   sub di,62
   add di,320
   pop cx
   loop l4
   ret
car:
   mov di,[car_pos]
   push di
   mov cx,20
   mov ax,0x000C
car_printing:
   push cx
   push di
   mov cx,11
   rep stosb
   pop di
   pop cx
   add di,320
   loop car_printing
   pop di
   push di
   add di,642
   mov cx,3
windShield:
   push cx
   mov cx,7
   mov ax,0x0000
   rep stosb
   sub di,7
   add di,320
   pop cx
   loop windShield
   sub di,7
   add di,3527
   mov cx,3
back_shield:
    push cx
   mov cx,7
   mov ax,0x0000
   rep stosb
   sub di,7
   add di,320
   pop cx
   loop back_shield
   pop di
   add di,638
   mov ax,0x0000
   mov [es:di],ax
   add di,13
   mov [es:di],ax
   ret
getRandomLane:
    push dx
    push bx
    push cx
    mov ax, [rand_seed]
    mov cx, 25173
    mul cx
    add ax, 13849
    mov [rand_seed], ax
    xor dx, dx
    mov bx, 5
    div bx
    mov bx, dx
    shl bx, 1
    mov di, [enemy_pos + bx]
    pop cx
    pop bx
    pop dx
    ret
enemy_car:
   call getRandomLane
   mov bx,[prev_pos]
   cmp di,bx
   je enemy_car
   mov word[prev_pos],di
    add di,3214
    mov cx,20
    mov ax,0x0001
l7:
     push cx
     push di
     mov cx,11
     rep stosb
     pop di
     pop cx
     add di,320
     loop l7
     sub di,6400
     add di,641
     mov al,0x00
     mov cx,8
     rep stosb
     sub di,8
     add di,320
     mov cx,8
     rep stosb
     add di,5422
     sub di,950
    mov cx,8
     rep stosb
     sub di,328
      mov cx,8
      rep stosb
      sub di,328
      mov cx,8
      rep stosb
      add di,1273
       mov cx,2
      mov al,0x0f
      rep stosb
      add di,2
      mov cx,2
      rep stosb
    ret
enemy:
   call enemy_car
   mov cx,17
   push cx
   jmp continue
shifting:
   push bp
   mov bp,sp
   sub sp,8
   mov si,0
   mov di,63782
   mov cx,4
storing:
   mov ax,[es:di]
   mov [bp-8+si],ax
   add si,2
   add di,38
   loop storing
   mov di,63933
   mov si,di
   sub si,320
   push ds
   mov ax,es
   mov ds,ax
   push di
   mov cx,199
   std
shifting_down:push cx
   mov cx,188
   rep movsb
   pop cx
   pop di
   sub di,320
   mov si,di
   sub si,320
   push di
   loop shifting_down
   pop di
   pop ds
   mov ax,0x0007
   mov di,66
   cld
   mov cx,188
   rep stosb
   mov di,102
   mov si,0
   mov cx,4
restoring:
   mov ax,[bp-8+si]
   mov [es:di],ax
   add di,38
   add si,2
   loop restoring
   add sp,8
   pop bp
   mov di,[car_pos]
   sub di,13
   add di,6400
   mov cx,36
   mov ax,0x0007
   rep stosb
   call car
   ret
get_coin:
   call getRandomLane
   mov bx,[prev_coin_pos]
   cmp di,bx
   je get_coin
   mov word[prev_coin_pos],di
   add di,26570
    mov cx,6
   mov ax,0x0006
   rep stosb
   sub di,6
   mov cx,6
   add di,320
   rep stosb
   sub di,6
   mov cx,5
   add di,320
circular:
   mov byte[es:di],al
   add di,1
   mov byte[es:di],al
   sub di,1
   add di,320
   loop circular
   mov cx,6
   rep stosb
   sub di,6
   add di,320
   mov cx,6
   rep stosb
   mov word[coin_time],17
   jmp continue
reduce_fuel:
   mov word[fuel_counter],0
   mov di,317
   add di,320
   mov al,0x06
   mov cx,62
   std
   repne scasb
   add di,1
   mov cx,9
   mov al,0x78
   cld
l5:
   mov byte[es:di],al
   add di,320
   loop l5
   mov al,0x78
   mov di,255
   add di,321
   mov bl,[es:di]
   cmp al,bl
   je finish
   jmp continue

set_vga_mode_13h:
    mov ax, 0013h
    int 10h
    ret
key_check_io:
    in al, 0x64
    test al, 0x01
    ret
key_read_io:
.wait_key:
    call key_check_io
    jz .wait_key
    in al, 0x60
    mov ah, al
    mov al, 0x00
    ret

start:
    mov ah, 2Ch
    int 21h
    mov [rand_seed], dx
    call set_vga_mode_13h
    call clrscr
    mov cx,0
    push cx
    call car
rotate:
    pop cx
    cmp cx,0
    je enemy
    sub cx,1
    push cx
    mov bx,[coin_time]
    cmp cx,0
    je get_coin
    sub word[coin_time],1
    mov ax,[fuel_counter]
    cmp ax,5
    je reduce_fuel
    add word[fuel_counter],1
continue:
    call shifting
    call shifting
    call shifting
    call key_check_io
    jz rotate
    call key_read_io
    cmp ah, 0x1E
    jne rotate
finish:
    mov ax, 0003h
    int 10h
    mov ax, 4C00h
    int 21h
