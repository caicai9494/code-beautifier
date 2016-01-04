%{
#include <stdio.h>
#include <string.h>
#define MAX_LEN 128 

extern char* filename;

char buffer[MAX_LEN + 1];
char* buffer_ptr;

void all_upper(char* to, const char* src)
{
    while((*to = toupper(*src)) != '\0') {
        to++;
        src++;
    }
} 

int yywrap(void) 
{
    return 1;
}
%}

INCLUDE      #include
STD          std


%s INC

%%

{INCLUDE}" "+"<"	{  
    BEGIN(INC);
    buffer_ptr = buffer;
}
<INC>">"  {
    *buffer_ptr = '\0';
    BEGIN(INITIAL);

    char prefix[] = "INCLUDED_PKG_";

    char copy[MAX_LEN + 1];
    all_upper(copy, buffer);

    printf("debug %s\n", filename);

    printf("#ifndef %s%s\n", prefix, copy);
    printf("#define %s%s\n", prefix, copy);
    printf("#endif\n");
}
<INC>.  {
    *buffer_ptr++ = yytext[0];
}

{STD}/[^a-zA-Z]           { printf("bsl"); }


<<EOF>> { return 0; }

%%

