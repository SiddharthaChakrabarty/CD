%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_SYMBOLS 40
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

struct node {
    struct node *left;
    struct node *right;
    char *token; // Abstract representation
    char *code;  // Actual code representation
    int id;      // Unique identifier for each node
};

void print_tokens_side_by_side();
struct node* mknode(struct node *left, struct node *right, const char *token, const char *code);
void add_token(char tokens[MAX_TOKENS][50], int *count, const char *text);
void printtree(struct node *tree, int level);
int yyerror(const char *s);
int yylex(void); 
extern FILE *yyin; 
extern char *yytext;
extern int yylineno; 

int temp_count = 0; // Counter for temporary variables
int label_count = 0; // Counter for labels

struct dataType {
    char *id_name;
    char *data_type;
    int line_no;  
    int scope;    
} symbol_table[MAX_SYMBOLS];

char* new_temp(); // Function to generate temporary variable names
char* new_label();

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

int count = 0; 
char type[10];
int current_scope = 0; 

struct node *head;
int nodeCounter = 1;

// Function prototypes for symbol table
void add(char *name, char *dtype, int line, int scope);
int search(char *name);

%}

%union {
    struct node* nd; 
    char* str;         
}

%token <str> PREPROCESSOR PREPROCESSOR_KEYWORD HEADER_FILE FUNCTION  
%token <str> KEYWORD IDENTIFIER VALUE STRING_LITERAL  
%token <str> ASSIGNMENT_OPERATOR SPECIAL_SYMBOL TERMINATOR_SYMBOL COMMA  
%token <str> OPEN_BRACE CLOSE_BRACE OPEN_PARENTHESIS CLOSE_PARENTHESIS  
%token <str> PLUS_OPERATOR MINUS_OPERATOR MULTIPLY_OPERATOR DIVIDE_OPERATOR INCREMENT_OPERATOR DECREMENT_OPERATOR 
%token <str> FOR WHILE DO UNKNOWN_SYMBOL

%type <str> program preprocessor_statement function_definition declarations declaration_list variable_declaration statement_list statement loop_statement for_loop_statement for_initialization condition for_update arithmetic_expression while_loop_statement do_while_statement function_call_statement expression_statement

%% 

program:  
    preprocessor_statement function_definition 
    { 
        $$ = mknode($1, $2, "program", "Program Structure"); 
        head = $$; 
    };  

preprocessor_statement:  
    PREPROCESSOR PREPROCESSOR_KEYWORD SPECIAL_SYMBOL HEADER_FILE SPECIAL_SYMBOL  
    { 
        printf("Preprocessor directive parsed successfully!\n"); 
        $$ = mknode(NULL, NULL, "Preprocessor", "Preprocessor directive");
        add_token(keywords, &keyword_count, "#include");
        add_token(keywords, &keyword_count, "<stdio.h>");
    };  

function_definition:  
    KEYWORD FUNCTION OPEN_PARENTHESIS CLOSE_PARENTHESIS OPEN_BRACE declarations statement_list CLOSE_BRACE  
    { 
        current_scope++; 
        printf("Function definition processed correctly!\n"); 
        $$ = mknode($6, $7, "Function", "Function definition");
        add_token(keywords, &keyword_count, "void");
        add_token(keywords, &keyword_count, "main");
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, "{");
        add_token(punctuations, &punctuation_count, "}");
        current_scope--; 
    };  

declarations:  
    KEYWORD declaration_list TERMINATOR_SYMBOL  
    { 
        printf("Variables declared and initialized.\n"); 
        $$ = mknode($2, NULL, "Declarations", "Declarations");
        add_token(keywords, &keyword_count, "int");
        add_token(punctuations, &punctuation_count, ";");
    };  

declaration_list:  
    variable_declaration
    | variable_declaration COMMA declaration_list 
    { 
        $$ = mknode($1, $3, "Declaration_List", "Declaration List");
        add_token(punctuations, &punctuation_count, ",");
    }; 

variable_declaration:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE
    { 
        char buffer[100];
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add($1, type, yylineno, current_scope); 
        $$ = mknode(NULL, NULL, "Var_Declaration", strdup(buffer)); // Ensure proper representation
        add_token(identifiers, &identifier_count, $1); 
        add_token(constants, &constant_count, $3); 
        add_token(operators, &operator_count, "=");
    }
    | IDENTIFIER 
    { 
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add($1, type, yylineno, current_scope); 
        $$ = mknode(NULL, NULL, "Var_Declaration", strdup($1)); 
        add_token(identifiers, &identifier_count, $1); 
    }; 

statement_list:  
    statement  
    | statement_list statement  
    { 
        $$ = mknode($1, $2, "Statements", "Statement List");
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
        $$ = mknode(mknode($3, mknode($5, $7, "For_Update", "For Update"), "For_Loop", "For Loop"), NULL, "For_Loop", "For Loop Body");
        add_token(keywords, &keyword_count, "for");
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, "{");
        add_token(punctuations, &punctuation_count, "}");
        add_token(punctuations, &punctuation_count, ";");
        current_scope--; // Decrease scope level after loop
        char* start_label = new_label(); 
        char* end_label = new_label(); 

        // Generate the start of the loop
        printf("%s:\n", start_label);
        generate_for_loop($8, $6); // Use $5 for the condition limit
        printf("Loop body code generation:\n");
        
        // Generate the condition check and jump
        generate_cmp($8, $6); 
        generate_conditional_jump("JE", end_label);
    };  

for_initialization:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE  
    { 
        generate_assignment($1, $3); 
        printf("For loop initialization parsed.\n"); 
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add($1, type, yylineno, current_scope); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3); // Correct handling
        $$ = mknode(NULL, NULL, "For_Initialization", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(constants, &constant_count, $3); 
        add_token(operators, &operator_count, "=");
    };  

condition:  
    IDENTIFIER SPECIAL_SYMBOL VALUE  
    { 
        printf("Condition parsed: %s %s %s\n", $1, $2, $3);
        $$ = $3;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s %s %s", $1, $2, $3); // Ensure correct condition representation
        $$ = mknode(NULL, NULL, "Condition", strdup(buffer)); 
        add_token(identifiers, &identifier_count, $1); 
        add_token(constants, &constant_count, $3); 
        add_token(operators, &operator_count, "<");
    };  

for_update:  
    IDENTIFIER INCREMENT_OPERATOR  
    { 
        generate_increment($1);
        printf("For loop update parsed.\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s++", $1);
        $$ = mknode(NULL, NULL, "For_Update", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(operators, &operator_count, "++");
    }
    | IDENTIFIER DECREMENT_OPERATOR  
    { 
        generate_decrement($1);
        char buffer[100];
        printf("For loop update parsed.\n"); 
        snprintf(buffer, sizeof(buffer), "%s--", $1);
        $$ = mknode(NULL, NULL, "For_Update", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(operators, &operator_count, "--");
    }
    | IDENTIFIER ASSIGNMENT_OPERATOR arithmetic_expression  
    { 
        generate_assignment($1, $3); 
        printf("For loop update parsed.\n");
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3); // Assume arithmetic_expression returns a valid string
        $$ = mknode(NULL, NULL, "For_Update", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(operators, &operator_count, "=");
    };  

arithmetic_expression:  
    IDENTIFIER PLUS_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("ADD", $1, $3, temp); // Generate intermediate code for addition
        $$ = temp;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s + %s", $1, $3); // Ensure correct handling
        $$ = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(constants, &constant_count, $3);  
        add_token(operators, &operator_count, "+");
    }
    | IDENTIFIER MINUS_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("SUB", $1, $3, temp); // Generate intermediate code for subtraction
        $$ = temp;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s - %s", $1, $3); // Ensure correct handling
        $$ = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(constants, &constant_count, $3); 
        add_token(operators, &operator_count, "-");
    }
    | IDENTIFIER MULTIPLY_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("MUL", $1, $3, temp); // Generate intermediate code for multiplication
        $$ = temp;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s * %s", $1, $3); // Ensure correct handling
        $$ = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(constants, &constant_count, $3); 
        add_token(operators, &operator_count, "*");
    }
    | IDENTIFIER DIVIDE_OPERATOR VALUE  
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("DIV", $1, $3, temp); // Generate intermediate code for division
        $$ = temp;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s / %s", $1, $3); // Ensure correct handling
        $$ = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(constants, &constant_count, $3); 
        add_token(operators, &operator_count, "/");
    };  

while_loop_statement:  
    WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        current_scope++; 
        printf("While loop parsed successfully!\n"); 
        $$ = mknode($3, $6, "While_Loop", "While Loop");
        add_token(keywords, &keyword_count, "while");
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, "{");
        add_token(punctuations, &punctuation_count, "}");
        current_scope--; 
        char* start_label = new_label(); 
        char* end_label = new_label(); 

        printf("%s:\n", start_label);
        generate_while_loop($4); // Generate while loop with condition
        
        // Generate the condition check and jump
        generate_cmp($7, $4); 
        generate_conditional_jump("JE", end_label); // Jump to end if condition is false

        // Loop body
        printf("Loop body code generation:\n");
        printf("%s:\n", end_label);
    };  

statement_list:
    statement_list statement  
    { 
        $$ = mknode($1, $2, "Statement_List", "Statement List"); 
    }
    | statement 
    { 
        $$ = $1; 
    };

statement:
    IDENTIFIER ASSIGNMENT_OPERATOR arithmetic_expression
    { 
        generate_assignment($1, $3); // Generate the assignment code for y = y + 1 or similar
        printf("Assignment parsed: %s = %s\n", $1, $3);
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3);
        $$ = mknode(NULL, NULL, "Assignment", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(operators, &operator_count, "="); 
    }
    | IDENTIFIER INCREMENT_OPERATOR
    { 
        generate_increment($1);
        printf("Increment parsed: %s++\n", $1);
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s++", $1);
        $$ = mknode(NULL, NULL, "Increment", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(operators, &operator_count, "++");
    }
    | IDENTIFIER DECREMENT_OPERATOR
    { 
        generate_decrement($1);
        printf("Decrement parsed: %s--\n", $1);
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s--", $1);
        $$ = mknode(NULL, NULL, "Decrement", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(operators, &operator_count, "--");
    };

do_while_statement:  
    DO OPEN_BRACE statement_list CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        current_scope++; // Increase scope level for the loop
        printf("Do-while loop parsed successfully!\n"); 
        struct node *bodyNode = mknode($3, NULL, "Do_While_Body", "Do While Body");
        $$ = mknode(bodyNode, $6, "Do_While_Loop", "Do While Loop");
        add_token(keywords, &keyword_count, "do");
        add_token(keywords, &keyword_count, "while");
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, ";");
        current_scope--; // Decrease scope level after loop
         char* start_label = new_label(); 
        char* end_label = new_label(); 

        printf("%s:\n", start_label);
        generate_do_while_loop($6); // Generate do-while loop with condition
        
        // Generate the condition check and jump
        generate_cmp($6, $8); 
        generate_conditional_jump("JE", end_label); // Jump to end if condition is false

        // Loop body
        printf("Loop body code generation:\n");
        printf("%s:\n", end_label);
    };  

function_call_statement:  
    FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Function call encountered!\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "printf(%s)", $3); // Assume STRING_LITERAL is valid
        $$ = mknode(NULL, NULL, "Function_Call", strdup(buffer));
        add_token(keywords, &keyword_count, "printf");
        add_token(strings, &string_count, $3);
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, ";");
    };  

expression_statement:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE TERMINATOR_SYMBOL  
    { 
        generate_assignment($1, $3);
        snprintf(type, sizeof(type), "int"); 
        add($1, type, yylineno, current_scope); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3); // Correct handling
        $$ = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(constants, &constant_count, $3);
        add_token(operators, &operator_count, "=");
        add_token(punctuations, &punctuation_count, ";");
    }
    | IDENTIFIER INCREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        generate_increment($1);
        printf("Increment operation parsed.\n");
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s++", $1);
        $$ = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(operators, &operator_count, "++");
        add_token(punctuations, &punctuation_count, ";");
    }
    | IDENTIFIER DECREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        generate_decrement($1);
        printf("Decrement operation parsed.\n");
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s--", $1);
        $$ = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
        add_token(identifiers, &identifier_count, $1); 
        add_token(operators, &operator_count, "--");
        add_token(punctuations, &punctuation_count, ";");
    }
    | FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Function call encountered!\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "printf(%s)", $3); // Assume STRING_LITERAL is valid
        $$ = mknode(NULL, NULL, "Function_Call", strdup(buffer));
        add_token(strings, &string_count, $3);
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, ";");
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

// Intermediate code generation functions
void generate_code(const char* operation, const char* operand1, const char* operand2, const char* result) {  
    printf("Intermediate Code: %s %s, %s -> %s\n", operation, operand1, operand2, result);  
}  

void generate_assignment(const char* variable, const char* value) {  
     
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

    printf("\n=== Lexical Analysis Results ===\n");
    print_tokens_side_by_side(); // Print all tokens side by side
    printf("===============================\n\n"); 

    printf("\n=== Symbol Table ===\n\n");
    printf("----------------------------------------------------\n");
    printf("|%-10s | %-10s | %-10s | %-10s |\n", "ID", "Type", "Line", "Scope");
    printf("|----------------------------------------------------\n");

    for (int i = 0; i < count; i++) {
        printf("|%-10s | %-10s | %-10d | %-10d |\n", 
            symbol_table[i].id_name, 
            symbol_table[i].data_type, 
            symbol_table[i].line_no, 
            symbol_table[i].scope);
    }

    printf("----------------------------------------------------\n");

    printf("\n=== Parse Tree ===\n\n");
    printtree(head, 0); // Start with level 0

    return 0;
}

void add(char *name, char *dtype, int line, int scope) {
    symbol_table[count].id_name = strdup(name); // Store the variable name
    symbol_table[count].data_type = strdup(dtype); // Store the data type
    symbol_table[count].line_no = line; // Assign line number
    symbol_table[count].scope = 1; // Assign scope
    count++;
}

int search(char *name) {
    for (int i = 0; i < count; i++) {
        if (strcmp(symbol_table[i].id_name, name) == 0) {
            return i; // Return index if found
        }
    }
    return -1; // Not found
}

struct node* mknode(struct node *left, struct node *right, const char *token, const char *code) {
    struct node *new_node = (struct node *)malloc(sizeof(struct node));
    new_node->left = left;
    new_node->right = right;
    new_node->token = strdup(token);
    new_node->code = strdup(code);
    new_node->id = nodeCounter++; // Assign a unique ID
    return new_node;
}

void add_token(char tokens[MAX_TOKENS][50], int *count, const char *text) {
    if (*count < MAX_TOKENS) {
        strcpy(tokens[*count], text);
        (*count)++;
    }
}

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

void printtree(struct node *tree, int level) {
    if (!tree) return;

    // Print the current node's details with indentation based on its level in the tree
    for (int i = 0; i < level; i++) {
        printf("    "); // Indentation
    }

    printf("Node ID: %d\n", tree->id);
    for (int i = 0; i < level; i++) {
        printf("    "); // Indentation
    }
    printf("Token: %-20s Code: %s\n", tree->token, tree->code);

    // Recursively print left and right children
    printtree(tree->left, level + 1);
    printtree(tree->right, level + 1);
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);  // Display the error message along with the line number
    return 0;
}
