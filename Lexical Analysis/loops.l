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

// Function to print tokens side by side
void print_tokens_side_by_side() {
    int max_rows = 0;
    
    // Determine the maximum number of rows required
    max_rows = keyword_count > identifier_count ? keyword_count : identifier_count;
    max_rows = max_rows > operator_count ? max_rows : operator_count;
    max_rows = max_rows > punctuation_count ? max_rows : punctuation_count;
    max_rows = max_rows > constant_count ? max_rows : constant_count;
    max_rows = max_rows > string_count ? max_rows : string_count;

    printf("\n+----------------+-----------------+-----------------+-----------------+----------------+-----------------+\n");
    printf("|   Keywords     |   Identifiers   |    Constants    |    Strings      |    Operators   |   Punctuation   |\n");
    printf("+----------------+-----------------+-----------------+-----------------+----------------+-----------------+\n");
    
    for (int i = 0; i < max_rows; i++) {
        printf("| %-14s | %-15s | %-15s | %-15s | %-14s | %-15s |\n", 
               i < keyword_count ? keywords[i] : " ",
               i < identifier_count ? identifiers[i] : " ",
               i < constant_count ? constants[i] : " ",
               i < string_count ? strings[i] : " ",
               i < operator_count ? operators[i] : " ",
               i < punctuation_count ? punctuations[i] : " ");
    }
    
    printf("+----------------+-----------------+-----------------+-----------------+----------------+-----------------+\n");
    printf("| %-14d | %-15d | %-15d | %-15d | %-14d | %-15d |\n", 
           keyword_count, identifier_count, constant_count, string_count, operator_count, punctuation_count);
    printf("+----------------+-----------------+-----------------+-----------------+----------------+-----------------+\n");
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

. { /* Ignore any unknown characters for now */ }

%%

// End of lexer

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        exit(1);
    }

    FILE *inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        perror("Error opening file");
        exit(1);
    }

    yyin = inputFile;
    yylex(); // Start the lexical analysis
    fclose(inputFile);

    printf("=== Lexical Analysis Results ===\n");
    print_tokens_side_by_side(); // Print all tokens side by side
    printf("===============================\n");

    return 0;
}
