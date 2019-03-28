.binfile mult.com
PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8

NUM		equ 3
RUN     equ 0
READY   equ 1

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
    ; driver
    MVI A, 2
    LXI B, 2710H
    call GTU_OS
    LXI B, 2910H
    call GTU_OS
    LXI B, 2B10H
    call GTU_OS
    ; driver
    jmp proc_start 


; SU AN TERMINATE ETMIYOR GIBI BU DONGU, UNUTMA!!!
; HER PROCESSIN STATE VE PID'LERINI ATAMAYI UNUTMA!!!
proc_start:
    MVI C, 0    ; counter variable of this subroutine.
    MVI B, 0    ; counter variable of mult subroutine.
proc_loop:
    MVI A, NUM  ; # of processes
    PUSH B      ; push those two counter variables so that they can't be lose
    JMP mult_start
    mult_return:    
    MOV B, H    ; B & C have state of any process
    MOV C, L
    LDAX B      
    MVI B, READY    ; B is free to compare, since the address is already taken
    CMP B
    JZ proc_loop_end    ; if state(register A) != RUN, then jump 
    ; if state == RUN
    ; driver
    LXI B, 5050H
    MVI A, READ_STR
    call GTU_OS 
    ; driver
    ; some code...
    ; ...
proc_loop_end:
    POP B           
    INR C       
    JMP proc_loop
proc_exit:

; B register : counter variable, needs to be loaded before calling this subroutine.
; A register : upper bound, needs to be loaded before calling this subroutine.
; H & L register pair keeps the starting address
; D & E register pair keeps factor
; Result is in H & L register pair
mult_start:
;    MOV B, C    ; proc loop's counter variable is assigned to B so that this loop can be repeated as it is supposed to be.
    MOV A, C
    MVI D, 02H  ; MSB 8 bits of factor
    MVI E, 00H  ; LSB 8 bits of factor
    MVI H, 27H  ; MSB 8 bits of starting address
    MVI L, 10H  ; LSB 8 bits of starting address
mult_loop:
    CMP B
    JZ mult_exit ; a == b
    DAD D   ; adds 16-bit value specified register pair to contents of H and L register pair.
    INR B
    JMP mult_loop
mult_exit:
    MVI B, 0
    JMP mult_return
