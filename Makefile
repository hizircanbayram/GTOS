all:compile

compile: compile.c
	g++ -c -std=c++11 ~/GTOS/GTOS/main.cpp -o main.o
	g++ -c -std=c++11 ~/GTOS/GTOS/gtuos.cpp -o gtuos.o
	g++ -c -std=c++11 ~/GTOS/Intel_8080_Emulator/8080emu.cpp -o 8080emu.o
	g++ -o gtos8080 main.o gtuos.o 8080emu.o
	rm *.o
compile.c: 
	g++ -c -std=c++11 ~/GTOS/GTOS/main.cpp
	g++ -c -std=c++11 ~/GTOS/GTOS/gtuos.cpp
	g++ -c -std=c++11 ~/GTOS/Intel_8080_Emulator/8080emu.cpp

clean:
	rm *.o exe

