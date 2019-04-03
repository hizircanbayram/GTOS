all: compile

compile: 8080emu.o gtuos.o memory.o main.o
	g++ 8080emu.o gtuos.o main.o memory.o -o gtos8080
	rm *.o
main.o: main.cpp
	g++ -c -std=c++11 main.cpp

8080emu.o: 8080emu.cpp
	g++ -c -std=c++11 8080emu.cpp

gtuos.o: gtuos.cpp
	g++ -c -std=c++11 gtuos.cpp
	
memory.o: memory.cpp
	g++ -c -std=c++11 memory.cpp


clean:
	rm *.o gtos8080
	clear

