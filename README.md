# GTOS

GTOS is an virtual operating system that can run on Intel 8080 Emulator.



WHAT IT SUPPORTS:

System calls that it can handle:
  - PRINT_B
    * Prints the content of register B on the screen in decimal form. It takes 10 cycles to be completed.
  - PRINT_MEM
    * Prints the content of the memory pointed by register B and register C as in decimal form. It takes 10 cycles to be completed.
  - READ_B
    * Reads an integer from the keyboard and puts it into register B. It takes 10 cycles to be completed.
  - READ_MEM
    * Reads an integer from the keyboard and puts it into address pointed by register B and register C. It takes 10 cycles to be completed.
  - PRINT_STR
    * Prints the null terminated string at the address pointed by register B and register C. It takes 10 cycles to be completed for a character.
  - READ_STR
    * Reads the null terminated string from the keyboard and puts it into the memory starting from the location pointed by B and C. It takes 10 cycles to be completed for a character.



COMPILATION:

Makefile is used to compile it into GNU/Linux based operating systems. Preprocessor directives might be changed so that GTOS can be compatible with anyone else's system.



EXECUTION:

Since it is hard to find such an architecture nowadays, a software is required so that the programs that are executed on Intel 8080 processor can be translated into machine code. Thus, there are some tasks that are needed to follow after compilation is done successfully:
  - Go to http://sensi.org/~svo/i8080/
  - Paste the assembly code that is executed on the processor. 
  - Click the button 'Make beautiful code'
  - Move .com file to the directory that has the .exe file from the compilation process.
  - Execute the command below with either of the debug modes: 0, 1, 2\
      ./gtos8080 file_name.com
      
NOTE: Since there are a lot processes to convert assembly files to executable virtualized machine instructions so as to test with different parameters, I/O type has been updated from terminal to regular files. For example to test if a given string is palindrome or not, put simply the parameter into the called "input.txt". See the result in the file called "output.txt", the steps mentioned above are still valid though.


DEBUG:

There are three type of modes that a program can be executed on GTOS:
  - ./gtos8080 file_name.com 0
    * Executes a program without any debug mode.
  - ./gtos8080 file_name.com 1
    * Executes a program with the debug mode of type 1. Writes every command, condition flags, register contents at once.
  - ./gtos8080 file_name.com 2
    * Executes a program with the debug mode of type 2. Writes a command, condition flags, register contents step by step.
