#include <iostream>
#include "8080emuCPP.h"
#include "gtuos.h"
#include "memory.h"



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
	
    // Initialize with 0
    uint64_t numOfCycle = 0;

    // Read the file
	theCPU.ReadFileIntoMemoryAt(argv[1], 0x0000);	
     
	do	
	{
        numOfCycle += theCPU.Emulate8080p(DEBUG);

        // Wait for an from the keyboard and it will continue for the next tick
        if(DEBUG == 2){
            std::cout << "Press some key to continue: ";
            std::cin.get();
        }

		if(theCPU.isSystemCall()) {
			theOS.handleCall(theCPU);
		}
            
		//printf("cur mem : %d\n", theCPU.memory->physicalAt(0xC350));
		//printf("%d	%d	%d  %d  %d\n", theCPU.memory->physicalAt(0x2710), theCPU.memory->physicalAt(0x2910), theCPU.memory->physicalAt(0x2B10), theCPU.memory->physicalAt(0x2D10), theCPU.memory->physicalAt(0x2F10));
	}	while (!theCPU.isHalted());
	
	return 0;
}

