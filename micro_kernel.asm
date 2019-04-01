.binfile micro_kernel.com

PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8
LOAD_EXEC	equ 5

NUM equ 2
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


proc1: dw  'Factorize.com',00H		
proc2: dw  'ShowPrimes.com',00H
proc3: dw  'Palindrome.com', 00H

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
    LXI B, 0x2717
    MVI A, 0x29
    STAX B
    LXI B, 0x2718
    MVI A, 0xF
    STAX B
    LXI B, 0x2719
    MVI A, 0
    STAX B
    LXI B, 0x271A
    MVI A, 0
    STAX B
    LXI B, 0x271B
    MVI A, 0x4E
    STAX B
    LXI B, 0x271C
    MVI A, 0x20
    STAX B
        ; PROCESS II
    LXI B, 0x2910
    MVI A, 1
    STAX B
    LXI B, 0x2917
    MVI A, 0x2B
    STAX B
    LXI B, 0x2918
    MVI A, 0xF
    STAX B
    LXI B, 0x2919
    MVI A, 0
    STAX B
    LXI B, 0x291A
    MVI A, 0
    STAX B
    LXI B, 0x291B
    MVI A, 0x61
    STAX B
    LXI B, 0x291C
    MVI A, 0xA8
    STAX B
        ; PROCESS III
    LXI B, 0x2B10
    MVI A, 1
    STAX B
    LXI B, 0x2B17
    MVI A, 0x2D
    STAX B
    LXI B, 0x2B18
    MVI A, 0xF
    STAX B
    LXI B, 0x2B19
    MVI A, 0
    STAX B
    LXI B, 0x2B1A
    MVI A, 0
    STAX B
    LXI B, 0x2B1B
    MVI A, 0x75
    STAX B
    LXI B, 0x2B1C
    MVI A, 0x30
    STAX B
    ; PROCESS I
	LXI B, 03E8H	; starting address of where the file name is stored : 1010. address
	LXI H, 4E20H	; starting address of where the file is stored : 20000.address
	MVI A, LOAD_EXEC
	call GTU_OS
    ; PROCESS II
	LXI B, 03F7H	; starting address of where the file name is stored : 1015.address
	LXI H, 61A8H	; starting address of where the file is stored : 25000.address
	MVI A, LOAD_EXEC
	call GTU_OS
    ; PROCESS III
	LXI B, 0407H	; dosyanin isminin saklandigi bellek blogunun baslangic adresi : 1031.adres
	LXI H, 7530H	; dosyanin nereden itibaren RAM'e yazilacaginin baslangic adresi : 30000.adres
	MVI A, LOAD_EXEC
	call GTU_OS
    ; START KERNEL
	; EI
	;LXI H,0000H		; yeni prosesin kendi adres space'indeki ilk adresi
	;LXI D,4E20H		; yeni prosesin kendi adres space'i, 5000. adres
    MVI B, 0            ; counter variable. needs to be loaded before calling scheduler subroutine
    jmp scheduler

forHandler:
	JMP interruptHandler

interruptHandler:
    DI
    LXI SP, stack       ; assuming # of push inst equals # of pop inst so that it can be restarted at this address every time interrupt handle is called    ?????
; HER PROCESSIN STATE VE PID'LERINI ATAMAYI UNUTMA!!!
; INTERRUPT DI VE EI ETMEYI UNUTMA!!!!
; LOAD EXEC system call no ekle!!!
proc_start:
    LXI B, 0xC350    ; take the address of cur mem
    LDAX B           ; now register A has the cur mem
    MOV C, A    ; cur mem is in C so that it can be upper bound for subroutine mult
    MVI B, 0	; register B is assigned with 0 so that the counter variable of mult subroutine can be started from 0.
    JMP mult_start  ; loop, starting from 0 to cur mem
    mult_return:    ; H & L have the address of which process table entry is updated
    INR L
    INR L       ; H & L points now where the registers will be stored
    LXI D, 0x0100    ; D & E points now where the registers are stored
    JMP to_process_start
    process_return:
    ; end of adjuster
    MVI B, 0
    ; 0x2710'dan degil, kaldigi yerden devam etmeli donguye...
    JMP state_exit_control
    sec_return:
    ; there is stil at least one process that is not over yet
    MVI B, 0    
    JMP scheduler


; B register : counter variable, needs to be loaded before calling this subroutine.
scheduler:
    DI
    LXI H, 0xC350   ; H & L have the address of cur mem
    MOV A, M        ; A has the cur mem
    MVI D, 02H  ; MSB 8 bits of factor
    MVI E, 00H  ; LSB 8 bits of factor
    MVI H, 27H  ; MSB 8 bits of starting address
    MVI L, 10H  ; LSB 8 bits of starting address(first 2 bits are for state & PID. They shouldn't be assigned to any registers)
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
    MVI A, 3
    CALL go_forward_start   
    LDAX D      ; 3rd element is in A
    PUSH psw    ; 3rd element is in stack so that it can't lose its value below
    MVI A, 4
    CALL go_forward_start
    LDAX D      ; 4th element is in A
    MOV E, A    ; 4th element is in register E
    POP psw     ; 3rd element is now in A again
    MOV D, A    ; 3rd element is in register D
    PUSH D      ; push D and E so that they can't lose their value  ; PCHL POP EDECEK!!!
    ; H & L REGISTERS
    MVI A, 5
    CALL go_forward_start  
    LDAX D          ; 5th element is in A
    MOV C, A        ; 5th element is in C
    MVI A, 6
    CALL go_forward_start
    LDAX D      ; 6th element is in A
    MOV B, A    ; 6th element is in B
    MOV A, B
    MOV B, C
    MOV C, A    ; swap operation. There was a mistake of values in the register B & C. They've been swapped.
    PUSH B      ; push B and C so that they can't lose their value(value of H & L)   ; PCHL POP EDECEK!!!  BUNDAN SONRAKILERI BENIM POP ETMEM GEREKIYOR
    ; BASE REGISTERS
    MVI A, 0xB
    CALL go_forward_start
    LDAX D      ; base register low in register A
    MOV E, A    ; move base register low to register E
    PUSH D      ; push D & E to the stack so that value of E can't be lost
    MVI A, 0xC
    CALL go_forward_start
    LDAX D      ; base register high in register A
    POP D       ; pop D & E off the stack so that value of E can be back in register E
    MOV D, A    ; move base register high to register D
    MOV A, D   
    MOV D, E
    MOV E, A    ; swap operation. There was a mistake of values in the register D & E. They've been swapped. ?????
    PUSH D      ; BASE REGISTERS ARE PUSHED TO THE STACK. THEY NEEDED TO BE POPPED OFF!!!
    ; PROGRAM COUNTER REGISTERS
    PUSH H      ; push the starting address of entry to the stack
    MVI A, 9 
    CALL go_forward_start
    LDAX D      ; program counter low is now in register A
    MOV E, A    ; program counter low is now in register E
    PUSH D      ; push program counter low to the stack
    MVI A, 0xA
    CALL go_forward_start
    LDAX D      ; program counter high is now in register A
    POP D       ; program counter low is popped off, it is now in register E
    MOV D, A    ; program counter high is now in register D
    POP H       ; pop the starting address of entry off the stack
    PUSH D      ; !!!D & E have the program counter registers. They needed to be popped off to H & L!!
    ; STACK POINTER REGISTERS
    MVI A, 7
    CALL go_forward_start
    LDAX D        ; 7th element is in A
    MOV C, A      ; sp low is in C
    ; PUSH psw    ; push it to the stack so that it can't lose its value while assigning it with 0 for another loop below
    MVI A, 8    
    CALL go_forward_start 
    LDAX D      ; sp high is in A
    MOV B, A    ; sp high is in B
    MOV A, B
    MOV B, C
    MOV C, A    ; there was a mistake for placing sp low & sp high in correct order. Thus, they're swapped. ?????
    PUSH B      ; push stack pointers to the stack
    ; B & C REGISTERS
    MVI A, 2
    CALL go_forward_start 
    LDAX D      ; register C is now in register A
    PUSH psw    ; push the value of C to the stack
    MVI A, 1
    CALL go_forward_start
    LDAX D      ; register B is now in register A
    MOV B, A    ; copy the value of register B to register B
    POP psw     ; pop the value of C off the stack to register A
    MOV C, A    ; copy the value of register C to register C
    PUSH B      ; push value of registers B & C to the stack. IT NEEDS TO BE POPPED OFF!!!!
    ; cc REGISTER
    MVI A, 0xD
    CALL go_forward_start
    LDAX D      ; value of cc is now in register A
    PUSH psw
    POP psw
    ; A REGISTER
    MOV D, H
    MOV E, L
    LDAX D      ; value of register A is now in register A
    POP B       ; value of registers B & C are now in registers B & C again.
    POP H       ; stack pointers are popped off
    ;SPHL
    POP H       ; program counter registers are now in H & L, as it supposed to be
    POP D       ; base registers are now in D & E, as it supposed to be
    EI
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
    ; MVI B, 0 ; OLMASI GEREKIYOR MU EMIN DEGILIM!!!!
    POP B   ; pop B & C so that the counter variable can be taken back.
    JMP sec_return
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
