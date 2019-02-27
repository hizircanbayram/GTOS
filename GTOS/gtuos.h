#ifndef H_GTUOS
#define H_GTUOS

#include "/home/cse312/GTOS/Intel_8080_Emulator/8080emuCPP.h"



class GTUOS{
	public:
		uint64_t handleCall(const CPU8080 & cpu);
		uint64_t call_print_b(const CPU8080 & cpu);
		uint64_t call_print_mem(const CPU8080 & cpu);
		uint64_t call_print_str(const CPU8080 & cpu);
		uint64_t call_read_b(const CPU8080 & cpu);
		uint64_t call_read_mem(const CPU8080 & cpu);
		uint64_t call_read_str(const CPU8080 & cpu);
		void writeMemoryIntoFile(const CPU8080 &cpu);
	private:
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
};

#endif