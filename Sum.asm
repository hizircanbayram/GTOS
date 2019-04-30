        ; 8080 assembler code
        .hexfile sum.hex
        .binfile Sum.com
        ; try "hex" for downloading in hex format
        .download bin  
        .objcopy gobjcopy
        .postbuild echo "OK!"
        ;.nodump

	; OS call list
PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8
LOAD_EXEC	equ 5
PROCESS_EXIT equ 9
RAND_INT equ 12


prompt:	dw 'welcome random generator',00H 	; prompt message if the given parameter is odd number


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
    lxi b, prompt
    mvi a, PRINT_STR
    call GTU_OS
    mvi a, RAND_INT
    call GTU_OS
    mvi a, PRINT_B
    call GTU_OS
    lxi b, prompt
    mvi a, PRINT_STR
    call GTU_OS
	mvi a, PROCESS_EXIT
	call GTU_OS

