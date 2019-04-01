#include <iostream>
#include "8080emuCPP.h"
#include "gtuos.h"
#include "memory.h"

// This is just a sample main function, you should rewrite this file to handle problems
// with new multitasking and virtual memory additions.

int main (int argc, char**argv)
{
	if (argc != 3){
		std::cerr << "Usage: prog exeFile debugOption\n";
		exit(1); 
	}
	int DEBUG = atoi(argv[2]);


	Memory mem(100000);
	CPU8080 theCPU(&mem);
	GTUOS	theOS;
	
	/*int k = 0;
    for (int i = 256; i < 270; ++i) {
        theCPU.memory->physicalAt(i) = k;
        ++k;
    }
    
    theCPU.memory->physicalAt(0x2710) = 0; // done
    theCPU.memory->physicalAt(0x2910) = 1; // run
    theCPU.memory->physicalAt(0x2b10) = 0;
    theCPU.memory->physicalAt(0x2d10) = 1;     
	theCPU.memory->physicalAt(0xc350) = 2;

	printf("0xc350 content : %d\n", theCPU.memory->physicalAt(0xc350));
	
	k = 15;
    for (int i = 0x2911; i < 0x2920; ++i)
        theCPU.memory->physicalAt(i) = k++;*/

    // Initialize with 0
    uint64_t numOfCycle = 0;

    // Read the file
	theCPU.ReadFileIntoMemoryAt(argv[1], 0x0000);	
/* 
    printf("\n------------0x2710-------------\n");
    for (int i = 0x2710; i < 0x2720; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    printf("\n------------0x2910-------------\n");
    for (int i = 0x2910; i < 0x2920; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    printf("\n------------0x2b10-------------\n");
    for (int i = 0x2b10; i < 0x2b20; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));*/
    /*printf("\n------------0x2d10-------------\n");
    for (int i = 0x2d10; i < 0x2d20; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));*/
// 	printf("\n\n\n\n\n\n\n\n"); 
 
	do	
	{
        numOfCycle += theCPU.Emulate8080p(DEBUG);

        // Wait for an from the keyboard and it will continue for the next tick
        if(DEBUG == 2){
            std::cout << "Press some key to continue: ";
            std::cin.get();
        }

		if(theCPU.isSystemCall())
            theOS.handleCall(theCPU);

	}	while (!theCPU.isHalted());
	
    /*printf("\n------------0x2710-------------\n");
    for (int i = 0x2710; i < 0x2720; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    printf("\n------------0x2910-------------\n");
    for (int i = 0x2910; i < 0x2920; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    printf("\n------------0x2b10-------------\n");
    for (int i = 0x2b10; i < 0x2b20; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));*/
    /*printf("\n------------0x2d10-------------\n");
    for (int i = 0x2d10; i < 0x2d20; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));*/
//	printf("0xc350 content : %d\n", theCPU.memory->physicalAt(0xc350));
	//printf("H : %d, L : %d\n", theCPU.state->h, theCPU.state->l); // 23 ve 22 gelmeli

//	printf("%x, %x, %x, %x, %x, %x, %x, %x, %x\n", theCPU.state->a, theCPU.state->b, theCPU.state->c, theCPU.state->d, theCPU.state->e, theCPU.state->h, theCPU.state->l, theCPU.state->sp);
	return 0;
}

