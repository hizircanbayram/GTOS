#include <iostream>
#include <ctime>
#include <cstdlib>
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
  int seed_val = 0;
  Memory mem(0x10000);
  
  CPU8080 *theCPU = new CPU8080(&mem);
  GTUOS	theOS;
  
  theCPU->ReadFileIntoMemoryAt(argv[1], 0x0000);
  theCPU->setQuantum(100);
  do{
    if(DEBUG == 2)
      getchar();
    
    theCPU->Emulate8080p(DEBUG);
    if(theCPU->isSystemCall())
      theOS.handleCall(*theCPU, seed_val);
    ++seed_val;
  }while(!theCPU->isHalted());
  free(theCPU);
  return 0;
}
