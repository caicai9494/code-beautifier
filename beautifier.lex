%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX_LEN 128 

char buffer[MAX_LEN + 1];
char* buffer_ptr;

void all_upper(char* to, const char* src)
{
    while((*to = toupper(*src)) != '\0') {
        to++;
        src++;
    }
} 
%}

%option noyywrap

INCLUDE      #include
IFNDEF       #ifndef
ENDIF        #endif
RETURN       return

SPACE        [ ]
SPACES       {SPACE}+

%s HEADINC LIBINC

%%

{INCLUDE}{SPACES}\<	{  
    BEGIN LIBINC;
    buffer_ptr = buffer;
}
<LIBINC>{SPACES}\> {
    BEGIN 0;
    *buffer_ptr = '\0';

    char prefix[] = "INCLUDED_PKG_";

    char copy[MAX_LEN + 1];
    all_upper(copy, buffer);

    printf("#ifndef %s%s\n", prefix, copy);
    printf("#define %s%s\n", prefix, copy);
    printf("#endif\n");
}

<LIBINC>.  {
    *buffer_ptr++ = yytext[0];
}


<<EOF>> { return 0; }

%%

