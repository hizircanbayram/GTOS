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
    LXI B, 0xC350    ; cur mem value
    MVI A, 0
    ;STAX B   ;KOD DRIVER ASAMASINDA BURA KAPALI KALACAK, SONRA ACILACAK; initialize cur mem with 0 by assigning to the address 0xC350 
    jmp proc_start 


; HER PROCESSIN STATE VE PID'LERINI ATAMAYI UNUTMA!!!
proc_start:
    LXI B, 0xC350    ; take the address of cur mem
    LDAX B          ; now register A has the cur mem
    MOV C, A    ; cur mem is in C so that it can be upper bound for subroutine mult
    MVI B, 0	; register B is assigned with 0 so that the counter variable of mult subroutine can be started from 0.
    JMP mult_start  ; loop, starting from 0 to cur mem
    mult_return:    ; H & L have the address of which process table entry is updated
    INR L
    INR L       ; H & L points now where the registers will be stored
    LXI D, 0x0100    ; D & E points now where the registers are stored
    JMP to_process_start
    process_return:
    HLT     ;   BURA DEGISECEK!!!!!!!!!!!!



to_process_start:
    MVI B, 0    ; counter variable
    MVI C, 14   ; # of registers that we have
to_process:
    MOV A, C
    CMP B
    JZ to_process_end   ; if counter variable is higher than or equal to 14, then jump
    LDAX D      ; belki B registeri kullanmam gerekebilirdi
    PUSH D      ; address of 256d is pushed so that it can't be lose while assigning process table address for storing below
    MOV D, H
    MOV E, L
    STAX D      ; store 256+i to suitable process table entry
    POP D
    INR E
    INR L   
    INR B
    JMP to_process
to_process_end:
    LXI B, 0xC350   ; take the address of cur mem
    LDAX B          ; now register A has the cur mem
    PUSH B          ; push address of 0xC350 so that it can be used for the instruction STAX below
    MVI C, NUM
    DCR C           ; C now has (# of processes) - 1  
    PUSH psw        ; register A has the cur mem. Since it'll be used for zero bit below, it needs to be stored somehow.(1)
    SUB C           ; A - C so that the zero bit can be set
    JZ cur_mem_to_zero  ; if cur mem == (# of proc - 1) then jump
    POP psw         ; Now we're done with the zero bit, we can take cur mem back so that we can update and store it again in 0xC350 
    INR A   ; if cur mem != (# of proc - 1), increment it by 1
    POP B   ; B & C now have the address of 0xC350
    STAX B  ; update cur mem with the new value(B & C have the address from above)
    JMP cur_mem_to_one
cur_mem_to_zero:
    POP psw
    MVI A, 0
    POP B       ; B & C now have the address of 0xC350
    STAX B      ; update cur mem with 0(B & C have the address from above)
cur_mem_to_one:
    JMP process_return



; B register : counter variable, needs to be loaded before calling this subroutine.
; A register : upper bound, needs to be loaded before calling this subroutine.
; H & L register pair keeps the starting address
; D & E register pair keeps factor
; Result is in H & L register pair
mult_start:
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
