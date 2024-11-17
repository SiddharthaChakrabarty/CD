%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>

#define MAX_SYMBOLS 40

// Node structure for parse tree
struct node {
    struct node *left;
    struct node *right;
    char *token; // Abstract representation
    char *code;  // Actual code representation
    int id;      // Unique identifier for each node
};

typedef struct {
    char *variable;
    bool is_used;
} VariableUsage;

VariableUsage symbol_table[MAX_SYMBOLS];
int symbol_table_size = 0;

// Function prototypes
struct node* mknode(struct node *left, struct node *right, const char *token, const char *code);
int yyerror(const char *s);
int yylex(void); // Declare yylex
extern FILE *yyin; // Declare yyin
extern char *yytext; // Declare yytext
extern int yylineno; // To track line numbers in lexer

int temp_count = 0; // Counter for temporary variables
int label_count = 0; // Counter for labels

// Function prototypes for temporary variable management
char* new_temp(); // Function to generate temporary variable names
char* new_label(); // Function to generate labels for jumps

char* fold_constants(const char *operand1, const char *operand2, const char *operator);

// Intermediate code generation functions
void generate_code(const char* operation, const char* operand1, const char* operand2, const char* result);
void generate_assignment(const char* variable, const char* value);
void generate_increment(const char* variable);
void generate_decrement(const char* variable);
void generate_for_loop(const char* loop_var, const char* limit);
void generate_while_loop(const char* condition);
void generate_do_while_loop(const char* condition);
void generate_cmp(const char* operand1, const char* operand2);
void generate_jump(const char* label);
void generate_conditional_jump(const char* condition, const char* label);

%}

%union {
    char* str;         // For tokens like IDENTIFIER, KEYWORD, etc.
}

// Token declarations
%token <str> PREPROCESSOR PREPROCESSOR_KEYWORD HEADER_FILE FUNCTION  
%token <str> KEYWORD IDENTIFIER VALUE STRING_LITERAL  
%token <str> ASSIGNMENT_OPERATOR SPECIAL_SYMBOL TERMINATOR_SYMBOL COMMA  
%token <str> OPEN_BRACE CLOSE_BRACE OPEN_PARENTHESIS CLOSE_PARENTHESIS  
%token <str> PLUS_OPERATOR MINUS_OPERATOR MULTIPLY_OPERATOR DIVIDE_OPERATOR  
%token <str> INCREMENT_OPERATOR DECREMENT_OPERATOR  
%token <str> FOR WHILE DO UNKNOWN_SYMBOL

// Define types for grammar rules
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
        char* start_label = new_label(); 
        char* end_label = new_label(); 

        // Generate the start of the loop
        printf("%s:\n", start_label);
        generate_for_loop($3, $5); // Use $5 for the condition limit
        printf("Loop body code generation:\n");
        
        // Generate the condition check and jump
        generate_cmp($3, $5); 
        generate_conditional_jump("JE", end_label); // Jump to end if condition is false
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
        $$ = $3; // Return the value for further use in the loop code generation
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
         // Constant folding
        char *folded_result = fold_constants($1, $3, "+");
        if (folded_result) {
            printf("Optimized Code: %s = %s\n", temp, folded_result);
            free(folded_result);
        } else {
            generate_code("ADD", $1, $3, temp);
        }

        $$ = temp;
    }
    | IDENTIFIER MINUS_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        // Constant folding
        char *folded_result = fold_constants($1, $3, "-");
        if (folded_result) {
            printf("Optimized Code: %s = %s\n", temp, folded_result);
            free(folded_result);
        } else {
            generate_code("SUB", $1, $3, temp);
        }

        $$ = temp;
    }
    | IDENTIFIER MULTIPLY_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("MUL", $1, $3, temp); // Generate intermediate code for multiplication
        $$ = temp;
    }
    | IDENTIFIER DIVIDE_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("DIV", $1, $3, temp); // Generate intermediate code for division
        $$ = temp;
    };  

while_loop_statement:  
    WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        char* start_label = new_label(); 
        char* end_label = new_label(); 

        printf("%s:\n", start_label);
        generate_while_loop($3); // Generate while loop with condition
        
        // Generate the condition check and jump
        generate_cmp($1, $3); 
        generate_conditional_jump("JE", end_label); // Jump to end if condition is false

        // Loop body
        printf("Loop body code generation:\n");
        printf("%s:\n", end_label);
    };  

do_while_statement:  
    DO OPEN_BRACE statement_list CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        char* start_label = new_label(); 
        char* end_label = new_label(); 

        printf("%s:\n", start_label);
        generate_do_while_loop($6); // Generate do-while loop with condition
        
        // Generate the condition check and jump
        generate_cmp($1, $6); 
        generate_conditional_jump("JE", end_label); // Jump to end if condition is false

        // Loop body
        printf("Loop body code generation:\n");
        printf("%s:\n", end_label);
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

// Temporary variable management
char* new_temp() {  
    char* temp = (char*)malloc(10);  
    sprintf(temp, "t%d", temp_count++);  
    return temp;  
}  

char* new_label() {  
    char* label = (char*)malloc(10);  
    sprintf(label, "L%d", label_count++);  
    return label;  
}

bool is_variable_used(const char *variable) {
    for (int i = 0; i < symbol_table_size; i++) {
        if (strcmp(symbol_table[i].variable, variable) == 0) {
            return symbol_table[i].is_used;
        }
    }
    return false;
}

// Mark a variable as used
void mark_variable_used(const char *variable) {
    for (int i = 0; i < symbol_table_size; i++) {
        if (strcmp(symbol_table[i].variable, variable) == 0) {
            symbol_table[i].is_used = true;
            return;
        }
    }
    symbol_table[symbol_table_size++] = (VariableUsage){strdup(variable), true};
}


// Constant folding
bool is_constant(const char *operand) {
    for (int i = 0; operand[i]; i++) {
        if (!isdigit(operand[i])) return false;
    }
    return true;
}

char* fold_constants(const char *operand1, const char *operand2, const char *operator) {
    if (is_constant(operand1) && is_constant(operand2)) {
        int val1 = atoi(operand1);
        int val2 = atoi(operand2);
        int result;

        if (strcmp(operator, "+") == 0) result = val1 + val2;
        else if (strcmp(operator, "-") == 0) result = val1 - val2;
        else if (strcmp(operator, "*") == 0) result = val1 * val2;
        else if (strcmp(operator, "/") == 0) result = val1 / val2;
        else return NULL;

        char *result_str = (char *)malloc(20);
        sprintf(result_str, "%d", result);
        return result_str;
    }
    return NULL;
}

// Intermediate code generation functions
void generate_code(const char* operation, const char* operand1, const char* operand2, const char* result) {  
    char *folded_result = fold_constants(operand1, operand2, operation);

    if (folded_result) {
        printf("Optimized Code: %s = %s\n", result, folded_result);
        free(folded_result);
    } else {
        printf("Intermediate Code: %s %s, %s -> %s\n", operation, operand1, operand2, result);
    }

}  

void generate_assignment(const char* variable, const char* value) {  
    if (is_constant(value)) {
        printf("Optimized Code: %s = %s\n", variable, value);
    } else {
        printf("Intermediate Code: %s = %s\n", variable, value);
    }
    mark_variable_used(variable);
}  

void generate_increment(const char* variable) {  
    char* temp = new_temp();  
    printf("Intermediate Code: %s = %s + 1\n", temp, variable);  
}  

void generate_decrement(const char* variable) {  
    char* temp = new_temp();  
    printf("Intermediate Code: %s = %s - 1\n", temp, variable);  
}  

void generate_for_loop(const char* loop_var, const char* limit) {  
    printf("For loop variable: %s, Limit: %s\n", loop_var, limit);  
}  

void generate_while_loop(const char* condition) {  
    printf("While loop condition: %s\n", condition);  
}  

void generate_do_while_loop(const char* condition) {  
    printf("Do-while loop condition: %s\n", condition);  
}  

void generate_cmp(const char* operand1, const char* operand2) {  
    printf("Intermediate Code: CMP %s, %s\n", operand1, operand2);  
}  

void generate_jump(const char* label) {  
    printf("Intermediate Code: JMP %s\n", label);  
}  

void generate_conditional_jump(const char* condition, const char* label) {  
    printf("Intermediate Code: %s %s\n", condition, label);  
}  

int main(int argc, char** argv) {
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Failed to open file");
        return 1;
    }
    yyparse();
    fclose(yyin);
    return 0;
}

int yyerror(const char *s) {  
    fprintf(stderr, "Error: %s\n", s);  
    return 0;  
}
