%{
#include "parser.tab.h"
%}

%%
// Define tokens
#define WHITESPACE " \t\n"
[ \t\n]+                          ;  // Ignore whitespace
"#include"                       { return PREPROCESSOR; }
"int" | "float" | "char"        { return KEYWORD; }
"printf"                        { return FUNCTION; }
[0-9]+                           { yylval.str = strdup(yytext); return VALUE; }
\"[^\"]*\"                       { yylval.str = strdup(yytext); return STRING_LITERAL; }
[a-zA-Z_][a-zA-Z0-9_]*          { yylval.str = strdup(yytext); return IDENTIFIER; }
"="                              { return ASSIGNMENT_OPERATOR; }
"++"                             { return INCREMENT_OPERATOR; }
"--"                             { return DECREMENT_OPERATOR; }
"("                              { return OPEN_PARENTHESIS; }
")"                              { return CLOSE_PARENTHESIS; }
"{"                              { return OPEN_BRACE; }
"}"                              { return CLOSE_BRACE; }
","                              { return COMMA; }
";"                              { return TERMINATOR_SYMBOL; }
"for"                            { return FOR; }
"while"                          { return WHILE; }
"do"                             { return DO; }
"==" | "<" | ">" | "<=" | ">="  { yylval.str = strdup(yytext); return SPECIAL_SYMBOL; }
"=" | "+" | "-" | "*" | "/"     { yylval.str = strdup(yytext); return UNKNOWN_SYMBOL; }
.                                { /* Ignore unrecognized characters */ }
%%

int yywrap() {
    return 1;
}
