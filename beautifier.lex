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

int brace_depth;
%}

%option noyywrap

INCLUDE      #include
IFNDEF       #ifndef
ENDIF        #endif
RETURN       return

SPACE        [ ]
SPACES       {SPACE}+

LBRACE       "{"
RBRACE       "}"
STREAM       "<""<"

%x MAIN LIBINC HEADINC

%%

 /* if a library doesn't have an include guard, */
 /* add an include guard, otherwise do nothing */

 /* check whether include guard is in position */
{IFNDEF} {
    BEGIN HEADINC; 
    printf("%s", yytext);
}
<HEADINC>{INCLUDE} {
    BEGIN 0; 
    printf("%s", yytext);
}

 /* if missing include guard, add one */
<INITIAL>{INCLUDE}{SPACES}\< {  
    BEGIN LIBINC;
    buffer_ptr = buffer;
}
<LIBINC>\> {
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
 /* assume no overbound error */
    *buffer_ptr++ = yytext[0];
}


 /* return 0 -> return EXIT_SUCCESS */
 /* return (not 0) -> return EXIT_FAILURE */
 /* only make conversion for main function */ 
int{SPACES}main { 
    BEGIN MAIN; 
    brace_depth = 0;
    printf("%s", yytext);
}

 /* count depth of braces */
 /* only make conversion for main function */ 
<MAIN>{LBRACE} { 
    brace_depth++;
    printf("%s", yytext);
}
<MAIN>{RBRACE} { 
    brace_depth--;
    if (0 == brace_depth) {
        BEGIN 0;
    }  
    printf("%s", yytext);
}

<MAIN>{RETURN}{SPACES}0 {
    printf("return EXIT_SUCCESS");
}
<MAIN>{RETURN}{SPACES}-?[^0] {
    printf("return EXIT_FAILURE");
}

 /*
{STREAM} {
    printf("%s", "yyy");
}
\"{SPACES}\<\<{SPACES} {
    printf("match"); 
}
 */



 /* return 0 at EOF */
<<EOF>> { return 0; }

%%

