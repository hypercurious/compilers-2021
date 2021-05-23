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
%token NUMBER
%token OPERATION
%token NL
%token LPAR
%token RPAR
%token COMMA
%token SEMI
%token EQUAL
%token VARS
%token CHAR
%token INTEGER
%token ARRAY
%token PROGRAM
%token FUNCTION
%token RETURN
%token END_FUNCTION
%token STARTMAIN
%token ENDMAIN

%%

main: program lfunc NL STARTMAIN NL VARS NL vardecl assignment ENDMAIN NL
    | program lfunc NL STARTMAIN NL assignment ENDMAIN NL
    | program lfunc NL STARTMAIN NL lvar ENDMAIN NL
    | program
;

assignment: VARNAME EQUAL value SEMI NL
;

arguments: LPAR lval RPAR
;

lval: value COMMA lval
    | value
;

value: value OPERATION value
     | LPAR value RPAR
     | VARNAME arguments
     | ARRAY
     | NUMBER
     | VARNAME
;

program: PROGRAM VARNAME NL
;

lvar: VARNAME COMMA lvar
    | ARRAY COMMA lvar
    | VARNAME
    | ARRAY
;

lfunc: function lfunc
     | function
;

vardecl: CHAR lvar SEMI NL vardecl
    |   INTEGER lvar SEMI NL vardecl
    |   CHAR lvar SEMI NL
    |   INTEGER lvar SEMI NL
;

return: RETURN VARNAME
      | RETURN NUMBER
;

function: FUNCTION VARNAME LPAR lvar RPAR NL VARS NL vardecl return NL END_FUNCTION
        | FUNCTION VARNAME LPAR lvar RPAR NL return NL END_FUNCTION
;

%%
int main(int argc, char* argv[]){
    #ifdef YYDEBUG
        yydebug = 1;
    #endif

    yyin = fopen(argv[1], "r");
    yyout = stdout;
    fprintf(yyout, "HELLO\n");
    yyparse();
    fprintf(yyout, "BYE\n");

    return 0;
}

void yyerror(const char *s){
    printf("%s\n", s);
}
