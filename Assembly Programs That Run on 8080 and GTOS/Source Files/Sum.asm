.binfile Sum.com


	; OS call list
PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8
LOAD_EXEC	equ 5
PROCESS_EXIT equ 9


	; Position for stack pointer
stack   equ 0F000h

	org 000H
	jmp begin

	; Start of our Operating System
GTU_OS: DI	
	PUSH D
	push D
	push H
	push psw
	nop	; This is where we run our OS in C++, see the CPU8080::isSystemCall()
		; function for the detail.
	pop psw
	pop h
	pop d
	pop D
	EI
	ret
	; ---------------------------------------------------------------
	; YOU SHOULD NOT CHANGE ANYTHING ABOVE THIS LINE        

	;This program adds numbers from 0 to 10. The result is stored at variable
	; sum. The results is also printed on the screen.

sum	ds 2 ; will keep the sum

begin:
	LXI SP,stack 	; always initialize the stack pointer
        mvi c, 10	; init C with 10
	mvi a, 0	; A = 0
loop:
	ADD c		; A = A + C
	DCR c		; --C
	JNZ loop	; goto loop if C!=0
	STA SUM		; SUM = A
	LDA SUM		; A = SUM
			; Now we will call the OS to print the value of sum
	MOV B, A	; B = A
	MVI A, PRINT_B	; store the OS call code to A
	call GTU_OS	; call the OS
	mvi a, PROCESS_EXIT
	call GTU_OS

