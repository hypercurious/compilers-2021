%option noyywrap
%option yylineno

%{
#include "proj.tab.h"
#define YY_DECL int yylex()

//METAVLHTES KAI SUNARTHSEIS 

%}

%option noyywrap
%option yylineno

varname [_a-zA-Z][a-zA-Z0-9]*

%

{varname} { yyval.sval = yytext) return VARNAME; }
