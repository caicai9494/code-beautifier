LEX=beautifier
CC=g++
GCC=gcc

${LEX}: driver.o lex.yy.o 
	${CC} -g -o ${LEX} driver.o lex.yy.o 

driver.o: driver.cpp 
	${CC} -g -c driver.cpp

lex.yy.o: lex.yy.c  
	${GCC} -g -c lex.yy.c

lex.yy.c:
	flex ${LEX}.lex

#util.o:
#	${CC} -g -c util.cpp
clean: 
	rm -f ${LEX} *.o lex.yy.c 
