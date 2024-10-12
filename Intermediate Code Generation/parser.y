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

int temp_count = 0; // Counter for temporary variables

// Function prototypes for temporary variable management
char* new_temp(); // Function to generate temporary variable names

// Intermediate code generation functions
void generate_code(const char* operation, const char* operand1, const char* operand2, const char* result);
void generate_assignment(const char* variable, const char* value);
void generate_increment(const char* variable);
void generate_decrement(const char* variable);
void generate_for_loop(const char* loop_var, const char* limit);
void generate_while_loop(const char* condition);
void generate_do_while_loop(const char* condition);

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
        printf("Function definition processed correctly!\n"); 
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
        generate_assignment($1, $3); // Generate intermediate code for assignment
    }
    | IDENTIFIER 
    { 
        // Handle variable declaration without initialization
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
        generate_for_loop($3, "5"); // Generate for loop with condition
        // Generate code for the loop body
        printf("Loop body code generation:\n");
    };  

for_initialization:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE  
    { 
        generate_assignment($1, $3); // Generate intermediate code for initialization
        printf("For loop initialization parsed.\n"); 
    };  

condition:  
    IDENTIFIER SPECIAL_SYMBOL VALUE  
    { 
        printf("Condition parsed: %s %s %s\n", $1, $2, $3);
        $$ = $1; // Set the condition value for further use
    };  

for_update:  
    IDENTIFIER INCREMENT_OPERATOR  
    { 
        generate_increment($1); // Generate intermediate code for increment
        printf("For loop update parsed.\n"); 
    }
    | IDENTIFIER DECREMENT_OPERATOR  
    { 
        generate_decrement($1); // Generate intermediate code for decrement
        printf("For loop update parsed.\n"); 
    }
    | IDENTIFIER ASSIGNMENT_OPERATOR arithmetic_expression  
    { 
        generate_assignment($1, $3); // Generate intermediate code for assignment
        printf("For loop update parsed.\n");
    };  

arithmetic_expression:  
    IDENTIFIER PLUS_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("ADD", $1, $3, temp); // Generate intermediate code for addition
        $$ = temp;
    }
    | IDENTIFIER MINUS_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("SUB", $1, $3, temp); // Generate intermediate code for subtraction
        $$ = temp;
    };  

while_loop_statement:  
    WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        generate_while_loop($3); // Generate while loop with condition
        // Generate code for the loop body
        printf("Loop body code generation:\n");
    };  

do_while_statement:  
    DO OPEN_BRACE statement_list CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        generate_do_while_loop($6); // Generate do-while loop with condition
        // Generate code for the loop body
        printf("Loop body code generation:\n");
    };  

function_call_statement:  
    FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Function call encountered!\n"); 
    };  

expression_statement:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE TERMINATOR_SYMBOL  
    { 
        generate_assignment($1, $3); // Generate intermediate code for assignment
    }
    | IDENTIFIER INCREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        generate_increment($1); // Generate intermediate code for increment
        printf("Increment operation parsed.\n");
    }
    | IDENTIFIER DECREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        generate_decrement($1); // Generate intermediate code for decrement
        printf("Decrement operation parsed.\n");
    }
    | FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Function call encountered!\n"); 
    };  

%%  

int main(int argc, char *argv[]) {  
    if (argc < 2) { // Check if the filename is provided
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;  
    }

    FILE *file = fopen(argv[1], "r"); // Open the file using the provided filename
    if (!file) {         
        perror("Failed to open input file");         
        return 1;  
    }      

    yyin = file;  
    yyparse();  
    fclose(file);  

    return 0;  
}  

char* new_temp() {  
    char *temp_var_name = malloc(10);     
    snprintf(temp_var_name, 10, "t%d", temp_count++);     
    return temp_var_name;  
}  

void generate_code(const char* operation, const char* operand1, const char* operand2, const char* result) {  
    printf("%s %s, %s -> %s\n", operation, operand1, operand2, result);  
}  

void generate_assignment(const char* variable, const char* value) {  
    printf("MOV %s, %s\n", variable, value);  
}  

void generate_increment(const char* variable) {  
    printf("INC %s\n", variable);  
}  

void generate_decrement(const char* variable) {  
    printf("DEC %s\n", variable);  
}  

void generate_for_loop(const char* loop_var, const char* limit) {  
    char label_condition[20], label_body[20], label_end[20];
    snprintf(label_condition, sizeof(label_condition), "label_for_condition");
    snprintf(label_body, sizeof(label_body), "label_for_body");
    snprintf(label_end, sizeof(label_end), "label_for_end");

    printf("%s:\n", label_condition);  
    printf("CMP %s, %s\n", loop_var, limit);  
    printf("JLT %s\n", label_body);  
    printf("JMP %s\n", label_end);  

    printf("%s:\n", label_body);  
    printf("CALL printf(\"For loop\\n\");\n");  
    printf("INC %s\n", loop_var);  
    printf("JMP %s\n", label_condition);  

    printf("%s:\n", label_end);  
}  

void generate_while_loop(const char* condition) {  
    char label_condition[20], label_body[20], label_end[20];
    snprintf(label_condition, sizeof(label_condition), "label_while_condition");
    snprintf(label_body, sizeof(label_body), "label_while_body");
    snprintf(label_end, sizeof(label_end), "label_while_end");

    printf("%s:\n", label_condition);  
    printf("CMP %s, 0\n", condition);  
    printf("JE %s\n", label_end);  

    printf("%s:\n", label_body);  
    printf("CALL printf(\"While loop\\n\");\n");  
    printf("JMP %s\n", label_condition);  

    printf("%s:\n", label_end);  
}  

void generate_do_while_loop(const char* condition) {  
    char label_body[20], label_end[20];
    snprintf(label_body, sizeof(label_body), "label_do_while_body");
    snprintf(label_end, sizeof(label_end), "label_do_while_end");

    printf("%s:\n", label_body);  
    printf("CALL printf(\"Do while loop\\n\");\n");  
    printf("CMP %s, 0\n", condition);  
    printf("JE %s\n", label_end);  
    printf("JMP %s\n", label_body);  

    printf("%s:\n", label_end);  
}  

int yyerror(const char *s) {  
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);  
    return 0;  
}  
