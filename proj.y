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

%token NUMBER
%token OPERATION
%token COMPOPERATION
%token LOGICOPERATION
%token TEXT
%token <sval> VARNAME
%token NL
%token LPAR
%token RPAR
%token COMMA
%token SEMI
%token EQUAL
%token COLON
%token VARS
%token CHAR
%token INTEGER
%token ARRAY
%token WHILE
%token ENDWHILE
%token FOR
%token TO
%token STEP
%token ENDFOR
%token IF
%token THEN
%token ELSEIF
%token ELSE
%token ENDIF
%token SWITCH
%token CASE
%token DEFAULT 
%token ENDSWITCH
%token PRINT
%token PROGRAM
%token FUNCTION
%token RETURN
%token END_FUNCTION
%token STARTMAIN
%token ENDMAIN

%%

main: program lfunc STARTMAIN NL VARS NL vardecl commands ENDMAIN NL
    | program lfunc STARTMAIN NL commands ENDMAIN NL
    | program lfunc STARTMAIN NL lvar ENDMAIN NL
    | program
;

commands: assignment commands
        | loop commands
        | conditional commands
        | print commands
        | assignment
        | loop
        | conditional
        | print
;

assignment: VARNAME EQUAL value SEMI NL
;

arguments: LPAR lval RPAR
;

lval: value COMMA lval
    | value
;

value: value OPERATION value
     | value complogoperation value
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

function: FUNCTION VARNAME LPAR lvar RPAR NL VARS NL vardecl return NL END_FUNCTION NL
        | FUNCTION VARNAME LPAR lvar RPAR NL return NL END_FUNCTION NL
;

complogoperation: COMPOPERATION
                | LOGICOPERATION
;

statement: value complogoperation statement
         | value
;

while: WHILE statement NL commands ENDWHILE
;

for: FOR VARNAME COLON EQUAL NUMBER TO NUMBER STEP NUMBER NL commands ENDFOR
;

loop: for NL
    | while NL
;

lif: ELSEIF statement NL commands ELSE NL commands    
   | ELSEIF statement NL commands lif
   | ELSEIF statement NL commands
;

if: IF statement THEN NL commands lif ENDIF
  | IF statement THEN NL commands ENDIF
;

lcase: CASE value COLON NL commands DEFAULT COLON NL commands
     | CASE value COLON NL commands lcase
     | CASE value COLON NL commands
;

switch: SWITCH value NL lcase ENDSWITCH
;

conditional: if NL
          |  switch NL
;

print: PRINT LPAR TEXT COMMA lvar RPAR SEMI NL
     | PRINT LPAR TEXT RPAR SEMI NL
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
