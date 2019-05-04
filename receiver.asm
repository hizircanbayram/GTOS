.binfile receiver.com
	; OS call list
PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8
LOAD_EXEC   equ 5
PROCESS_EXIT equ 9
RAND_INT equ 12
WAIT equ 13
SIGNAL equ 14
N equ 50


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
	; ---------------------------------------------------------------



prompt:	dw 'Receiver',00H 	; prompt message if the given parameter is odd number

; mutex, full, empty

; main sub routine.
begin:
    LXI B, prompt
    MVI A, PRINT_STR
    CALL GTU_OS

    MVI D, 0
    MVI E, N
loop:
    MOV A, E
    CMP D
    JZ exit

    ; down full
    MVI C, 1
    MVI A, WAIT
    CALL GTU_OS
    ; down mutex
    MVI C, 0
    MVI A, WAIT
    CALL GTU_OS
    ; remove item
    LXI B, 0xD6D8
    LDAX B
    MOV B, A
    MVI A, PRINT_B
    CALL GTU_OS
    ; up mutex
    MVI C, 0
    MVI A, SIGNAL   
    CALL GTU_OS
    ; up empty
    MVI C, 2
    MVI A, SIGNAL
    CALL GTU_OS
    ; consume item

    ; Something happening...

    INR D
    JMP loop
exit:
    MVI A, PROCESS_EXIT
    call GTU_OS
