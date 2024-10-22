.binfile Palindrome.com
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
	; YOU SHOULD NOT CHANGE ANYTHING ABOVE THIS LINE        

	; This program prints a null terminated string to the screen

string:	ds 0FFH 	; null terminated string
;string dw 'aabbcfcbbaaaa',00H
pal:	dw 'palindrom',00H 	; prompt for detecting that it's a palindrom
notpal: dw 'not palindrom',00H ; prompt for detecting that it's not a palindrom





; finds where the given string whose address kept in register A and B ends. Address of the last element of the string is kept in the registers H and L.
end_string_begin:
	LXI B, string			; reg H and L keep the address
	mvi a, 0				; length is in the accumulator
end_string_loop:
	mov b, M 				; char is here | M is a symbolic reference to the H and L registers
	push a					; length is in the stack
	mov a, b 				; char is in accumulator
	cpi 0 					; if char null -> zero flag is 1
	jz exit_end_string
	inx H 					; H means H & L registers here. increment the address by one
	pop a					; length is in the accumulator
	inr a
	jmp end_string_loop	
exit_end_string: 				
	dcx H	
	pop a					; length is in the accumulator
	sui 1
	mov e, a
	jmp back_main_string





; finds if given string is palindrome or not. According to that, it jumps to a label defined in the main sub routine.
palindrome_begin:
	mov a, e 					; right variable is in accumulator. left variable is in register D
	cmp d						; compare right and left
	jz write_palindrom 			; right and left are the same(indexes). it's a palindrome
	jc write_palindrom			; lef > rig : d > a : a < d
	push D						; right and left variables are pushed to stack
	mov a, M					; last character is in the accumulator
	push H						; push the address of the last char so that its address doesn't lose
	mov h, b
	mov l, c
	mov d, M					; first character is in the register D
	cmp d						; compare the last and first character
	jnz write_not_palindrom		; if not equal, not a palindrome 
	pop H						; take the address of the last char back so that it can be decremented by one
	dcr l						; decrements l by one so that the address of the last character is decremented by one too
	inr c						; increment c by one so that the address of the first character is increased by one too
	pop D						; take the right and left variables back
	dcr e						; decrease the right var
	inr d						; increase the left var
	jmp palindrome_begin





; main sub routine.
begin:
	LXI B, string 			; address of the first character is kept in the registers B and C	
	mvi a, READ_STR
	call GTU_OS
	LXI H, string
	mvi d, 0				; left is assigned to register D
	jmp end_string_begin 	; address of the last character is kept in the registers H and L. right is assigned to register E. length of the string is in the register E
	back_main_string:		
	jmp palindrome_begin
write_palindrom:
	mvi a, PRINT_STR
	lxi b, pal
	call GTU_OS
	mvi a, PROCESS_EXIT
	call GTU_OS
write_not_palindrom:
	mvi a, PRINT_STR
	lxi b, notpal
	call GTU_OS
	mvi a, PROCESS_EXIT
	call GTU_OS

