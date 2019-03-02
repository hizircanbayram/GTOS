PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8


	; Position for stack pointer
stack   equ 0F000h

	org 000H
	jmp begin

	; Start of our Operating System
GTU_OS:	PUSH D
	push D
	push H
	push psw
	nop	; This is where we run our OS in C++, see the CPU8080::isSystemCall()
		; function for the detail.
	pop psw
	pop h
	pop d
	pop D
	ret
	; ---------------------------------------------------------------
	; YOU SHOULD NOT CHANGE ANYTHING ABOVE THIS LINE   

begin:
	LXI SP,stack 
	mvi a, READ_B
	call GTU_OS
	mov c, b
	mov a, b
main_loop:
	mov b, a ; increment var is assigned to b
	mov a, c ; num is assigned to a so that it can be manipulated(20)
divided_loop:
	cmp b
	jz sublab ; a == b
	jnc sublab ; a > b
	jc exit_divided ; a < b
sublab:
	sub b
	jmp divided_loop
exit_divided:
	cpi 0 
	jnz last
	MVI A, PRINT_B
	call GTU_OS
last:
	mov a, b
	cpi 1 ; if not equal, set zero bit to 1
	jz exit ; if zero bit set to 1, jump
	sui 1
	jmp main_loop
exit:
	hlt
