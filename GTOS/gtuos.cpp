#include <iostream>
#include <fstream>
#include <ostream>
#include "gtuos.h"
#include "8080emuCPP.h"


using namespace std;


GTUOS::GTUOS() {
	inFile.open("input.txt");
	oFile.open ("output.txt");
}



GTUOS::~GTUOS() {
	inFile.close();
	oFile.close();
}



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
	oFile << int(cpu.state->b) << " ";	
	return this->PRINT_B.cycle;
}



// Calls PRINT_MEM system call. Prints the of contents of memory pointed by register  B and register C as decimal.
uint64_t GTUOS::call_print_mem(const CPU8080 & cpu) {
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	oFile << (int)cpu.memory->at(address) << endl;	
	return this->PRINT_MEM.cycle;
}



// Calls PRINT_STR system call. Prints the null terminated string at the address pointed by register B and register C.
uint64_t GTUOS::call_print_str(const CPU8080 & cpu) {
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	int local_cycle_num = 0;
    for(uint16_t i = address; cpu.memory->at(i) != '\0';  ++i){
        oFile << char(cpu.memory->at(i));
		local_cycle_num++;
    }	
	return this->PRINT_STR.cycle * local_cycle_num;
}



// Calls READ_B system call. Reads an integer from the keyboard and puts it in to Register B.
uint64_t GTUOS::call_read_b(const CPU8080 & cpu) {
	int content;
	cout << "Enter the number that is written to register B ranging from 0 to 255 : ";
	inFile >> content;
	if ((content < 0) || (content > 255)) {
		cout << "The number isn't in the valid range. 0 is assigned." << endl;
		content = 0;
	}
	cpu.state->b = content;
	return this->READ_B.cycle;
}



// Calls READ_MEM system call. Reads an integer from the keyboard and puts it at the memory location pointed by register B and register C.
uint64_t GTUOS::call_read_mem(const CPU8080 & cpu) {
	uint8_t content;
	cout << "Enter the number that is written to the memory address pointed by register B and register C : ";
	inFile >> content;
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
	string str = "";
	cout << "Enter a string that will be written into the address pointed by register B anc register C : ";
	getline(inFile, str);
	cout << str << endl;
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	cout << (int)cpu.state->b << " " << (int)cpu.state->c << endl;
	int k = address;
	int local_cycle_num = 0;
	for (size_t i = 0; i < str.length(); ++k, ++i) {
		++local_cycle_num;
		cpu.memory->at(k) = str[i];
	}
	cpu.memory->at(k) = '\0';
	return this->READ_STR.cycle;
}


