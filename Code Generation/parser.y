%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_SYMBOLS 40
#define MAX_REGISTERS 10

int available_registers[MAX_REGISTERS] = {0};
FILE *output_file; 

struct node {
    struct node *left;
    struct node *right;
    char *token; 
    char *code;  
    int id;     
};

struct node* mknode(struct node *left, struct node *right, const char *token, const char *code);
int yyerror(const char *s);
int yylex(void); 
extern FILE *yyin; 
extern char *yytext; 
extern int yylineno; 

int temp_count = 0; 
int label_count = 0; 

void register_allocate();
void register_free(char* register_name);

char* new_temp(); 
char* new_label(); 

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
    char* str;        
}

%token <str> PREPROCESSOR PREPROCESSOR_KEYWORD HEADER_FILE FUNCTION  
%token <str> KEYWORD IDENTIFIER VALUE STRING_LITERAL  
%token <str> ASSIGNMENT_OPERATOR SPECIAL_SYMBOL TERMINATOR_SYMBOL COMMA  
%token <str> OPEN_BRACE CLOSE_BRACE OPEN_PARENTHESIS CLOSE_PARENTHESIS  
%token <str> PLUS_OPERATOR MINUS_OPERATOR MULTIPLY_OPERATOR DIVIDE_OPERATOR  
%token <str> INCREMENT_OPERATOR DECREMENT_OPERATOR  
%token <str> FOR WHILE DO UNKNOWN_SYMBOL

%type <str> program preprocessor_statement function_definition declarations declaration_list variable_declaration statement_list statement loop_statement for_loop_statement for_initialization condition for_update arithmetic_expression while_loop_statement do_while_statement function_call_statement expression_statement

%% 

program:  
    preprocessor_statement function_definition 
    { 
    };  

preprocessor_statement:  
    PREPROCESSOR PREPROCESSOR_KEYWORD SPECIAL_SYMBOL HEADER_FILE SPECIAL_SYMBOL  
    { 
        fprintf(output_file,"Preprocessor directive parsed successfully!\n"); 
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
    }; 

variable_declaration:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE
    { 
        generate_assignment($1, $3); 
    }
    | IDENTIFIER 
    { 
    }; 

statement_list:  
    statement  
    | statement_list statement  
    { 
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

        fprintf(output_file,"MOV %s, %s\n", $3, $5); 
        fprintf(output_file,"%s:\n", start_label); 
        generate_cmp($3, $5);  
        generate_conditional_jump(end_label);

        fprintf(output_file,"    ; Output: printf(\"For loop\")\n"); 
        fprintf(output_file,"    JMP %s\n", start_label); 
        fprintf(output_file,"%s:\n", end_label);  
    };

for_initialization:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE  
    { 
        generate_assignment($1, $3); 
    };  

condition:  
    IDENTIFIER SPECIAL_SYMBOL VALUE  
    { 
        $$ = $3; 
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
        generate_code_add($1, $3, temp); 
        $$ = temp;
    }
    | IDENTIFIER MINUS_OPERATOR VALUE  
    { 
        char *temp = new_temp();
        generate_code_sub($1, $3, temp); 
        $$ = temp;
    }
    | IDENTIFIER MULTIPLY_OPERATOR VALUE  
    { 
        char *temp = new_temp();
        if (atoi($3) == 2) {
            generate_code_mul_2($1, "1", temp); 
        } else if (atoi($3) == 4) {
            // Replace x * 4 with x << 2
            generate_code_mul_4($1, "2", temp);
        } else {
            generate_code_mul($1, $3, temp);
        }
        $$ = temp;
    }
    | IDENTIFIER DIVIDE_OPERATOR VALUE  
    { 
        char *temp = new_temp();
        if (atoi($3) == 2) {
            generate_code_div_2($1, "1", temp); 
        } else if (atoi($3) == 4) {
            generate_code_div_4($1, "2", temp);
        } else {
            generate_code_div($1, $3, temp);
        }
        $$ = temp;
    };  

while_loop_statement:  
    WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        char* start_label = new_label(); 
        char* end_label = new_label(); 
        generate_cmp($1, $3);
        generate_conditional_jump(end_label); 
        fprintf(output_file,"    ; Output: printf(\"While loop\")\n"); 
        fprintf(output_file,"    JMP %s\n", start_label);  
        fprintf(output_file,"%s:\n", end_label); 
    };

do_while_statement:  
    DO OPEN_BRACE statement_list CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        char* start_label = new_label(); 
        char* end_label = new_label(); 
        fprintf(output_file,"    ; Output: printf(\"Do-while loop\")\n"); 
        fprintf(output_file,"    INC %s\n", $1);  
        generate_cmp($1, $6); 
        generate_conditional_jump(end_label); 
        fprintf(output_file,"    JMP %s\n", start_label);  
        fprintf(output_file,"%s:\n", end_label);  
    };

function_call_statement:  
    FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
    };  

expression_statement:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE TERMINATOR_SYMBOL  
    { 
        generate_assignment($1, $3); 
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
    fprintf(output_file, "MOV %s, %s\n", var, expr); 
}

void generate_increment(char* var) {
    fprintf(output_file, "INC %s\n", var); 
}

void generate_decrement(char* var) {
    fprintf(output_file, "DEC %s\n", var); 
}

void generate_code_add(char* left, char* right, char* temp) {
    fprintf(output_file, "ADD %s, %s, %s\n", left, right, temp); 
}

void generate_code_sub(char* left, char* right, char* temp) {
    fprintf(output_file, "SUB %s, %s, %s\n", left, right, temp); 
}

void generate_code_mul(char* left, char* right, char* temp) {
    fprintf(output_file, "MUL %s, %s, %s\n", left, right, temp); 
}

void generate_code_div(char* left, char* right, char* temp) {
    fprintf(output_file, "DIV %s, %s, %s\n", left, right, temp); 
}

void generate_while_loop(char* condition) {
    fprintf(output_file, "WHILE loop for condition: %s\n", condition);
}

void generate_do_while_loop(char* condition) {
    fprintf(output_file, "DO-WHILE loop for condition: %s\n", condition);
    
}

void generate_code_jump(char* label) {
    fprintf(output_file, "JUMP %s\n", label);
}

void generate_conditional_jump(char* label) {
    fprintf(output_file, "JUMP_IF_FALSE %s\n", label);  
}

void generate_cmp(char* left, char* right) {
    fprintf(output_file, "CMP %s, %s\n", left, right); 
}

void generate_code_conditional_jump(char* label) {
    fprintf(output_file, "JUMP_IF_FALSE %s\n", label);
}

void generate_code_mul_2(char* left, char* right, char* temp) {
    fprintf(output_file, "SHL %s, %s, %s\n", left, right, temp);
}

void generate_code_mul_4(char* left, char* right, char* temp) {
    fprintf(output_file, "SHL %s, %s, %s\n", left, right, temp);
}

void generate_code_div_2(char* left, char* right, char* temp) {
    fprintf(output_file, "SHR %s, %s, %s\n", left, right, temp);
}

void generate_code_div_4(char* left, char* right, char* temp) {
    fprintf(output_file, "SHR %s, %s, %s\n", left, right, temp);
}

void register_allocate() {
    for (int i = 0; i < MAX_REGISTERS; i++) {
        if (available_registers[i] == 0) {
            available_registers[i] = 1; 
            printf("ALLOC R%d\n", i);
            return;
        }
    }
    printf("Error: No registers available!\n");
}

void register_free(char* register_name) {
    int reg_num = atoi(register_name + 1); 
    available_registers[reg_num] = 0; 
    printf("FREE %s\n", register_name); 
}

int main(int argc, char** argv) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Failed to open input file");
        return 1;
    }

    output_file = fopen(argv[2], "w");
    if (!output_file) {
        perror("Failed to open output file");
        fclose(yyin);
        return 1;
    }
    yyparse();
    fclose(yyin);
    fclose(output_file);
    return 0;
}

int yyerror(const char *s) {  
    fprintf(stderr, "Error: %s\n", s);  
    return 0;  
}