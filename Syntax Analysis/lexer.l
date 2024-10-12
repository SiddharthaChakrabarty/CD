%{
#include "parser.tab.h"
%}

%%

"for"                           { return FOR; }
"while"                         { return WHILE; }
"do"                            { return DO; }
[#]                             { return PREPROCESSOR; }
"include"                       { return PREPROCESSOR_KEYWORD; }
"stdio.h"                       { return HEADER_FILE; }
"main"                          { return FUNCTION; }
"printf"                        { return FUNCTION; }
"void"|"int"                    { return KEYWORD; }
"x"|"y"|"z"                     { return IDENTIFIER; }
[0-9]+                          { return VALUE; }
[{]                             { return OPEN_BRACE; }
[}]                             { return CLOSE_BRACE; }
[(]                             { return OPEN_PARENTHESIS; }
[)]                             { return CLOSE_PARENTHESIS; }
[<|>]                           { return SPECIAL_SYMBOL; }
"\""([^\"\n]+)"\""              { return STRING_LITERAL; }
"="                             { return ASSIGNMENT_OPERATOR; }
"++"                            { return INCREMENT_OPERATOR; }
"--"                            { return DECREMENT_OPERATOR; }
[+]                             { return PLUS_OPERATOR; }
[-]                             { return MINUS_OPERATOR; }
[;]                             { return TERMINATOR_SYMBOL; }
[,]                             { return COMMA; }
[ \t\n]+                        { /* Ignore whitespace */ }
.                               { printf("Unknown symbol: %s\n", yytext); return UNKNOWN_SYMBOL; }
<<EOF>>                         { return 0; }

%%

int yywrap() {
    return 1;
}
