#include <iostream>
#include "8080emuCPP.h"
#include "gtuos.h"



uint64_t GTUOS::handleCall(const CPU8080 & cpu){
	// So as to understand which system call to be executed, register A is checked. System call number is assigned to register A.
	uint8_t content_A = cpu.state->a;
	// system call numbers

	switch (content_A) {
		case this->PRINT_B.number:

			break;
		case this->PRINT_MEM.number:

			break;
		case this->READ_B.number:

			break;
		case this->READ_MEM.number:

			break;
		case this->PRINT_STR.number:

			break;

		case this->READ_STR.number:

			break;
	}
	return 0;
}


