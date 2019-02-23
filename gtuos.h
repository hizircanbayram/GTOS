#ifndef H_GTUOS
#define H_GTUOS

#include "8080emuCPP.h"

// Prints the null terminated string at the address pointed by B and C. B and C de neresi? B ve C registerlarinda adresler var. Bu adresler arasindaki string'i okumamizi mi istiyor?

class GTUOS{
	public:
		uint64_t handleCall(const CPU8080 & cpu);


	private:
		class syscall {
				public:
					syscall(int number, int cycle) {
						this->number = number;
						this->cycle = cycle;
					}
				private:
					int number;
					int cycle;
			};
		syscall PRINT_B = syscall(4, 10);
		syscall PRINT_MEM = syscall(3, 10);
		syscall READ_B = syscall(7, 10);
		syscall READ_MEM = syscall(2, 10);
		syscall PRINT_STR = syscall(1, 10); // 10 cycles per character
		syscall READ_STR = syscall(8, 10); // 10 cycles per character
};

#endif
