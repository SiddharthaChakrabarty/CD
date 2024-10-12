%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_IDENTIFIERS 100

typedef enum { TYPE_INT, TYPE_FLOAT, TYPE_STRING, TYPE_UNKNOWN } VarType;

typedef struct {
    char name[50];
    VarType type;
} Symbol;

Symbol symbol_table[MAX_IDENTIFIERS];
int symbol_count = 0;

// Define YYSTYPE to include a string type for identifiers
typedef union {
    int intval;
    float floatval;
    char* strval; // Pointer to a string
} YYSTYPE;

void add_symbol(const char *name, VarType type);
VarType lookup_symbol(const char *name);
void print_symbol_table();
void yyerror(const char *s);
int yylex();
void print_token_summary();  // Declare the token summary function

// Declare yyin as an external file pointer
extern FILE *yyin;

%}

// Redefine YYSTYPE for the parser
%union {
    char* strval; // For identifiers and strings
    int intval;   // For integers (constants)
    float floatval; // For floating point numbers (if needed)
}

%token <strval> KEYWORD IDENTIFIER STRING
%token <intval> CONSTANT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA
%token ASSIGN LT GT LE GE EQ NE INC DEC PLUS MINUS MUL DIV MOD

%start program

// Operator precedence and associativity
%left PLUS MINUS
%left MUL DIV MOD
%right ASSIGN

%%

// Grammar rules
program:
    statements
    ;

statements:
    statements statement
    | statement
    | /* empty */  // Allow for empty statements at the end
    ;

statement:
    expression_statement
    | iteration_statement
    | declaration_statement
    | compound_statement
    ;

expression_statement:
    expression SEMICOLON
    ;

iteration_statement:
    KEYWORD LPAREN expression RPAREN statement
    ;

declaration_statement:
    KEYWORD IDENTIFIER SEMICOLON
    {
        // Add identifier to the symbol table with its type
        VarType type = ($1 == KEYWORD) ? TYPE_INT : TYPE_UNKNOWN; // Assume int for simplicity
        add_symbol($2, type);
        printf("Declared variable: %s of type %d\n", $2, type);
    }
    ;

compound_statement:
    LBRACE statements RBRACE
    ;

expression:
    IDENTIFIER ASSIGN expression
    {
        VarType var_type = lookup_symbol($1);
        if (var_type == TYPE_UNKNOWN) {
            printf("Error: Variable %s not declared.\n", $1);
        }
    }
    | expression PLUS expression
    | expression MINUS expression
    | expression MUL expression
    | expression DIV expression
    | expression MOD expression
    | IDENTIFIER
    {
        VarType var_type = lookup_symbol($1);
        if (var_type == TYPE_UNKNOWN) {
            printf("Error: Variable %s not declared.\n", $1);
        }
    }
    | CONSTANT
    | STRING
    | LPAREN expression RPAREN  // Grouping
    ;

%%

// Function to lookup a symbol in the symbol table
VarType lookup_symbol(const char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].type;
        }
    }
    return TYPE_UNKNOWN;
}

// Function to add a symbol to the symbol table
void add_symbol(const char *name, VarType type) {
    if (symbol_count < MAX_IDENTIFIERS) {
        strcpy(symbol_table[symbol_count].name, name);
        symbol_table[symbol_count].type = type;
        symbol_count++;
    } else {
        printf("Error: Symbol table is full!\n");
    }
}

// Error handling function
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

// Function to print the symbol table
void print_symbol_table() {
    printf("\n=== Symbol Table ===\n");
    printf("+----------------+-----------+\n");
    printf("| Identifier     | Type      |\n");
    printf("+----------------+-----------+\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("| %-14s | %-9d |\n", symbol_table[i].name, symbol_table[i].type);
    }
    printf("+----------------+-----------+\n");
}

// Main function
int main(void) {
    printf("Syntax analysis started.\n");
    
    // Open the test.txt file for reading
    yyin = fopen("test.txt", "r");
    if (!yyin) {
        fprintf(stderr, "Error: Could not open test.txt\n");
        return 1; // Exit if the file can't be opened
    }

    yyparse(); // Call to the parser

    // Print token summary
    print_token_summary();
    // Print the symbol table
    print_symbol_table();

    // Print completion message
    printf("Syntax analysis completed.\n");

    // Close the input file
    fclose(yyin);

    return 0; // Exit program
}
