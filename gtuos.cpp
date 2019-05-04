#include <iostream>
#include <fstream>
#include <ostream>
#include "gtuos.h"
#include "memory.h"
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



uint64_t GTUOS::load_exec(CPU8080 & cpu) {
	uint16_t address_bc = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	uint16_t address_hl = (((uint16_t)cpu.state->h) << 8) | cpu.state->l;
    char file_name[1024] = { 0 };
    int i;
    for (i = 0; (int)cpu.memory->at(address_bc + i) != 0; ++i) 
        file_name[i] = (char) cpu.memory->at(address_bc + i);
    file_name[i] = '\0';
    //printf("file name : %s, address hl : %x\n", file_name, address_hl);
    cpu.ReadFileIntoMemoryAt(file_name, address_hl);    
    return this->LOAD_EXEC.cycle;
}



uint64_t GTUOS::set_quantum(CPU8080 & cpu) {
    cpu.setQuantum(cpu.state->b);
    return this->SET_QUANTUM.cycle;
}



uint64_t GTUOS::process_exit(CPU8080 & cpu) {
    //printf("\n\n\n\n\n\n\n");
    uint16_t proc_cur = ((Memory *)(cpu.memory))->getBaseRegister();
    uint16_t proc_start = 20000;
    uint16_t scheduler_addr = 0x04B0;
    uint16_t table_start, table_cur;
    table_start = table_cur = 0x2710;
    //printf("\n%x : %d | %x : %d | %x : %d | %x : %d\n", 0x2710, cpu.memory->physicalAt(0x2710), 0x2910, cpu.memory->physicalAt(0x2910), 0x2B10, cpu.memory->physicalAt(0x2B10), 0x2D10, cpu.memory->physicalAt(0x2D10));
    int k = 0; 
    for (uint16_t i = proc_cur; proc_start != i; i -= 2500)
        ++k;
    for (int i = 0; i < k; ++i)
       table_cur += 0x0200;
    cpu.memory->physicalAt(table_cur) = 0; // DONE
    //printf("%x : %d\n", table_cur, cpu.memory->physicalAt(table_cur));
    //printf("%x : %d | %x : %d | %x : %d | %x : %d\n", 0x2710, cpu.memory->physicalAt(0x2710), 0x2910, cpu.memory->physicalAt(0x2910), 0x2B10, cpu.memory->physicalAt(0x2B10), 0x2D10, cpu.memory->physicalAt(0x2D10));
    ((Memory *)(cpu.memory))->setBaseRegister(0);
    cpu.state->pc = scheduler_addr;
    //printf("\n\n\n\n\n\n\n");
    return this->PROCESS_EXIT.cycle;
}



// Handles system calls and return # of cycles it takes.
uint64_t GTUOS::handleCall(CPU8080 & cpu, int seed_val){
	uint8_t content_A = cpu.state->a; // So as to understand which system call to be executed, register A is checked. System call number is assigned to register A.
	uint64_t cycle = 0; // # of cycles during any of the system calls below is assigned to this variable so that it can be returned.
    int c = 0;
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
    else if (content_A == LOAD_EXEC.number)
        cycle = load_exec(cpu);
    else if (content_A == PROCESS_EXIT.number)
    	cycle = process_exit(cpu);
    else if (content_A == SET_QUANTUM.number)
        cycle = set_quantum(cpu);
    else if (content_A == RAND_INT.number)
        cycle = rand_int(cpu, seed_val);
    else if (content_A == WAIT.number)
        cycle = wait(cpu);
    else if (content_A == SIGNAL.number)
        cycle = signal(cpu);
    else if (content_A == 11) {
        for(int i = 0 ; i < 0x10000 ; ++i){
        // for(int i = 53248 ; i < 53280 ; ++i){
		    if(i % 32 == 0){
	            printf("\n");
	            printf("%d - ",c++);
	    	}
	        printf("%3d ",cpu.memory->physicalAt(i));
        }
        printf("\n");    
    }      

	return cycle;
}



// Generates a random number in the range of 0-255. Puts is into register B.
uint64_t GTUOS::rand_int(CPU8080 & cpu, int seed_val) {
    srand(seed_val);
    uint8_t rand_num = rand() % 256;
    cpu.state->b = rand_num;
    printf("rand : %d\n", cpu.state->b);
    return this->RAND_INT.cycle;
}



uint64_t GTUOS::wait( CPU8080& cpu){
	int semp_val;
	int semp_addr;
    //printf("wait addr : %x\n", ((Memory *) cpu.memory)->getBaseRegister());
	semp_addr = (int) cpu.state->c + 2000; // Semaphore no is kept in register C
	semp_val = (int) cpu.memory->physicalAt(semp_addr);
	if (!semp_val) { // needs to be blocked without busy waiting : context switching
		cpu.onInterrupt();		
		((Memory *)cpu.memory)->setBaseRegister(0);		
	    cpu.state->pc = 0x29;
	}
	else { // simply decreasing the value of semaphore
		--semp_val;
		cpu.memory->physicalAt(semp_addr) = semp_val;
	}	
		
	//cout<<endl<<endl<<"WAIT"<<endl;
	//cout<<"mutex: "<< (int)cpu.memory->physicalAt(2000)<< " full: " <<(int) cpu.memory->physicalAt(2001) << " empty: "<< (int) cpu.memory->physicalAt(2002) << endl;
	//cout<<" semp_addr: "<<semp_addr<<" semo_val: "<<semp_val<<endl<<endl<<endl;
	return this->WAIT.cycle;
}



uint64_t GTUOS::signal(CPU8080 & cpu) {
    uint16_t semp_addr = 2000 + cpu.state->c; // Semaphore no is kept in register C
    int semp_val = (int) cpu.memory->physicalAt(semp_addr);

    if (cpu.state->c == 0) { // if the semaphore is mutex
        if (!semp_val) { 
            ++semp_val;
            cpu.memory->physicalAt(semp_addr) = semp_val;
        }
        else { 
            // do nothing
        }
        
    }
    else if (cpu.state->c == 2 || cpu.state->c == 1) { // if the semaphore is not mutex
        if (semp_val < 50) {
            ++semp_val;
            cpu.memory->physicalAt(semp_addr) = semp_val;
        }
        else { // needs to be blocked without busy waiting : context switching
	     cpu.onInterrupt();		
	     ((Memory *)cpu.memory)->setBaseRegister(0);		
	     cpu.state->pc = 0x29;
        }
    }
    else { // error
        fprintf(stderr, "Wrong semaphore index\n");
    }

    //cout << endl << endl << "SIGNAL" << endl;
    //cout << "mutex: " << (int) cpu.memory->physicalAt(2000) << " full: " << (int) cpu.memory->physicalAt(2001) << " empty: " << (int) cpu.memory->physicalAt(2002) << endl;
    //cout << " semp_addr: " << semp_addr << " semp_val: " << semp_val << endl << endl << endl;

    //printf("val : %d\n", cpu.memory->at(0x7530));
    return this->SIGNAL.cycle;
}



// Calls PRINT_B system call. Prints the contents of register B the screen as decimal.
uint64_t GTUOS::call_print_b(const CPU8080 & cpu) {
	//oFile << int(cpu.state->b) << " ";	
    cout << int(cpu.state->b) << " ";
	return this->PRINT_B.cycle;
}



// Calls PRINT_MEM system call. Prints the of contents of memory pointed by register  B and register C as decimal.
uint64_t GTUOS::call_print_mem(const CPU8080 & cpu) {
	//uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	//oFile << (int)cpu.memory->at(address) << endl;	
    uint16_t addr = 2003 + cpu.state->b;
    //uint16_t proc_cur = ((Memory *)(cpu.memory))->getBaseRegister();
    //cout << "val : " << "(" << (int) cpu.memory->physicalAt(addr) << ")" << endl;
    cout << (int) cpu.memory->physicalAt(addr) << endl;
	return this->PRINT_MEM.cycle;
}



// Calls PRINT_STR system call. Prints the null terminated string at the address pointed by register B and register C.
uint64_t GTUOS::call_print_str(const CPU8080 & cpu) {
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	int local_cycle_num = 0;
    for(uint16_t i = address; cpu.memory->at(i) != '\0';  ++i){
        //oFile << char(cpu.memory->at(i));
        cout << char(cpu.memory->at(i));
		local_cycle_num++;
    }	
	return this->PRINT_STR.cycle * local_cycle_num;
}



// Calls READ_B system call. Reads an integer from the keyboard and puts it in to Register B.
uint64_t GTUOS::call_read_b(const CPU8080 & cpu) {
	int content;
    //printf("cm : %d\n", cpu.memory->physicalAt(0xC350));
	cout << "Enter the number that is written to register B ranging from 0 to 255 : (If it is for Collatz, less than 26) ";
	//inFile >> content;
    cin >> content;
	cout << "The number is " << content << endl;
	if ((content < 0) || (content > 255)) {
		cout << "The number isn't in the valid range. 0 is assigned. " << endl;
		content = 0;
	}
	cpu.state->b = content;
	return this->READ_B.cycle;
}



// Calls READ_MEM system call. Reads an integer from the keyboard and puts it at the memory location pointed by register B and register C.
uint64_t GTUOS::call_read_mem(const CPU8080 & cpu) {
	uint8_t addr_ind, addr_val;
    uint16_t addr_cur, addr_default = 2003;
    
    addr_val = cpu.state->b; // keeps the value
    addr_ind = cpu.state->c; // keeps the indice of memory in which a value will be written
    addr_cur = addr_default + addr_ind; 
	cpu.memory->physicalAt(addr_cur) = addr_val;
	return this->READ_MEM.cycle;
}



// Calls READ_STR system call. Reads the null terminated string from the keyboard and puts it at the memory location pointed by register B and register C.
uint64_t GTUOS::call_read_str(const CPU8080 & cpu) {
	string str = "";
	cout << "Enter a string that will be written into the address pointed by register B anc register C : ";
	//getline(inFile, str);
    getline(cin, str);
	uint16_t address = (((uint16_t)cpu.state->b) << 8) | cpu.state->c;
	int k = address;
	int local_cycle_num = 0;
	for (size_t i = 0; i < str.length(); ++k, ++i) {
		++local_cycle_num;
		cpu.memory->at(k) = str[i];
	}
	cpu.memory->at(k) = '\0';
	return this->READ_STR.cycle;
}
