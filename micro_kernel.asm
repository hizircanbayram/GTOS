.binfile micro_kernel.com

PRINT_B		equ 4
PRINT_MEM	equ 3
READ_B		equ 7
READ_MEM	equ 2
PRINT_STR	equ 1
READ_STR	equ 8
LOAD_EXEC	equ 5

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
;	DI
	LXI SP,stack
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
;	EI
	
	LXI H,0000H		; yeni prosesin kendi adres space'indeki ilk adresi
	LXI D,1388H		; yeni prosesin kendi adres space'i, 5000. adres
	PCHL
	hlt

forHandler:
	JMP interruptHandler

interruptHandler:
    DI
    ;256dan başlayan değerleri process table a atmak için kullandığımız alan
    LXI B, 0100H
    LDAX B
    LXI B,2710H
    STAX B
    
    LXI B, 0101H
    LDAX B
    LXI B,2711H
    STAX B 
    
    LXI B, 0102H
    LDAX B
    LXI B,2712H
    STAX B    
    
    LXI B, 0103H
    LDAX B
    LXI B,2713H
    STAX B 

    LXI B, 0104H
    LDAX B
    LXI B,2714H
    STAX B 

    LXI B, 0105H
    LDAX B
    LXI B,2715H
    STAX B 

    LXI B, 0106H
    LDAX B
    LXI B,2716H
    STAX B 
    
    LXI B, 0107H
    LDAX B
    LXI B,2717H
    STAX B 
    
    LXI B, 0108H
    LDAX B
    LXI B,2718H
    STAX B 

    LXI B, 0109H
    LDAX B
    LXI B,2719H
    STAX B 

    LXI B, 010AH
    LDAX B
    LXI B,271AH
    STAX B 

    LXI B, 010BH
    LDAX B
    LXI B,271BH
    STAX B 

    LXI B, 010CH
    LDAX B
    LXI B,271CH
    STAX B 

    LXI B, 010DH
    LDAX B
    LXI B,271DH
    STAX B
	 
    ;process tabledan gerekli değerleri çekmemiz gereken alan 
 
  
    

    

    ; process exit'te scheduler'a geri donmesi icin scheduler'in basina bir adres verildi org ile, process exit fonksiyonunda da o adres pchl ile cagrilip guncellenerek scheduler'a geri donmesi saglandi.    

   ;stack pointer ı atmak için kullandık.Hlden once stack pointerı atmak gerekiyor. Çünkü stack pointer için hl yi kullanıyoruz.
    LXI B,2717H
    LDAX B
    MOV L,A ; stack pointer low
    LXI B,2718H
    LDAX B
    MOV H,A ; stack pointer high
    SPHL
    
    LXI B,2713H
    LDAX B
    MOV D,A

    LXI B,2714H
    LDAX B
    MOV E,A
    PUSH D

    
    LXI B,2715H
    LDAX B
    MOV H,A

    LXI B,2716H
    LDAX B
    MOV L,A
    PUSH H
   
    
      
   
    ;PC ve base registırları atma işlemini gerçekleştirdik.
    LXI B,271BH
    LDAX B
    MOV E,A  ; base register low
    LXI B,271CH
    LDAX B
    MOV D,A ; base register high
    LXI B,2719H
    LDAX B
    MOV L,A ; program counter low
    LXI B,271AH
    LDAX B
    MOV H,A  ; program counter high
   
   
    
   

    LXI B,2712H
    LDAX B
    PUSH psw	; NEW

    LXI B,2711H
    LDAX B
    MOV B,A
    POP psw	; NEW
    MOV C,A	; NEW

    PUSH B
    
 
;cc degerini ve a registırını push eder. Ama a nın içinde yanlış deger olacagı için a yı tekrar almamız gerekecek
    LXI B,271DH
    LDAX B
    PUSH PSW
    POP PSW
    
       ;a registerı surekli kullandigimiz icin bu blogu en sonda yapmamiz gerekir cunku a surekli degisiyor
    LXI B,2710H
    LDAX B
    MOV A,A
    
    POP B
    EI
    PCHL
    hlt


