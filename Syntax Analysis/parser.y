%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
void print_token_summary();  // Declare the token summary function

// Declare yyin as an external file pointer
extern FILE *yyin;

%}

%token KEYWORD IDENTIFIER CONSTANT STRING
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
    ;

compound_statement:
    LBRACE statements RBRACE
    ;

expression:
    IDENTIFIER ASSIGN expression
    | expression PLUS expression
    | expression MINUS expression
    | expression MUL expression
    | expression DIV expression
    | expression MOD expression
    | IDENTIFIER
    | CONSTANT
    | STRING
    | LPAREN expression RPAREN  // Grouping
    ;

%%

// Error handling function
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
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

    // Print completion message
    printf("Syntax analysis completed.\n");

    // Close the input file
    fclose(yyin);

    return 0; // Exit program
}