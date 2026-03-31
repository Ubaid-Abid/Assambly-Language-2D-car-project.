[org 0x0100]
jmp start
locationsOfOtherCar : dw 0, 0, 0, 0, 0, 0
amountOfOtherCars : dw 0
frequencyOfCars : dw 0
MaxFrequencyOfCars : dw 0
attributeOfOtherCar : dw 0x1020
locationOfMyCar : dw 3274
attributeOfMyCar : dw 0x4020
rand_seed : dw 3
currCoins : dw 0, 0, 0, 0
currFuel : dw 20
clrscr : push es
         pusha
		 mov ax, 0xb800
		 mov es, ax
		 mov di, 0
		 mov ax, 0x0720
		 mov cx, 2000
		 cld
		 rep stosw
		 popa
		 pop es
		 ret
; --- RANDOM LOGIC ---
getRandomLane:
    push dx
    push bx
    push cx
	push ax
    mov ax, [rand_seed]
    mov cx, 25173
    mul cx
    add ax, 13849
    mov [rand_seed], ax
    xor dx, dx
    mov bx, 3
    div bx
    mov bx, dx
	mov ax, bx
	mov bx, 26
	mul bx
	add ax, 48
	mov di, ax
    pop ax
    pop cx
    pop bx
    pop dx
    ret
printMyCar:    pusha      ;ax = attribute   ;
               push es
			   mov bx, 0xb800
			   mov si, di
			   mov es, bx
			   mov cx, 6
			   cld
loopMyCar:	   push cx
	           mov cx, 6
			   rep stosw
			   pop cx
			   sub di, 172
			   cmp di, 0
			   jle printFeaturesOfCar
			   loop loopMyCar
			   cmp ax, 0x06DB
			   je finished
printFeaturesOfCar:
               
               mov di, si
			   and ah, 0xF0
			   or ah, 0x04
			   mov byte [es:di+2], 0xDC       
			   mov byte [es:di+3], ah
			   mov byte [es:di+8], 0xDC       
			   mov byte [es:di+9], ah
			   sub di, 160
			   jle finished
			   mov word [es:di+2], 0x0720
			   mov word [es:di+4], 0x0720
			   mov word [es:di+6], 0x0720
			   mov word [es:di+8], 0x0720
			    sub di, 480
				jle finished
			    mov word [es:di+2], 0x0720
			    mov word [es:di+4], 0x0720
			    mov word [es:di+6], 0x0720
			    mov word [es:di+8], 0x0720
				sub di, 160
				jle finished
			   and ah, 0xF0
			   or ah, 0x0E
			   mov byte [es:di+2], 0xDF       
			   mov byte [es:di+3], ah
			   mov byte [es:di+8], 0xDF     
			   mov byte [es:di+9], ah
finished:      pop es
               popa
			   ret
printGoldNugget:    pusha
                    push es
					mov ax, 0xb800
					mov es, ax
					cmp di, 4000
                    jae endGoldNugget
			   mov cx, 2
			   mov bx, cx
			   mov dx, cx
			   mov al, 0x20
			   mov ah, 0x67
			   cld
lGN:	       cmp di, 0
			   ja endGoldNugget
			   rep stosw
			   mov cx, dx
			   sub di, 164
			   sub bx, 1
			   jnz lGN
endGoldNugget:   pop es
               popa
			   ret
printFuelTank:    pusha
                    push es
					mov ax, 0xb800
					mov es, ax
					cmp di, 4000
                    jae endFuelTank
			   mov cx, 2
			   mov bx, cx
			   mov dx, cx
			   mov al, 0x20
			   mov ah, 0x47
			   cld
lFT:	       cmp di, 0
			   ja endFuelTank
			   rep stosw
			   mov cx, dx
			   sub di, 164
			   sub bx, 1
			   jnz lFT
endFuelTank:   pop es
               popa
			   ret
printingGrass:        pusha
                      push es
					  mov ax, 0xb800
					  mov es, ax
					  mov ax, 0x02DB
                      mov di, 0
					  mov cx, 20
					  mov bx, 3
outer1:				  mov dx, 4
outer2:              
                      push cx
                      rep stosw
					  pop cx
		              add di, 80 ;here
					  push cx
                      rep stosw
					  pop cx
					  sub dx, 1
					  jnz outer2
					  add di, 640
					  sub bx, 1
					  jnz outer1
					  mov ax, 0x0ADB
					  mov di, 640
					  
			          mov bx, 3
outer3:				  mov dx, 4
outer4:              
                      push cx
                      rep stosw
					  pop cx
		              add di, 80 ;here
					  push cx
                      rep stosw
					  pop cx
					  sub dx, 1
					  jnz outer4
					  add di, 640
					  sub bx, 1
					  jnz outer3
					  push cx
					  rep stosw
					  pop cx
					  add di, 104
					  rep stosw
                      pop es
					  popa
					  ret
printingRoad:         pusha
                      push es
		              mov ax, 0xb800
		              mov es, ax
		              mov ax, 0x7020
                      mov di, 42
                      mov si, di
                      mov cx, 24
lpr:                  push cx
                      mov cx, 38
                      rep stosw
                      pop cx
                      add si, 160
                      mov di, si
                      loop lpr
                      pop es
                      popa
                      ret
printingStripes:      pusha
                      push es
                      mov ax, 0xb800
                      mov es, ax
                      mov ax, 0x06DB
                      mov di, 40  
                      mov cx, 12
lPS1:                 stosw
                      add di, 318
                      loop lPS1
                      mov di, 118
                      mov cx, 12
lPS2:                 stosw
                      add di, 318
                      loop lPS2
                      pop es
                      popa
                      ret
					  
printingroadstripes:  pusha
                      push es
					  mov ax, 0xb800
					  mov es, ax
					  mov ax, 0x0FDB
					  mov di, 66
looprs1:			  mov cx, 6
looprs2:		      mov [es:di], ax
					  mov [es:di+26], ax
					  add di, 160    
					  loop looprs2
					  add di, 960 ;skipping the next 5 cols
					  cmp di, 3840
					  jle looprs1
					  pop es 
					  popa
					  ret				 
printLastRow:        push bp
                     mov bp, sp
                     pusha
					 push es
					 mov ax, 0xb800
					 mov es, ax
                     mov di, 3840
					 mov si, di
					 mov cx, 80
					 mov ax, 0x0720
					 rep stosw
					 mov di, si
					 mov si, [bp+4]
                     mov cx, [si]
                     mov byte [es:di], 'F'
					 mov byte [es:di+2], 'U'
					 mov byte [es:di+4], 'E'
					 mov byte [es:di+6], 'L'
					 mov byte [es:di+8], ':'
					 mov word [es:di+50], 0x04DC
					 add di, 10
					 mov ax, 0x07DC
					 rep stosw
					 mov di, 3980				 
					 mov byte [es:di], 'C'
					 mov byte [es:di+2], 'O'
					 mov byte [es:di+4], 'I'
					 mov byte [es:di+6], 'N'
					 mov byte [es:di+8], 'S'
					 mov byte [es:di+10], ':'
					 add di, 12
					 mov si, [bp+6]
					 mov ah, 0x07
					 mov cx, 4
loopyx:				 mov al, [si]
					 add al, '0'
					 add si, 1
					 stosw
					 loop loopyx
					 pop es
					 popa
					 pop bp
					 ret 4
delay:
    push cx
	push dx
    mov cx, 0x2    ; outer loop counter
outer_loop:
    mov dx, 0xFFFF   ; inner loop counter
inner_loop:
    dec dx
    jnz inner_loop     ; repeat until DX = 0
    dec cx
    jnz outer_loop     ; repeat until CX = 0
	pop dx
	pop cx
    ret
scroll:   
		  push ax
		  push cx
		  push di
		  push si
		  push es
		  push ds
		  mov ax, 0xb800
		  mov es, ax
		  mov ds, ax
		  mov di, 3680  ;second last row
		  add di, 66 
		  mov ax, [es:di]
	      
		  add di, 50
		  mov si, di
		  sub si, 160
		  mov cx, 23
		  std
loopScroll:push cx
		  mov cx, 38
		  rep movsw
		  pop cx
		  sub si, 160   ;will make this more efficient in the future
		  sub di, 160
		  add si, 76
		  add di, 76
		  loop loopScroll
		  sub di, 50
		  mov word [es:di], ax
		  mov word [es:di+26], ax
		  cld
		  pop ds
		  pop es
		  pop si
		  pop di
		  pop cx
		  pop ax
		  ret
myCarCleaner:  push di
               push cx
			   push ax
			   push es
			   mov ax, 0xb800
			   mov es, ax
			   add di, 160
			   mov cx, 7
			   mov ax, 0x7020
			   rep stosw
			   pop es
			   pop ax
			   pop cx
			   pop di
			   ret
start:    mov ah, 2Ch
          int 21h
          mov [rand_seed], dx
	      call clrscr
          call printingRoad
          call printingGrass
          call printingStripes
		  call printingroadstripes
gameloop:           
                     ; here will be the logic for car movement
					 call scroll
					 mov di, [locationOfMyCar]
					 call myCarCleaner
					 mov ax, [attributeOfOtherCar]
					 mov di, [locationsOfOtherCar]
					 call getRandomLane
					 call printMyCar
					 add word [locationsOfOtherCar], 160
					 mov ax, [attributeOfMyCar]
					 mov di, [locationOfMyCar]
					 
					 call printMyCar
					 
					 call delay
					 call delay
					 jmp gameloop
					 ; call printLastRow ; takes attributes
mov ax, 0x4c00
int 0x21  
