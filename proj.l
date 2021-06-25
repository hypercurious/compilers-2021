%option noyywrap
%option yylineno

%{
#include "proj.tab.h"
#define YY_DECL int yylex()

//METAVLHTES KAI SUNARTHSEIS 

%}

%option noyywrap
%option yylineno

%x COMMENTS

number [0-9]+
operation [\+\-\^\*\/]
compoperation [\>\<]
text \"(\\.|[^\\"])*\"
comment "%".*
varname [_a-zA-Z][a-zA-Z0-9]*
array [_a-zA-Z][a-zA-Z0-9]*\[[0-9]*\]

%%

"\n" { return NL; }
"," { return COMMA; }
"(" { return LPAR; }
")" { return RPAR; }
";" { return SEMI; }
"=" { return EQUAL; }
":" { return COLON; }
"==" { return COMPOPERATION; }
"!=" { return COMPOPERATION; }
"AND" { return LOGICOPERATION; }
"OR" { return LOGICOPERATION; }
"VARS" { return VARS; }
"CHAR" { return CHAR; }
"INTEGER" { return INTEGER; }
"WHILE" { return WHILE; }
"ENDWHILE" { return ENDWHILE; }
"FOR" { return FOR; }
"TO" { return TO;}
"STEP" { return STEP; }
"ENDFOR" { return ENDFOR; }
"IF" { return IF; }
"THEN" { return THEN; }
"ELSEIF" { return ELSEIF; }
"ELSE" { return ELSE; }
"ENDIF" { return ENDIF; }
"SWITCH" { return SWITCH; }
"CASE" { return CASE; }
"DEFAULT" { return DEFAULT; }
"ENDSWITCH" { return ENDSWITCH; }
"PRINT" { return PRINT; }
"BREAK" { return BREAK; }
"PROGRAM" { return PROGRAM; }
"TYPEDEF" { return TYPEDEF; }
"STRUCT" { return STRUCT; }
"ENDSTRUCT" { return  ENDSTRUCT; }
"FUNCTION" { return FUNCTION; }
"RETURN" { return RETURN; }
"END_FUNCTION" { return END_FUNCTION; }
"STARTMAIN" { return STARTMAIN; }
"ENDMAIN" { return ENDMAIN; }
{number} { return NUMBER; }
{operation} { return OPERATION; }
{compoperation} { return COMPOPERATION; }
{text} { yylval.sval = (char*) strdup(yytext); return TEXT; }
{comment} {  } //ignore inline comments
{varname} { yylval.sval = (char*) strdup(yytext); return VARNAME; }
{array} { for (int i = 0; i < yyleng; i++) { if(yytext[i] == '[') {yytext[i] = '\0'; } } yylval.sval = strdup(yytext); return ARRAY; }

"/*"              { BEGIN(COMMENTS); } //ignore block comments using start states
<COMMENTS>"*/"    { BEGIN(INITIAL); }
<COMMENTS>.       {  }
<COMMENTS>\n      {  }
