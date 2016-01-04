#include <stdio.h>

extern FILE* yyin;

char* filename;

int yylex(void); /* prototype for the lexing function */

int main(int argc, char** argv) {
    int tok;
    if (argc != 2) {
        fprintf(stderr, "usage: a.out filename\n");
        return 1;
    }
    
    filename = argv[1];
    yyin = fopen(filename, "r");
    for (;;) {
        tok = yylex();

	if (0 == tok) { break; }
    }
    return 0;
}
