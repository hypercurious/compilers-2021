%option noyywrap
%option yylineno

%{
#include "proj.tab.h"
#define YY_DECL int yylex()

//METAVLHTES KAI SUNARTHSEIS 

%}

%option noyywrap
%option yylineno

number [0-9]+
operation [\+\-\^\*\/]
varname [_a-zA-Z][a-zA-Z0-9]*
array [_a-zA-Z][a-zA-Z0-9]*\[[0-9]*\]

%%

"\n" { return NL; }
"," { return COMMA; }
"(" { return LPAR; }
")" { return RPAR; }
";" { return SEMI; }
"=" { return EQUAL; }
"VARS" { return VARS; }
"CHAR" { return CHAR; }
"INTEGER" { return INTEGER; }
"PROGRAM" { return PROGRAM; }
"FUNCTION" { return FUNCTION; }
"RETURN" { return RETURN; }
"END_FUNCTION" { return END_FUNCTION; }
"STARTMAIN" { return STARTMAIN; }
"ENDMAIN" { return ENDMAIN; }
{number} { return NUMBER; }
{operation} { return OPERATION; }
{varname} { yylval.sval = yytext; return VARNAME; }
{array} { return ARRAY; }
