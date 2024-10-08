%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

// Function to print the summary table
void print_token_summary() {
    printf("\n=== Lexical Analysis Results ===\n");
    printf("+----------------+--------------+-----------+-------------+-----------+-------------+\n");
    printf("| Keywords       | Identifiers  | Constants | Strings     | Operators | Punctuation |\n");
    printf("+----------------+--------------+-----------+-------------+-----------+-------------+\n");

    // Print tokens
    for (int i = 0; i < keyword_count || i < identifier_count || i < constant_count || i < string_count || i < operator_count || i < punctuation_count; i++) {
        printf("| %-14s | %-12s | %-9s | %-11s | %-9s | %-11s |\n",
            i < keyword_count ? keywords[i] : " ",
            i < identifier_count ? identifiers[i] : " ",
            i < constant_count ? constants[i] : " ",
            i < string_count ? strings[i] : " ",
            i < operator_count ? operators[i] : " ",
            i < punctuation_count ? punctuations[i] : " ");
    }

    // Print counts
    printf("+----------------+--------------+-----------+-------------+-----------+-------------+\n");
    printf("| %-14d | %-12d | %-9d | %-11d | %-9d | %-11d |\n",
            keyword_count, identifier_count, constant_count, string_count, operator_count, punctuation_count);
    printf("+----------------+--------------+-----------+-------------+-----------+-------------+\n");
    printf("\n\n\n");
    printf("\nToken Summary:\n");
    printf("------------------------------\n");
    printf("Keyword Count:     %d\n", keyword_count);
    printf("Identifier Count:  %d\n", identifier_count);
    printf("Operator Count:    %d\n", operator_count);
    printf("Punctuation Count: %d\n", punctuation_count);
    printf("Constant Count:    %d\n", constant_count);
    printf("String Count:      %d\n", string_count);
    printf("\n\n\n");
}
%}

%%



"for"|"while"|"do"|"int"|"float"|"double"|"char" {
    add_token(keywords, &keyword_count, yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    add_token(identifiers, &identifier_count, yytext);
}

"(" { add_token(punctuations, &punctuation_count, yytext); }
")" { add_token(punctuations, &punctuation_count, yytext); }
"{" { add_token(punctuations, &punctuation_count, yytext); }
"}" { add_token(punctuations, &punctuation_count, yytext); }
";" { add_token(punctuations, &punctuation_count, yytext); }
"," { add_token(punctuations, &punctuation_count, yytext); }

"="  { add_token(operators, &operator_count, yytext); }
"<"  { add_token(operators, &operator_count, yytext); }
">"  { add_token(operators, &operator_count, yytext); }
"<=" { add_token(operators, &operator_count, yytext); }
">=" { add_token(operators, &operator_count, yytext); }
"==" { add_token(operators, &operator_count, yytext); }
"!=" { add_token(operators, &operator_count, yytext); }
"++" { add_token(operators, &operator_count, yytext); }
"--" { add_token(operators, &operator_count, yytext); }
"+"  { add_token(operators, &operator_count, yytext); }
"-"  { add_token(operators, &operator_count, yytext); }
"*"  { add_token(operators, &operator_count, yytext); }
"/"  { add_token(operators, &operator_count, yytext); }
"%"  { add_token(operators, &operator_count, yytext); }

[0-9]+ {
    add_token(constants, &constant_count, yytext);
}

\"[^\"]*\" {
    add_token(strings, &string_count, yytext);
}

[ \t\n]+ ;  

. { 
    fprintf(stderr, "Error: Unknown character '%s'\n", yytext); 
}

%%

// Define the function to handle the tokens
int yywrap() {
    return 1;
}

// Declare extern for yyin
extern FILE *yyin;
