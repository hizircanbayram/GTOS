#include <iostream>
#include "gtuos.h"
#include "/home/cse312/GTOS/Intel_8080_Emulator/8080emuCPP.h"


using namespace std;



// Handles system calls and return # of cycles it takes.
uint64_t GTUOS::handleCall(const CPU8080 & cpu){
	uint8_t content_A = cpu.state->a; // So as to understand which system call to be executed, register A is checked. System call number is assigned to register A.
	uint64_t cycle = 0; // # of cycles during any of the system calls below is assigned to this variable so that it can be returned.
	if (content_A == PRINT_B.number)
		cycle = call_print_b(cpu);
	else if (content_A == PRINT_MEM.number)
		cycle = call_print_mem(cpu);
	else if (content_A == READ_B.number)
		cycle = call_read_b(cpu);
	else if (content_A == READ_MEM.number)
		cycle = call_read_mem(cpu);
	else if (content_A == PRINT_STR.number)
		cycle = call_print_str(cpu);
	else if (content_A ==  READ_STR.number)
		cycle = call_read_str(cpu);
	
	return cycle;
}



// Calls PRINT_B system call. Prints the contents of register B the screen as decimal.
uint64_t GTUOS::call_print_b(const CPU8080 & cpu) {
	cout << "PRINT_B system call   |   ";
	cout << "Register B content : " << int(cpu.state->b) << endl;
	return this->PRINT_B.cycle;
}



// Calls PRINT_MEM system call. Prints the of contents of memory pointed by register  B and register C as decimal.
uint64_t GTUOS::call_print_mem(const CPU8080 & cpu) {
	cout << "PRINT_MEM system call   |   ";
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	cout << address << " content : " << (int)cpu.memory->at(address) << endl;
	return this->PRINT_MEM.cycle;
}



// Calls PRINT_STR system call. Prints the null terminated string at the address pointed by register B and register C.
uint64_t GTUOS::call_print_str(const CPU8080 & cpu) {
	cout << "PRINT_STR system call   |   ";
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	cout << "String starting from address " << address << " : ";
	int local_cycle_num = 0;
	//for (uint16_t i = address; cpu.memory->at(i) != '\0'; ++i) {
	//	cout << (char)(cpu.memory->at(i));
	//	local_cycle_num += 1;
	//}
    for(uint16_t i = address; cpu.memory->at(i) != '\0';  ++i){
        cout << char(cpu.memory->at(i));
    }
	cout << endl;
	return this->PRINT_STR.cycle * local_cycle_num;
}



// Calls READ_B system call. Reads an integer from the keyboard and puts it in to Register B.
uint64_t GTUOS::call_read_b(const CPU8080 & cpu) {
	cout << "READ_B system call   |   ";
	cin.clear();
	uint8_t content;
	cout << "Enter the number that is written to register B ranging from 0 to 255 : ";
	cin >> content;
	if ((content < 0) || (content > 255)) {
		cout << "The number isn't in the valid range. 0 is assigned." << endl;
		content = 0;
	}
	cpu.state->b = content;
	return this->READ_B.cycle;
}



// Calls READ_MEM system call. Reads an integer from the keyboard and puts it at the memory location pointed by register B and register C.
uint64_t GTUOS::call_read_mem(const CPU8080 & cpu) {
	cout << "READ_MEM system call   |   ";
	cin.clear();
	uint8_t content;
	cout << "Enter the number that is written to the memory address pointed by register B abd register C : ";
	cin >> content;
	if ((content < 0) || (content > 255)) {
		cout << "The number isn't in the valid range. 0 is assigned." << endl;
		content = 0;
	}
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	cpu.memory->at(address) = content;
	return this->READ_MEM.cycle;
}



// Calls READ_STR system call. Reads the null terminated string from the keyboard and puts it at the memory location pointed by register B and register C.
uint64_t GTUOS::call_read_str(const CPU8080 & cpu) {
	cout << "READ_STR system call   |   ";
	cin.clear();
	string str = "";
	cout << "Enter a string that will be written into the address pointed by register B anc register C : ";
	getline(cin, str);
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	uint16_t k = address;
	for (size_t i = 0; i < str.length(); ++k, ++i)
		cpu.memory->at(k) = str[i];
	cpu.memory->at(k) = '\0';
	return this->READ_STR.cycle;
}



