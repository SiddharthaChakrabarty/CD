%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"  // Include the Bison header file
%}

#define MAX_TOKENS 100

char keywords[MAX_TOKENS][50];
int keyword_count = 0;

char identifiers[MAX_TOKENS][50];
int identifier_count = 0;

char operators[MAX_TOKENS][50];
int operator_count = 0;

char punctuations[MAX_TOKENS][50];
int punctuation_count = 0;

char constants[MAX_TOKENS][50];
int constant_count = 0;

char strings[MAX_TOKENS][50];
int string_count = 0;

void add_token(char tokens[MAX_TOKENS][50], int *count, char *text) {
    if (*count < MAX_TOKENS) {
        strcpy(tokens[*count], text);
        (*count)++;
    }
}

%}

%%


"for"|"while"|"do"|"int"|"float"|"double"|"char" {
    add_token(keywords, &keyword_count, yytext);
    return KEYWORD;  
}


[a-zA-Z_][a-zA-Z0-9_]* {
    add_token(identifiers, &identifier_count, yytext);
    return IDENTIFIER;  
}

"(" { add_token(punctuations, &punctuation_count, yytext); return LPAREN; }
")" { add_token(punctuations, &punctuation_count, yytext); return RPAREN; }
"{" { add_token(punctuations, &punctuation_count, yytext); return LBRACE; }
"}" { add_token(punctuations, &punctuation_count, yytext); return RBRACE; }
";" { add_token(punctuations, &punctuation_count, yytext); return SEMICOLON; }
"," { add_token(punctuations, &punctuation_count, yytext); return COMMA; }

"="  { add_token(operators, &operator_count, yytext); return ASSIGN; }
"<"  { add_token(operators, &operator_count, yytext); return LESS; }
// ... (add other operators similarly)


[0-9]+ {
    add_token(constants, &constant_count, yytext);
    return CONSTANT;  
}


\"[^\"]*\" {
    add_token(strings, &string_count, yytext);
    return STRING;  
}


[ \t\n]+ ;  


. { 
    fprintf(stderr, "Error: Unknown character '%s'\n", yytext); 
}

%%

int yywrap() {
    return 1;
}


extern FILE *yyin;
