%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100

typedef struct {
    char name[50];
    char type[50];  // Add type information if needed
} Symbol;

Symbol symbol_table[MAX_SYMBOLS];
int symbol_count = 0;

void add_symbol(const char *name, const char *type) {
    if (symbol_count < MAX_SYMBOLS) {
        strcpy(symbol_table[symbol_count].name, name);
        strcpy(symbol_table[symbol_count].type, type);
        symbol_count++;
    }
}

void print_symbol_table() {
    printf("\n=== Symbol Table ===\n");
    printf("Name\tType\n");
    printf("------------------\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%s\t%s\n", symbol_table[i].name, symbol_table[i].type);
    }
}

extern int yylex(); // Declare yylex
void yyerror(const char *s); // Declare yyerror

%}

%union {
    char* str;  // For identifiers and types
    int intval; // For numeric constants
}

%token <str> KEYWORD IDENTIFIER CONSTANT STRING LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA ASSIGN
%start program

%%

// Grammar rules
program:
    declarations
    ;

declarations:
    declarations declaration
    | declaration
    ;

declaration:
    KEYWORD IDENTIFIER SEMICOLON {
        add_symbol($2, "int");  // Assuming all declarations are int for now
    }
    ;

%%

// Error handling
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Starting syntax analysis...\n");
    yyparse();
    print_symbol_table();
    return 0;
}
