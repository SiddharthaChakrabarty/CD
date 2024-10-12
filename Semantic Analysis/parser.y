%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_SYMBOLS 40

// Node structure for parse tree
struct node {
    struct node *left;
    struct node *right;
    char *token; // Abstract representation
    char *code;  // Actual code representation
    int id;      // Unique identifier for each node
};

// Function prototypes
struct node* mknode(struct node *left, struct node *right, const char *token, const char *code);
int yyerror(const char *s);
int yylex(void); // Declare yylex
extern FILE *yyin; // Declare yyin
extern char *yytext; // Declare yytext
extern int yylineno; // To track line numbers in lexer

// Symbol table management
struct dataType {
    char *id_name;
    char *data_type;
    int line_no;  // Line number of declaration
    int scope;     // Scope level
} symbol_table[MAX_SYMBOLS];

int count = 0; // Count of symbols in the symbol table
char type[10]; // To hold data type information
int current_scope = 0; // Track current scope

// Function prototypes for symbol table
void add(char *name, char *dtype, int line, int scope);
int search(char *name);

%}

%union {
    char* str;         // For tokens like IDENTIFIER, KEYWORD, etc.
}

%token <str> PREPROCESSOR PREPROCESSOR_KEYWORD HEADER_FILE FUNCTION  
%token <str> KEYWORD IDENTIFIER VALUE STRING_LITERAL  
%token <str> ASSIGNMENT_OPERATOR SPECIAL_SYMBOL TERMINATOR_SYMBOL COMMA  
%token <str> OPEN_BRACE CLOSE_BRACE OPEN_PARENTHESIS CLOSE_PARENTHESIS  
%token <str> PLUS_OPERATOR MINUS_OPERATOR INCREMENT_OPERATOR DECREMENT_OPERATOR  
%token <str> FOR WHILE DO UNKNOWN_SYMBOL

%type <str> program preprocessor_statement function_definition declarations declaration_list variable_declaration statement_list statement loop_statement for_loop_statement for_initialization condition for_update arithmetic_expression while_loop_statement do_while_statement function_call_statement expression_statement

%% 

program:  
    preprocessor_statement function_definition 
    { 
        // Do something with the program node if needed
    };  

preprocessor_statement:  
    PREPROCESSOR PREPROCESSOR_KEYWORD SPECIAL_SYMBOL HEADER_FILE SPECIAL_SYMBOL  
    { 
        printf("Preprocessor directive parsed successfully!\n"); 
    };  

function_definition:  
    KEYWORD FUNCTION OPEN_PARENTHESIS CLOSE_PARENTHESIS OPEN_BRACE declarations statement_list CLOSE_BRACE  
    { 
        current_scope++; // Increase scope level for the function
        printf("Function definition processed correctly!\n"); 
        current_scope--; // Decrease scope level at the end of function
    };  

declarations:  
    KEYWORD declaration_list TERMINATOR_SYMBOL  
    { 
        printf("Variables declared and initialized.\n"); 
    };  

declaration_list:  
    variable_declaration
    | variable_declaration COMMA declaration_list 
    { 
        // Do something with declaration list if needed
    }; 

variable_declaration:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE
    { 
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add($1, type, yylineno, current_scope); // Add variable to symbol table with line number and scope
    }
    | IDENTIFIER 
    { 
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add($1, type, yylineno, current_scope); // Add variable to symbol table with line number and scope
    }; 

statement_list:  
    statement  
    | statement_list statement  
    { 
        // Do something with statement list if needed
    };  

statement:  
    loop_statement  
    | function_call_statement  
    | expression_statement  
    ;  

loop_statement:  
    for_loop_statement  
    | while_loop_statement  
    | do_while_statement  
    ;  

for_loop_statement:  
    FOR OPEN_PARENTHESIS for_initialization TERMINATOR_SYMBOL condition TERMINATOR_SYMBOL for_update CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        current_scope++; // Increase scope level for the loop
        printf("For loop parsed successfully!\n"); 
        current_scope--; // Decrease scope level after loop
    };  

for_initialization:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE  
    { 
        printf("For loop initialization parsed.\n"); 
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add($1, type, yylineno, current_scope); // Add variable to symbol table with line number and scope
    };  

condition:  
    IDENTIFIER SPECIAL_SYMBOL VALUE  
    { 
        printf("Condition parsed.\n"); 
    };  

for_update:  
    IDENTIFIER INCREMENT_OPERATOR  
    { 
        printf("For loop update parsed.\n"); 
    }
    | IDENTIFIER DECREMENT_OPERATOR  
    { 
        printf("For loop update parsed.\n"); 
    }
    | IDENTIFIER ASSIGNMENT_OPERATOR arithmetic_expression  
    { 
        printf("For loop update parsed.\n");
    };  

arithmetic_expression:  
    IDENTIFIER PLUS_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
    }
    | IDENTIFIER MINUS_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
    };  

while_loop_statement:  
    WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        current_scope++; // Increase scope level for the loop
        printf("While loop parsed successfully!\n"); 
        current_scope--; // Decrease scope level after loop
    };  

do_while_statement:  
    DO OPEN_BRACE statement_list CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        current_scope++; // Increase scope level for the loop
        printf("Do-while loop parsed successfully!\n"); 
        current_scope--; // Decrease scope level after loop
    };  

function_call_statement:  
    FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Function call encountered!\n"); 
    };  

expression_statement:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE TERMINATOR_SYMBOL  
    { 
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add($1, type, yylineno, current_scope); // Add variable to symbol table with line number and scope
    }
    | IDENTIFIER INCREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        printf("Increment operation parsed.\n");
    }
    | IDENTIFIER DECREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        printf("Decrement operation parsed.\n");
    }
    | FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Function call encountered!\n"); 
    };  

%%  

int main(int argc, char *argv[]) {  
    if (argc < 2) {  
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;  
    }

    FILE *file = fopen(argv[1], "r");     
    if (!file) {         
        perror("Failed to open input file");         
        return 1;  
    }      
    yyin = file;  
    yyparse();  
    fclose(file);  

    // Print symbol table contents
    printf("\n=== Symbol Table ===\n\n");
    for (int i = 0; i < count; i++) {
        printf("ID: %s, Type: %s, Line: %d, Scope: %d\n", 
            symbol_table[i].id_name, 
            symbol_table[i].data_type, 
            symbol_table[i].line_no, 
            symbol_table[i].scope);
    }

    return 0;
}

// Function to add variable to symbol table
void add(char *name, char *dtype, int line, int scope) {
    symbol_table[count].id_name = strdup(name); // Store the variable name
    symbol_table[count].data_type = strdup(dtype); // Store the data type
    symbol_table[count].line_no = line; // Assign line number
    symbol_table[count].scope = 1; // Assign scope
    count++;
}

// Search function (not used in current code, but can be implemented)
int search(char *name) {
    for (int i = 0; i < count; i++) {
        if (strcmp(symbol_table[i].id_name, name) == 0) {
            return i; // Return index if found
        }
    }
    return -1; // Not found
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);  // Display the error message along with the line number
    return 0;
}
