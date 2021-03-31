%{
#define YYERROR_VERBOSE 1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern int yylineno();

extern FILE* yyin;
extern FILE* yyout;

void yyerror(const char* s);

//METAVLHTES KAI SUNARTHSEIS

%}

%union{
    int   ival;
    char* sval;
}

%token <sval> VARNAME

%%

basic_rule: program functions main
          | program main
;

%%

void yyerror(const char *s){
    printf("%s\n", s);
}
