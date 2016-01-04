LEX=beautifier

${LEX}: driver.o lex.yy.o 
	cc -g -o ${LEX} driver.o lex.yy.o 

driver.o: driver.c 
	cc -g -c driver.c

lex.yy.o: lex.yy.c 
	cc -g -c lex.yy.c

lex.yy.c:
	flex ${LEX}.lex

clean: 
	rm -f ${LEX} *.o lex.yy.c 
