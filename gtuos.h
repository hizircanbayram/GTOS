#ifndef H_GTUOS
#define H_GTUOS

#include "8080emuCPP.h"
#include <fstream>
#include <ostream>
#include <ctime>

using namespace std;

class GTUOS{
	public:
		GTUOS();
		~GTUOS();
		uint64_t handleCall(CPU8080 & cpu);
		uint64_t call_print_b(const CPU8080 & cpu);
		uint64_t call_print_mem(const CPU8080 & cpu);
		uint64_t call_print_str(const CPU8080 & cpu);
		uint64_t call_read_b(const CPU8080 & cpu);
		uint64_t call_read_mem(const CPU8080 & cpu);
		uint64_t call_read_str(const CPU8080 & cpu);
        uint64_t load_exec(CPU8080 & cpu);
        uint64_t process_exit(CPU8080 & cpu);
        uint64_t set_quantum(CPU8080 & cpu);
        uint64_t rand_int(CPU8080 & cpu);

	private:
		ofstream oFile;
		ifstream inFile;
		class syscall {
				public:
					syscall(int n, int c) {
						number = n;
						cycle = c;
					}
			
					int number;
					uint64_t cycle;
		};
		syscall PRINT_B = syscall(4, 10);
		syscall PRINT_MEM = syscall(3, 10);
		syscall READ_B = syscall(7, 10);
		syscall READ_MEM = syscall(2, 10);
		syscall PRINT_STR = syscall(1, 10); // 10 cycles per character
		syscall READ_STR = syscall(8, 10); // 10 cycles per character
        syscall LOAD_EXEC = syscall(5, 100);
        syscall PROCESS_EXIT = syscall(9, 80);
        syscall SET_QUANTUM = syscall(6, 7);
        syscall RAND_INT = syscall(12, 60);
};

#endif
