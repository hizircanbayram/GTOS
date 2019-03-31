#include <iostream>
#include "gtuos.h"
#include "8080emuCPP.h"
#include "memory.h"

using namespace::std;


int main (int argc, char**argv)
{

	if (argc != 3){
		std::cerr << "Usage: prog exeFile debugOption\n";
		exit(1); 
	}

	int DEBUG = atoi(argv[2]);

	memory mem;
	CPU8080 theCPU(&mem);
	GTUOS	theOS;

    int k = 0;
    for (int i = 256; i < 270; ++i) {
        theCPU.memory->physicalAt(i) = k;
        ++k;
    }
    
    theCPU.memory->physicalAt(0x2710) = 0; // done
    theCPU.memory->physicalAt(0x2910) = 1; // run
    theCPU.memory->physicalAt(0x2b10) = 0;
    //theCPU.memory->physicalAt(0x2d10) = 1;     
	theCPU.memory->physicalAt(0xc350) = 2;
	
	printf("0xc350 content : %d\n", theCPU.memory->physicalAt(0xc350));
	
	k = 15;
    for (int i = 0x2911; i < 0x2920; ++i)
        theCPU.memory->physicalAt(i) = k++;
    /*
    0x11 -> 15
    0x12 -> 16
    0x13 -> 17
    0x14 -> 18
    0x15 -> 19
    0x16 -> 20
    0x17 -> 21
    0x18 -> 22
    */
	
	theCPU.ReadFileIntoMemoryAt(argv[1], 0x0000);	
 	
    printf("\n------------0x2710-------------\n");
    for (int i = 0x2710; i < 0x2720; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    printf("\n------------0x2910-------------\n");
    for (int i = 0x2910; i < 0x2920; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    printf("\n------------0x2b10-------------\n");
    for (int i = 0x2b10; i < 0x2b20; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    /*printf("\n------------0x2d10-------------\n");
    for (int i = 0x2d10; i < 0x2d20; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));*/
 	printf("\n\n\n\n\n\n\n\n");
	do	
	{
		theCPU.Emulate8080p(DEBUG);
		if(theCPU.isSystemCall())
			theOS.handleCall(theCPU);
		if (DEBUG == 2)
			getchar();
	}	while (!theCPU.isHalted())
;

    printf("\n------------0x2710-------------\n");
    for (int i = 0x2710; i < 0x2720; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    printf("\n------------0x2910-------------\n");
    for (int i = 0x2910; i < 0x2920; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    printf("\n------------0x2b10-------------\n");
    for (int i = 0x2b10; i < 0x2b20; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));
    /*printf("\n------------0x2d10-------------\n");
    for (int i = 0x2d10; i < 0x2d20; ++i)
        printf("%x : %d\n", i, theCPU.memory->physicalAt(i));*/
	printf("0xc350 content : %d\n", theCPU.memory->physicalAt(0xc350));
	printf("H : %d, L : %d\n", theCPU.state->h, theCPU.state->l); // 23 ve 22 gelmeli
	return 0;
}

