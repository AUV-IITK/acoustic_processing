# MUSIC DOA make file

INC = -I.. -I. ~/eigen-git-mirror

LIB = -lfftw3 -lm


music: main.o MUSIC.o
	g++ MUSIC.o main.o $(LIB) -I ~/eigen-git-mirror -o musicDOA
main.o: MUSIC.o main.cpp headers/MUSIC.h 
	g++ -c main.cpp MUSIC.o $(LIB) -I ~/eigen-git-mirror
MUSIC.o: MUSIC.cpp headers/MUSIC.h
	g++ -c MUSIC.cpp $(LIB) -I ~/eigen-git-mirror

clean:
	rm *.o musicDOA

