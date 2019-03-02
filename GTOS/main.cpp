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

	theCPU.ReadFileIntoMemoryAt(argv[1], 0x0000);	
 
	do	
	{
		theCPU.Emulate8080p(DEBUG);
		if(theCPU.isSystemCall())
			theOS.handleCall(theCPU);
		if (DEBUG == 2)
			getchar();
	}	while (!theCPU.isHalted())
;

	return 0;
}

