.binfile ShowPrimes.com
PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8
LOAD_EXEC	equ 5
PROCESS_EXIT equ 9


NUM		equ 255


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


prime_prompt:	dw 'prime',00AH,00H 
not_prime_prompt: dw '',00AH,00H





begin:
	LXI SP, 0x2B0F
	mvi d, NUM
main_loop:
	mov b, d
	mvi a, PRINT_B
	call GTU_OS
	jmp prime_begin
	back_main:
	mov a, d
	sui 1
	mov d, a
	cpi 1 				; number decreased down to 2. zero bit is set. the program needs to be terminated
	jnz main_loop
	mvi a, PROCESS_EXIT
	call GTU_OS





prime_begin:
	mov c, d			; number that is checked if it is prime is here
	mov a, c			; number is assigned to the accumulator so that if it is 2, it can simply be returned that it is a prime number
	cpi 2				
	jz write_prime		; a == b | if the number is 2, it's a prime number
	jc write_not_prime  ; a < b  | if the number is less than 2, it's not a prime number at all
	mov a, d			; increment var is here
	sui 1				; num - 1
prime_loop:
	mov b, a 			; increment var is assigned to b
	mov a, c    		; num is assigned to accumulator so that it can be manipulated(20)
divided_loop:
	cmp b
	jz sublab 			; a == b
	jnc sublab 			; a > b
	jc exit_divided 	; a < b
sublab:
	sub b
	jmp divided_loop
exit_divided:
	cpi 0 				; compare accumulator
	jnz last 			; if a isn't equal to 0, meaning not divided perfectly, zero bit is 0. means jump
	jmp write_not_prime	; if it is here, means divided exactly. not prime so
last:					; a round is over. now if the loop is going to be executed is decided
	mov a, b
	cpi 2 				; if not equal, set zero bit
	jz write_prime 		; if zero bit is equal to 1, jump
	sui 1
	jmp prime_loop
write_prime:
	mvi a, PRINT_STR
	lxi b, prime_prompt
	call GTU_OS
	jmp back_main
write_not_prime:
	mvi a, PRINT_STR
	lxi b, not_prime_prompt
	call GTU_OS
	jmp back_main	



