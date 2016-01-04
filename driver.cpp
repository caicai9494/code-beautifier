#include <cstdio>
#include <iostream>
#include <string>
#include <cctype>
#include <algorithm>

extern FILE* yyin;

extern "C" {
    int yylex(void); /* prototype for the lexing function */
}

int main(int argc, char* argv[]) {
    int tok;
    if (argc != 2) {
        fprintf(stderr, "usage: a.out FILENAME\n");
        return 1;
    }

    std::string file = argv[1];

    // convert file name(w/o extension) to UPPERCASE
    std::string filename = file.substr(0, file.find_first_of("."));
    std::transform(filename.begin(), 
		   filename.end(),
		   filename.begin(),
		   ::toupper); 

    // cout include guard
    std::cout << "#ifndef INCLUDED_" << filename << '\n';
    std::cout << "#define INCLUDED_" << filename << '\n';
    
    yyin = fopen(argv[1], "r");
    for (;;) {
        tok = yylex();
	// return 0 at EOF
	if (0 == tok) { break; }
    }

    //std::cout << "#endif\n";
    fclose(yyin);
    return 0;
}
