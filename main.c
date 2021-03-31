#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <proj.tab.h>

extern int yylex();
extern int yyparse();
extern int yylineno();

extern FILE* yyin;
extern FILE* yyout;

int main(){
    #ifdef YYDEBUG
        yydebug = 1;
    #endif

    yyin = fopen(argv[1], 'r');
    yyout = stdout;
    fprintf(yyout, "HELLO\n");
    yyparse();
    fprintf(yyout, "BYE\n");

    return 0;
}
