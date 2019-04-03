.binfile micro_kernel.com

PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8
LOAD_EXEC	equ 5
PROCESS_EXIT    equ 9


NUM equ 6
RUN equ 1
DONE equ 0

	; Position for stack pointer
stack   equ 0F000h

	org 0000H
	jmp begin

	; Start of our Operating System
	
GTU_OS:	DI
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

  

	org 0028H
	jmp interruptHandler

	
	org 03E8H


proc1: dw  'Collatz.com',00H		
proc2: dw  'Collatz.com',00H		
proc3: dw  'Collatz.com',00H		
proc4: dw  'Sum.com',00H		
proc5: dw  'Sum.com',00H		
proc6: dw  'Sum.com',00H
proc7: dw  'ShowPrimes.com',00H		
proc8: dw  'ShowPrimes.com',00H		
proc9: dw  'ShowPrimes.com',00H
proc10: dw 'ShowPrimes.com',00H

begin:	
	DI
	LXI SP,stack
    ; INITIALIZE CUR MEM 
    LXI B, 0xC350
    MVI A, 0
    STAX B
    ; STACK POINTER, BASE REGISTER, PROGRAM COUNTER INTITIALIZATION
        ; PROCESS I
    LXI B, 0x2710
    MVI A, 1
    STAX B
    LXI B, 0x2719
    MVI A, 0xF
    STAX B
    LXI B, 0x271A
    MVI A, 0x29
    STAX B
    LXI B, 0x271B
    MVI A, 0
    STAX B
    LXI B, 0x271C
    MVI A, 0
    STAX B
    LXI B, 0x271D
    MVI A, 0x20
    STAX B
    LXI B, 0x271E
    MVI A, 0x4E
    STAX B
        ; PROCESS II
    LXI B, 0x2910
    MVI A, 1
    STAX B
    LXI B, 0x2919
    MVI A, 0xF
    STAX B
    LXI B, 0x291A
    MVI A, 0x2B
    STAX B
    LXI B, 0x291B
    MVI A, 0
    STAX B
    LXI B, 0x291C
    MVI A, 0
    STAX B
    LXI B, 0x291D
    MVI A, 0xE4
    STAX B
    LXI B, 0x291E
    MVI A, 0x57
    STAX B
        ; PROCESS III
    LXI B, 0x2B10
    MVI A, 1
    STAX B
    LXI B, 0x2B19
    MVI A, 0xF
    STAX B
    LXI B, 0x2B1A
    MVI A, 0x2D
    STAX B
    LXI B, 0x2B1B
    MVI A, 0
    STAX B
    LXI B, 0x2B1C
    MVI A, 0
    STAX B
    LXI B, 0x2B1D
    MVI A, 0xA8
    STAX B
    LXI B, 0x2B1E
    MVI A, 0x61
    STAX B
        ; PROCESS IV
    LXI B, 0x2D10
    MVI A, 1
    STAX B
    LXI B, 0x2D19
    MVI A, 0xF
    STAX B
    LXI B, 0x2D1A
    MVI A, 0x2F
    STAX B
    LXI B, 0x2D1B
    MVI A, 0
    STAX B
    LXI B, 0x2D1C
    MVI A, 0
    STAX B
    LXI B, 0x2D1D
    MVI A, 0x6C
    STAX B
    LXI B, 0x2D1E
    MVI A, 0x6B
    STAX B
        ; PROCESS V
    LXI B, 0x2F10
    MVI A, 1
    STAX B
    LXI B, 0x2F19
    MVI A, 0xF
    STAX B
    LXI B, 0x2F1A
    MVI A, 0x31
    STAX B
    LXI B, 0x2F1B
    MVI A, 0
    STAX B
    LXI B, 0x2F1C
    MVI A, 0
    STAX B
    LXI B, 0x2F1D
    MVI A, 0x30
    STAX B
    LXI B, 0x2F1E
    MVI A, 0x75
    STAX B
        ; PROCESS VI
    LXI B, 0x3110
    MVI A, 1
    STAX B
    LXI B, 0x3119
    MVI A, 0xF
    STAX B
    LXI B, 0x311A
    MVI A, 0x33
    STAX B
    LXI B, 0x311B
    MVI A, 0
    STAX B
    LXI B, 0x311C
    MVI A, 0
    STAX B
    LXI B, 0x311D
    MVI A, 0xF4
    STAX B
    LXI B, 0x311E
    MVI A, 0x7E
    STAX B
        ; PROCESS VII
    LXI B, 0x3310
    MVI A, 1
    STAX B
    LXI B, 0x3319
    MVI A, 0xF
    STAX B
    LXI B, 0x331A
    MVI A, 0x35
    STAX B
    LXI B, 0x331B
    MVI A, 0
    STAX B
    LXI B, 0x331C
    MVI A, 0
    STAX B
    LXI B, 0x331D
    MVI A, 0xB8
    STAX B
    LXI B, 0x331E
    MVI A, 0x88
    STAX B
        ; PROCESS VIII
    LXI B, 0x3510
    MVI A, 1
    STAX B
    LXI B, 0x3519
    MVI A, 0xF
    STAX B
    LXI B, 0x351A
    MVI A, 0x37
    STAX B
    LXI B, 0x351B
    MVI A, 0
    STAX B
    LXI B, 0x351C
    MVI A, 0
    STAX B
    LXI B, 0x351D
    MVI A, 0x7C
    STAX B
    LXI B, 0x351E
    MVI A, 0x92
    STAX B
        ; PROCESS IX
    LXI B, 0x3710
    MVI A, 1
    STAX B
    LXI B, 0x3719
    MVI A, 0xF
    STAX B
    LXI B, 0x371A
    MVI A, 0x39
    STAX B
    LXI B, 0x371B
    MVI A, 0
    STAX B
    LXI B, 0x371C
    MVI A, 0
    STAX B
    LXI B, 0x371D
    MVI A, 0x40
    STAX B
    LXI B, 0x371E
    MVI A, 0x9C
    STAX B
    ; PROCESS I
	LXI B, 03E8H	; starting address of where the file name is stored : 1010. address
	LXI H, 4E20H	; starting address of where the file is stored : 20000.address
	MVI A, LOAD_EXEC
	call GTU_OS
    ; PROCESS II
	LXI B, 03F5H	; starting address of where the file name is stored : 1015.address
	LXI H, 57E4H	; starting address of where the file is stored : 25000.address
	MVI A, LOAD_EXEC
	call GTU_OS
    ; PROCESS III
	LXI B, 0402H	; dosyanin isminin saklandigi bellek blogunun baslangic adresi : 1031.adres
	LXI H, 61A8H	; dosyanin nereden itibaren RAM'e yazilacaginin baslangic adresi : 30000.adres
	MVI A, LOAD_EXEC
	call GTU_OS
    ; PROCESS IV
	LXI B, 040FH	; dosyanin isminin saklandigi bellek blogunun baslangic adresi : 1031.adres
	LXI H, 6B6CH	; dosyanin nereden itibaren RAM'e yazilacaginin baslangic adresi : 35000.adres
	MVI A, LOAD_EXEC
	call GTU_OS
    ; PROCESS V
	LXI B, 0418H	; dosyanin isminin saklandigi bellek blogunun baslangic adresi : 1031.adres
	LXI H, 7530H	; dosyanin nereden itibaren RAM'e yazilacaginin baslangic adresi : 35000.adres
	MVI A, LOAD_EXEC
	call GTU_OS
    ; PROCESS VI
    LXI B, 0421H
    LXI H, 0x7EF4   ; 32500d
    MVI A, LOAD_EXEC
    call GTU_OS
    ; PROCESS VII
    LXI B, 042AH
    LXI H, 0x88B8   ; 35000d
    MVI A, LOAD_EXEC
    call GTU_OS
    ; PROCESS VIII
    LXI B, 043AH
    LXI H, 0x927C   ; 37500d
    MVI A, LOAD_EXEC
    call GTU_OS
    ; PROCESS IX
    LXI B, 044AH
    LXI H, 0x9C40   ; 40000d
    MVI A, LOAD_EXEC
    call GTU_OS
    ; START KERNEL
    MVI B, 0            ; counter variable. needs to be loaded before calling scheduler subroutine
    jmp scheduler

forHandler:
	JMP interruptHandler

interruptHandler:
    DI
    LXI SP, stack       ; assuming # of push inst equals # of pop inst so that it can be restarted at this address every time interrupt handle is called    
    


; REMEMBER ADDING PID AND STATE OF PROCESSES AT FIRST!!
proc_start:
    LXI B, 0xC350    ; take the address of cur mem
    LDAX B           ; now register A has the cur mem
    MOV C, A    ; cur mem is in C so that it can be upper bound for subroutine mult
    MVI B, 0	; register B is assigned with 0 so that the counter variable of mult subroutine can be started from 0.
    JMP mult_start  ; loop, starting from 0 to cur mem
    mult_return:    ; H & L have the address of which process table entry is updated
    INR L
    INR L       ; H & L points now where the registers will be stored(0x..12)
    LXI D, 0x0100    ; D & E points where the registers are stored now
    JMP to_process_start
    process_return:
    ; end of adjuster
    MVI B, 0
    ; 0x2710'dan degil, kaldigi yerden devam etmeli donguye...
    CALL state_exit_control
    ; there is stil at least one process that is not over yet
    MVI B, 0    
    JMP scheduler


; B register : counter variable, needs to be loaded before calling this subroutine.
scheduler:
    DI
    MVI B, 0    ; ?????
    CALL state_exit_control
    LXI H, 0xC350   ; H & L have the address of cur mem
    MOV A, M        ; A has the cur mem
    MVI D, 02H  ; MSB 8 bits of factor
    MVI E, 00H  ; LSB 8 bits of factor
    MVI H, 27H  ; MSB 8 bits of starting address
    MVI L, 10H  ; LSB 8 bits of starting address(first 2 bits are for state & PID. They shouldn't be assigned to any registers)
    MVI B, 0    ; counter variable is set to 0 since register B is updated when it is in state_exit_control subroutine so that the loop can be started from 0
reach_the_address_loop:
    CMP B 
    JZ rta_exit ; if counter variable is looped enough, get out of the loop
    DAD D   ; adds 16-bit value specified register pair to contents of H and L register pair.
    INR B
    JMP reach_the_address_loop 
rta_exit:   ; we are in the next process's entry now(address is in H & L)(starting from where registers are stored!)
skip_the_done: ; we need to skip terminated processes
    PUSH psw    ; cur mem is pushed so that it can't lose its value
    MOV B, H
    MOV C, L    ; address of state is now in B & C
    LDAX B      ; state of any process is now in A
    MVI B, RUN
    CMP B
    JZ std_exit ; if state is RUN, end the loop so that registers can be updated by the entry of the process table
    POP psw     ; cur mem is in A again
    MVI B, NUM  ; (# of proc) is in B for comparing cur mem with it so that it can be decided how cur mem is updated: either 0 or += 1
    DCR B       ; (# of proc - 1) is in B now
    CMP B 
    JNZ with_zero_not   ; if cur mem is not equal to (# of proc - 1), then jump
    MVI A, 0
    LXI H, 0x2710
    JMP skip_the_done
with_zero_not:
    INR A
    DAD D
    JMP skip_the_done
std_exit: 
    POP psw ; cur mem is in A again
    LXI B, 0xC350   ; address of where cur mem is stored is in B & C
    STAX B  ; cur mem is updated ?????
    ; registers are needed to be set now. address of which entry of process table is taken is in H & L registers.
    ; D & E REGISTERS
    MVI A, 5
    CALL go_forward_start   
    LDAX D      ; 3rd element is in A
    LXI D, 0xC356
    STAX D      ; value of register D is in 0xC356
    MVI A, 6
    CALL go_forward_start
    LDAX D      ; 4th element is in A
    LXI D, 0xC355
    STAX D ; value of register E is in 0xC355
    ; H & L REGISTERS
    MVI A, 7
    CALL go_forward_start  
    LDAX D          ; 5th element is in A
    LXI D, 0xC358
    STAX D  ; value of register H is in 0xC358
    MVI A, 8
    CALL go_forward_start
    LDAX D      ; 6th element is in A
    LXI D, 0xC357
    STAX D  ; value of register L is in 0xC357
    ; BASE REGISTERS
    MVI A, 0xD
    CALL go_forward_start
    LDAX D      ; base register low in register A
    LXI D, 0xC351
    STAX D      ; base register low is in 0xC351 
    MVI A, 0xE
    CALL go_forward_start
    LDAX D      ; base register high in register A
    LXI D, 0xC352
    STAX D      ; base register high is in 0xC352
    ; PROGRAM COUNTER REGISTERS
    PUSH H      ; push the starting address of entry to the stack
    MVI A, 0xB 
    CALL go_forward_start
    LDAX D      ; program counter low is now in register A
    LXI D, 0xC353
    STAX D      ; program counter low is in 0xC353
    MVI A, 0xC
    CALL go_forward_start
    LDAX D      ; program counter high is now in register A
    LXI D, 0xC354
    STAX D      ; program counter high is in 0xC354
    POP H       ; pop the starting address of entry off the stack
    ; STACK POINTER REGISTERS
    MVI A, 9
    CALL go_forward_start
    LDAX D        ; 7th element is in A
    MOV C, A      ; sp low is in C
    MVI A, 0xA    
    CALL go_forward_start 
    LDAX D      ; sp high is in A
    MOV B, A    ; sp high is in B
    PUSH B      ; push stack pointers to the stack
    ; B & C REGISTERS
    MVI A, 4
    CALL go_forward_start 
    LDAX D      ; register C is now in register A
    PUSH psw    ; push the value of C to the stack
    MVI A, 3
    CALL go_forward_start
    LDAX D      ; register B is now in register A
    MOV B, A    ; copy the value of register B to register B
    POP psw     ; pop the value of C off the stack to register A
    MOV C, A    ; copy the value of register C to register C
    PUSH B      ; push value of registers B & C to the stack. IT NEEDS TO BE POPPED OFF!!!!
    ; A & cc REGISTERS
    MVI A, 0xF
    CALL go_forward_start
    LDAX D      ; value of cc is now in register A
    MOV C, A    ; condition flags are in register C
    ; A REGISTER
    MOV D, H
    MOV E, L    ; 0x..10 is here. It needs to be 0x..12 for register A
    INR E
    INR E
    LDAX D      ; value of register A is now in register A
    MOV B, A    ; accumulator is in register B
    PUSH B      ; push accumulator and condition flags to the stack
    POP psw     ; pop accumulator and condition flags off the stack
    POP B       ; value of registers B & C are now in registers B & C again.
    POP H       ; stack pointers are popped off

    SPHL        ; H & L are free to use
    
    LXI H, 0xC356
    MOV D, M    ; value of D is in D
    LXI H, 0xC355
    MOV E, M    ; value of E is in E
    PUSH D      ; value of D & E are pushed to the stack so that PCHL can pop them off

    LXI H, 0xC358
    MOV D, M    ; value of H is in D
    LXI H, 0xC357
    MOV E, M    ; value of L is in E
    PUSH D      ; value of H & L are pushed to the stack so that PCHL can pop them off 
    

    LXI H, 0xC352   ; base high
    MOV D, M        
    LXI H, 0xC351   ; base low
    MOV E, M        
    PUSH D
    LXI H, 0xC354   ; pc high
    MOV D, M        
    LXI H, 0xC353   ; pc low
    MOV E, M        
    
    MOV H, D    ; program counters are in H & L
    MOV L, E
    POP D       ; base registers are in D & E

    EI
    ;MVI A, 10
    ;CALL GTU_OS
    PCHL        ; D & E and H & L are in their own place



; A register : upper bound variable, needs to be loaded before calling this subroutine
; address of where the program is branched into this subroutine needs to be pushed to the stack so that flow of the program can be back where it is supposed to be at the end of this subroutine
; atama oncesi adres H & L registerlarinda deger ile guncellenir(muhtemelne push edilecek) boylece hep go_forward yapilir
go_forward_start:
    MOV D, H
    MOV E, L    ; starting address of entry is in D & E registers now so that they can be used for LDAX
    MVI B, 0
go_forward_loop:
    CMP B
    JZ go_forward_exit
    INR B
    INR E
    JMP go_forward_loop
go_forward_exit:
    RET



; B register : counter variable, needs to be loaded before calling this subroutine.
; H & L register pair keeps the starting address of process table
; D & E register pair keeps factor
; Decides if there is any process that is not over yet or not. If it is, simply return to sec_return. Halts the kernel otherwise.
state_exit_control:
    MVI D, 02H  ; MSB 8 bits of factor
    MVI E, 00H  ; LSB 8 bits of factor
    MVI H, 27H  ; MSB 8 bits of starting address
    MVI L, 10H  ; LSB 8 bits of starting address
sec_loop:
    MVI A, NUM
    CMP B
    JZ terminate_os ; if A == B(counter == (# of proc)), 
    PUSH B  ; push counter variable so that it can't lose its value while using register B & C for LDAX instruction
    MOV B, H
    MOV C, L    ; now register B & C have the address of state of any process
    LDAX B      ; Register A have the state of any process
    MVI B, DONE ; so as to compare if the state is DONE or not
    CMP B
    JNZ sec_exit ; if A != 0(DONE), then jump to sec_exit, at least one process is stil not over
    DAD D   ; adds 16-bit value specified register pair to contents of H and L register pair
    POP B   ; pop B & C so that the counter variable can be taken back.
    INR B
    JMP sec_loop
sec_exit:
    ; MVI B, 0 ; I'm not sure if this is supposed to be here or not
    POP B   ; pop B & C so that the counter variable can be taken back.
    RET
terminate_os:
    HLT



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
