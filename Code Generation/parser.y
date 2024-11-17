%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_SYMBOLS 40
#define MAX_REGISTERS 10

int available_registers[MAX_REGISTERS] = {0};

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
int label_count = 0; // Counter for labels

void register_allocate();
void register_free(char* register_name);

// Function prototypes for temporary variable management
char* new_temp(); // Function to generate temporary variable names
char* new_label(); // Function to generate labels for jumps

void generate_assignment(char* var, char* expr);
void generate_increment(char* var);
void generate_decrement(char* var);
void generate_code_add(char* left, char* right, char* temp);
void generate_code_sub(char* left, char* right, char* temp);
void generate_code_mul(char* left, char* right, char* temp);
void generate_code_div(char* left, char* right, char* temp);
void generate_while_loop(char* condition);
void generate_do_while_loop(char* condition);
void generate_code_jump(char* label);
void generate_conditional_jump(char* label);
void generate_code_conditional_jump(char* label);
void generate_code_mul_2(char* left, char* right, char* temp);
void generate_code_mul_4(char* left, char* right, char* temp);
void generate_code_div_2(char* left, char* right, char* temp);
void generate_code_div_4(char* left, char* right, char* temp);
void generate_cmp(char* left, char* right);

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
    };  

declarations:  
    KEYWORD declaration_list TERMINATOR_SYMBOL  
    { 
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

        printf("MOV %s, %s\n", $3, $5); // Initial assignment for the loop variable
        printf("%s:\n", start_label); 
        generate_cmp($3, $5);  // Compare condition
        generate_conditional_jump(end_label); // Jump to end if condition is false

        printf("    ; Output: printf(\"For loop\")\n"); // Output for the for loop
        printf("    JMP %s\n", start_label);  // Jump back to the start of the loop
        printf("%s:\n", end_label);  // End label
    };

for_initialization:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE  
    { 
        generate_assignment($1, $3); 
    };  

condition:  
    IDENTIFIER SPECIAL_SYMBOL VALUE  
    { 
        $$ = $3; // Return the value for further use in the loop code generation
    };

for_update:  
    IDENTIFIER INCREMENT_OPERATOR  
    { 
        generate_increment($1); 
    }
    | IDENTIFIER DECREMENT_OPERATOR  
    { 
        generate_decrement($1); 
    }
    | IDENTIFIER ASSIGNMENT_OPERATOR arithmetic_expression  
    { 
        generate_assignment($1, $3);
    };  

arithmetic_expression:  
    IDENTIFIER PLUS_OPERATOR VALUE  
    { 
        char *temp = new_temp();
        generate_code_add($1, $3, temp); // Generate intermediate code for addition
        $$ = temp;
    }
    | IDENTIFIER MINUS_OPERATOR VALUE  
    { 
        char *temp = new_temp();
        generate_code_sub($1, $3, temp); // Generate intermediate code for subtraction
        $$ = temp;
    }
    | IDENTIFIER MULTIPLY_OPERATOR VALUE  
    { 
        char *temp = new_temp();
        if (atoi($3) == 2) {
            // Replace x * 2 with x << 1
            generate_code_mul_2($1, "1", temp); // SHL is bitwise left shift
        } else if (atoi($3) == 4) {
            // Replace x * 4 with x << 2
            generate_code_mul_4($1, "2", temp); // SHL is bitwise left shift
        } else {
            generate_code_mul($1, $3, temp); // Generate intermediate code for multiplication
        }
        $$ = temp;
    }
    | IDENTIFIER DIVIDE_OPERATOR VALUE  
    { 
        char *temp = new_temp();
        if (atoi($3) == 2) {
            generate_code_div_2($1, "1", temp); // SHR is bitwise right shift
        } else if (atoi($3) == 4) {
            generate_code_div_4($1, "2", temp); // SHR is bitwise right shift
        } else {
            generate_code_div($1, $3, temp); // Generate intermediate code for division
        }
        $$ = temp;
    };  

while_loop_statement:  
    WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        char* start_label = new_label(); 
        char* end_label = new_label(); 
        generate_cmp($1, $3); // Compare condition
        generate_conditional_jump(end_label); // Jump to end if condition is false
        
        printf("    ; Output: printf(\"While loop\")\n");  // Output for the while loop
        printf("    JMP %s\n", start_label);  // Jump back to the start of the loop
        printf("%s:\n", end_label);  // End label
    };

do_while_statement:  
    DO OPEN_BRACE statement_list CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        char* start_label = new_label(); 
        char* end_label = new_label(); 
        
        printf("    ; Output: printf(\"Do-while loop\")\n");  // Output for the do-while loop
        printf("    INC %s\n", $1);  // Increment first, for demonstration
        
        generate_cmp($1, $6);  // Compare condition
        generate_conditional_jump(end_label); // Jump to end if condition is false
        printf("    JMP %s\n", start_label);  // Jump back to the start of the loop
        printf("%s:\n", end_label);  // End label
    };

function_call_statement:  
    FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
    };  

expression_statement:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE TERMINATOR_SYMBOL  
    { 
        generate_assignment($1, $3); // Generate intermediate code for assignment
    }
    | IDENTIFIER INCREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        generate_increment($1); 
    }
    | IDENTIFIER DECREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        generate_decrement($1); 
    }
    | FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
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

void generate_assignment(char* var, char* expr) {
    printf("MOV %s, %s\n", var, expr); // Move expr into var
}

void generate_increment(char* var) {
    printf("INC %s\n", var); // Increment var
}

void generate_decrement(char* var) {
    printf("DEC %s\n", var); // Decrement var
}

void generate_code_add(char* left, char* right, char* temp) {
    printf("ADD %s, %s, %s\n", left, right, temp); // Generate add code
}

void generate_code_sub(char* left, char* right, char* temp) {
    printf("SUB %s, %s, %s\n", left, right, temp); // Generate subtract code
}

void generate_code_mul(char* left, char* right, char* temp) {
    printf("MUL %s, %s, %s\n", left, right, temp); // Generate multiply code
}

void generate_code_div(char* left, char* right, char* temp) {
    printf("DIV %s, %s, %s\n", left, right, temp); // Generate divide code
}

void generate_while_loop(char* condition) {
    printf("WHILE loop for condition: %s\n", condition); // Dummy placeholder
}

void generate_do_while_loop(char* condition) {
    printf("DO-WHILE loop for condition: %s\n", condition); // Dummy placeholder
}

void generate_code_jump(char* label) {
    printf("JUMP %s\n", label); // Generate jump code
}

void generate_conditional_jump(char* label) {
    printf("JUMP_IF_FALSE %s\n", label); // Conditional jump code
}

void generate_cmp(char* left, char* right) {
    printf("CMP %s, %s\n", left, right); // Compare the two operands
}

void generate_code_conditional_jump(char* label) {
    printf("JUMP_IF_FALSE %s\n", label);
}

void generate_code_mul_2(char* left, char* right, char* temp) {
    printf("SHL %s, %s, %s\n", left, right, temp); // Actual multiplication operation
}

void generate_code_mul_4(char* left, char* right, char* temp) {
    printf("SHL %s, %s, %s\n", left, right, temp); // Actual multiplication operation
}

void generate_code_div_2(char* left, char* right, char* temp) {
    printf("SHR %s, %s, %s\n", left, right, temp); // Actual division operation
}

void generate_code_div_4(char* left, char* right, char* temp) {
    printf("SHR %s, %s, %s\n", left, right, temp); // Actual division operation
}

void register_allocate() {
    // A simple register allocation for temporary variables (use the first available register)
    for (int i = 0; i < MAX_REGISTERS; i++) {
        if (available_registers[i] == 0) {
            available_registers[i] = 1;  // Mark the register as used
            printf("ALLOC R%d\n", i);
            return;
        }
    }
    // If no registers are available, we can just print an error or use a spill strategy
    printf("Error: No registers available!\n");
}

void register_free(char* register_name) {
    // Mark the register as free
    int reg_num = atoi(register_name + 1); // Assuming register name is in the form Rn
    available_registers[reg_num] = 0; // Free the register
    printf("FREE %s\n", register_name); // Print the free register operation
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