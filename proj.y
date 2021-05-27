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
%token BREAK
%token PROGRAM
%token TYPEDEF
%token STRUCT
%token ENDSTRUCT
%token FUNCTION
%token RETURN
%token END_FUNCTION
%token STARTMAIN
%token ENDMAIN

%%

main: program lstruct lfunc STARTMAIN nl vardecl instructions ENDMAIN nl
    | program lstruct lfunc STARTMAIN nl instructions ENDMAIN nl
    | program lstruct STARTMAIN nl vardecl instructions ENDMAIN nl
    | program lstruct STARTMAIN nl instructions ENDMAIN nl
    | program lfunc STARTMAIN nl vardecl instructions ENDMAIN nl
    | program lfunc STARTMAIN nl instructions ENDMAIN nl
    | program STARTMAIN nl vardecl instructions ENDMAIN nl
    | program STARTMAIN nl instructions ENDMAIN nl
;

nl: NL nl
  | NL
;

breakinstr: instructions breakinstr
          | break breakinstr
          | instructions
          | break;
;

instructions: assignment instructions
            | loop instructions
            | conditional instructions
            | print instructions
            | assignment
            | loop
            | conditional
            | print
;

assignment: VARNAME EQUAL value SEMI nl
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

program: PROGRAM VARNAME nl
;

lvar: VARNAME COMMA lvar
    | ARRAY COMMA lvar
    | VARNAME
    | ARRAY
;

vars: CHAR lvar SEMI nl vars
    | INTEGER lvar SEMI nl vars
    | CHAR lvar SEMI nl
    | INTEGER lvar SEMI nl
;

vardecl: VARS nl vars
;

return: RETURN VARNAME SEMI
      | RETURN NUMBER SEMI
;

lfunc: function lfunc
     | function
;

function: FUNCTION VARNAME LPAR lvar RPAR nl vardecl instructions return nl END_FUNCTION nl
        | FUNCTION VARNAME LPAR lvar RPAR nl instructions return nl END_FUNCTION nl
;

complogoperation: COMPOPERATION
                | LOGICOPERATION
;

statement: value complogoperation statement
         | value
;

while: WHILE statement nl breakinstr ENDWHILE
;

for: FOR VARNAME COLON EQUAL NUMBER TO NUMBER STEP NUMBER nl breakinstr ENDFOR
;

loop: for nl
    | while nl
;

lif: ELSEIF statement nl breakinstr ELSE nl breakinstr
   | ELSEIF statement nl breakinstr lif
   | ELSEIF statement nl breakinstr
;

if: IF statement THEN nl breakinstr lif ENDIF
  | IF statement THEN nl breakinstr ENDIF
;

lcase: CASE value COLON nl breakinstr DEFAULT COLON nl breakinstr
     | CASE value COLON nl breakinstr lcase
     | CASE value COLON nl breakinstr
;

switch: SWITCH value nl lcase ENDSWITCH
;

conditional: if nl
          |  switch nl
;

print: PRINT LPAR TEXT COMMA lvar RPAR SEMI nl
     | PRINT LPAR TEXT RPAR SEMI nl
;

break: BREAK SEMI nl
;

lstruct: struct lstruct
       | struct
;

struct: TYPEDEF STRUCT VARNAME nl vardecl VARNAME ENDSTRUCT nl
      | STRUCT VARNAME nl vardecl ENDSTRUCT nl
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
    fprintf(stderr, "%s\n", s);
}
