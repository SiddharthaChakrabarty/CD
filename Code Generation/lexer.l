%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
int yylineno = 1; 
%}

%%

\n                              { yylineno++; } 
"for"                           { return FOR; } 
"while"                         { return WHILE; }
"do"                            { return DO; }
[#]                             { return PREPROCESSOR; }
"include"                       { return PREPROCESSOR_KEYWORD; }
"stdio.h"                       { return HEADER_FILE; }
"main"                          { return FUNCTION; }
"printf"                        { return FUNCTION; }
"void"|"int"                    { return KEYWORD; }
[a-zA-Z_][a-zA-Z0-9_]*          { yylval.str = strdup(yytext); return IDENTIFIER; }       
[0-9]+                          { yylval.str = strdup(yytext); return VALUE; }
[{]                             { return OPEN_BRACE; }
[}]                             { return CLOSE_BRACE; }
[(]                             { return OPEN_PARENTHESIS; }
[)]                             { return CLOSE_PARENTHESIS; }
[<|>]                           { return SPECIAL_SYMBOL; }
"\""([^\"\n]+)"\""              { yylval.str = strdup(yytext); return STRING_LITERAL; }
"="                             { return ASSIGNMENT_OPERATOR; }
"++"                            { return INCREMENT_OPERATOR; }
"--"                            { return DECREMENT_OPERATOR; }
[+]                             { return PLUS_OPERATOR; }
[-]                             { return MINUS_OPERATOR; }
[*]                             { return MULTIPLY_OPERATOR; }
[/]                             { return DIVIDE_OPERATOR; }
[;]                             { return TERMINATOR_SYMBOL; }
[,]                             { return COMMA; }
[ \t]+                        { /* Ignore whitespace */ }
.                               { printf("Unknown symbol: %s\n", yytext); return UNKNOWN_SYMBOL; }
<<EOF>>                         { return 0; }

%%

int yywrap() {
    return 1;
}
