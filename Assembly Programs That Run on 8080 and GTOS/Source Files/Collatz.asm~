.binfile Collatz.com
	; OS call list
PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8
LOAD_EXEC   equ 5
PROCESS_EXIT equ 9


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



odd_prompt:	dw 'Odd number is given as parameter, process is terminating',00H 	; prompt message if the given parameter is odd number



; main sub routine.
begin:
    MVI A, READ_B
    CALL GTU_OS     ; The number whose Collatz sequence is taken is in register B
    MVI H, 1
    MVI L, 0
    MOV A, B        ; The number is in register A
collatz_sequence:
    CMP H
    JZ collatz_exit              ; The number equals 1, meaning it needs to be terminated now
    MOV B, A        ; The number is in register B now so that it can be printed
    MVI A, PRINT_B
    CALL GTU_OS     ; Show n
    PUSH B          ; push B so that it can't lose its value
    MOV A, B
    CALL is_even_loop   ; register A is set to either 0 or 1
    CMP L           ; compare it with 0
    JZ even_number  ; if it is set to 1, it means register A is 0, meaning that is an even number
odd_number:
    POP B           ; the number is in B again
    MOV A, B       
    MVI B, 3
    CALL multiply_by_n_start
    INR A           ; 3 * number + 1
    JMP collatz_sequence
even_number:
    POP B           ; the number is in B again
    MOV A, B        
    CALL division_two_start
    JMP collatz_sequence
collatz_exit:
    MVI A, PROCESS_EXIT
	CALL GTU_OS




; Register A needs to be loaded with the number that is checked if it is even
; Register B contains the control bit. Store its value before calling this subroutine if necessary
; Result is in register A. If the number is even, A register is loaded with 0, 1 otherwise.
; CAUTION : Store the value in register A before calling this subroutine
is_even_loop:
    MVI B, 0
    CMP B
    JZ exit_loop      ; number became equal to 0, meaning that the number is even
    MVI B, 1
    CMP B
    JZ exit_loop      ; number became equal to 1, meaning that the number is not even
    DCR A
    DCR A
    JMP is_even_loop
exit_loop
    RET
    


; Register A needs to be loaded with the number that multiplies 
; Register B needs to be loaded with the number that is multiplied 
; Register C keeps the counter variable. If register B has a value before calling this subroutine, it needs to be stored somehow
; Register D is used for intermediate values. It needs to be stored somehow before calling this subroutine
; Result is in register A finally. So, the number that is passed as parameter to this subroutine needs to be stored somehow before calling this subroutine
multiply_by_n_start:
    MVI C, 0    ; the loop is started from 1 because we want it to loop (number that multiplies - 1). This is because accumulator is already has one value. 
    MVI D, 0
multiply_by_n:
    CMP C
    JZ exit_multiply_by_n
    PUSH psw    ; multiplier is pushed so that the manipulation below can't lost its value
    MOV A, D
    ADD B
    MOV D, A	; take the intermediate value to register A so that it can be keep manupulating	
    INR C
    POP psw
    JMP multiply_by_n
exit_multiply_by_n
	MOV A, D
    RET




; Register A needs to be loaded with the number that is divided by 2
; Register B keeps the counter variable. If register B has a value before calling this subroutine, it needs to be stored somehow
; CONDITION : The number given as parameter to this subroutine needs to be even number
; Half of register A is in register A again finally. Thus, the number that is passed as parameter to this subroutine needs to be stored somehow before calling this subroutine
division_two_start:
    MVI B, 0
division_two_loop:
    CMP B
    JZ exit_division_loop             ; if counter variable and the number is equal, it means half of the number is found
    JC odd_number_exception           ; if counter variable is higher or equal to the number, it means odd number is given as parameter
    INR B
    DCR A
    JMP division_two_loop
exit_division_loop:
    RET 
odd_number_exception:
    MVI A, PRINT_STR
    LXI B, odd_prompt
    CALL GTU_OS
    HLT 
