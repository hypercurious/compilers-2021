%{
#define YYERROR_VERBOSE 1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ST.h"

int size;
symrec* symbol_table;

extern int yylex();
extern int yyparse();
extern int yylineno();

extern FILE* yyin;
extern FILE* yyout;

void yyerror(const char* s);
void install(char *sym_name);
void context_check(char *sym_name);

%}

%union{
    char* sval;
}

%token NUMBER
%token OPERATION
%token COMPOPERATION
%token LOGICOPERATION
%token <sval> TEXT
%token <sval> VARNAME
%token <sval> ARRAY
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

assignment: VARNAME EQUAL value SEMI nl { context_check($1); }
;

arguments: LPAR lval RPAR
;

lval: value COMMA lval
    | value
;

value: value OPERATION value
     | value complogoperation value
     | LPAR value RPAR
     | VARNAME arguments { context_check($1); }
     | ARRAY { context_check($1); }
     | NUMBER
     | VARNAME { context_check($1); }
;

program: PROGRAM VARNAME nl { install($2); }
;

lvar: VARNAME COMMA lvar { install($1); }
    | ARRAY COMMA lvar { install($1); }
    | VARNAME { install($1); }
    | ARRAY { install($1); }
;

vartypes: CHAR
        | INTEGER
;

vars: vartypes lvar SEMI nl vars
    | vartypes lvar SEMI nl
;

vardecl: VARS nl vars
;

return: RETURN VARNAME SEMI { context_check($2); }
      | RETURN NUMBER SEMI
;

lfunc: function lfunc
     | function
;

function: FUNCTION VARNAME LPAR lvar RPAR nl vardecl instructions return nl END_FUNCTION nl { install($2); }
        | FUNCTION VARNAME LPAR lvar RPAR nl instructions return nl END_FUNCTION nl { install($2); }
;

complogoperation: COMPOPERATION
                | LOGICOPERATION
;

statement: value complogoperation statement
         | value
;

while: WHILE statement nl breakinstr ENDWHILE
;

for: FOR VARNAME COLON EQUAL NUMBER TO NUMBER STEP NUMBER nl breakinstr ENDFOR { context_check($2); }
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

plvar: VARNAME COMMA plvar { context_check($1); }
    | ARRAY COMMA plvar { context_check($1); }
    | VARNAME { context_check($1); }
    | ARRAY { context_check($1); }
;

print: PRINT LPAR TEXT COMMA plvar RPAR SEMI nl
     | PRINT LPAR TEXT RPAR SEMI nl { printf("%s", $3); }
;

break: BREAK SEMI nl
;

lstruct: struct lstruct
       | struct
;

struct: TYPEDEF STRUCT VARNAME nl vardecl VARNAME ENDSTRUCT nl { if(strcmp($3,$6)==0) install($3); else printf("Error, TYPEDEF name %s is not the same with TYPEDEF name %s\n", $3, $6); }
      | STRUCT VARNAME nl vardecl ENDSTRUCT nl { install($2); }
;

%%
int main(int argc, char* argv[]){
    #ifdef YYDEBUG
        yydebug = 1;
    #endif

    size = 0;
    symbol_table = (symrec*) malloc(1 * sizeof(symrec));

    yyin = fopen(argv[1], "r");
    yyout = stdout;
    fprintf(yyout, "HELLO\n");
    yyparse();
    fprintf(yyout, "BYE\n");
    
    printf("\n[SYMBOL TABLE]\n");
    for (int i = 0; i < size; i++) {
        printf("Variable %d: %s\n", i, symbol_table[i].name);  
    }

    return 0;
}

void yyerror(const char *s){
    fprintf(stderr, " %s\n", s);
}

void install(char* sym_name){
    int s;
    s = getsym(sym_name);
    if(s == 0){
        putsym(sym_name);
        printf("Symbol name: %s \n", sym_name);
    }
    else {
        printf("%s is already defined \nExiting...", sym_name);
        exit(-1);
    }
}

void context_check(char* sym_name){
    if(getsym(sym_name)==0){
        printf("%s is an undeclared variable\nExiting...", sym_name);
        exit(-1);
    }
}
