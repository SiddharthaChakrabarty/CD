%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
void printtree(struct node *tree, int level);
int yylex(void); // Declare yylex
int yyerror(const char *s);
extern FILE *yyin;

// Root of the parse tree
struct node *head;
int nodeCounter = 1; // Counter for unique node IDs
%}

%union {
    struct node* nd;   // Parse tree node
    char* str;         // For tokens like IDENTIFIER, KEYWORD, etc.
}

%token <str> PREPROCESSOR PREPROCESSOR_KEYWORD HEADER_FILE FUNCTION  
%token <str> KEYWORD IDENTIFIER VALUE STRING_LITERAL  
%token <str> ASSIGNMENT_OPERATOR SPECIAL_SYMBOL TERMINATOR_SYMBOL COMMA  
%token <str> OPEN_BRACE CLOSE_BRACE OPEN_PARENTHESIS CLOSE_PARENTHESIS  
%token <str> PLUS_OPERATOR MINUS_OPERATOR INCREMENT_OPERATOR DECREMENT_OPERATOR  
%token <str> FOR WHILE DO UNKNOWN_SYMBOL

%type <nd> program preprocessor_statement function_definition declarations declaration_list variable_declaration statement_list statement loop_statement for_loop_statement for_initialization condition for_update arithmetic_expression while_loop_statement do_while_statement function_call_statement expression_statement

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
    };  

function_definition:  
    KEYWORD FUNCTION OPEN_PARENTHESIS CLOSE_PARENTHESIS OPEN_BRACE declarations statement_list CLOSE_BRACE  
    { 
        printf("Function definition processed correctly!\n"); 
        $$ = mknode($6, $7, "Function", "Function definition");
    };  

declarations:  
    KEYWORD declaration_list TERMINATOR_SYMBOL  
    { 
        printf("Variables declared and initialized.\n"); 
        $$ = mknode($2, NULL, "Declarations", "Declarations");
    };  

declaration_list:  
    variable_declaration
    | variable_declaration COMMA declaration_list 
    { 
        $$ = mknode($1, $3, "Declaration_List", "Declaration List");
    }; 

variable_declaration:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3); // Ensure initialization is captured
        $$ = mknode(NULL, NULL, "Var_Declaration", strdup(buffer)); // Ensure proper representation
    }
    | IDENTIFIER 
    { 
        // Directly return the variable name without initialization
        $$ = mknode(NULL, NULL, "Var_Declaration", strdup($1)); 
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
        printf("For loop parsed successfully!\n"); 
        $$ = mknode(mknode($3, mknode($5, $7, "For_Update", "For Update"), "For_Loop", "For Loop"), NULL, "For_Loop", "For Loop Body");
    };  

for_initialization:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE  
    { 
        printf("For loop initialization parsed.\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3); // Correct handling
        $$ = mknode(NULL, NULL, "For_Initialization", strdup(buffer));
    };  

condition:  
    IDENTIFIER SPECIAL_SYMBOL VALUE  
    { 
        printf("Condition parsed.\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s %s %s", $1, $2, $3); // Ensure correct condition representation
        $$ = mknode(NULL, NULL, "Condition", strdup(buffer)); // Ensure this returns a node
    };  

for_update:  
    IDENTIFIER INCREMENT_OPERATOR  
    { 
        printf("For loop update parsed.\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s++", $1);
        $$ = mknode(NULL, NULL, "For_Update", strdup(buffer));
    }
    | IDENTIFIER DECREMENT_OPERATOR  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s--", $1);
        $$ = mknode(NULL, NULL, "For_Update", strdup(buffer));
    }
    | IDENTIFIER ASSIGNMENT_OPERATOR arithmetic_expression  
    { 
        printf("For loop update parsed.\n");
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3); // Assume arithmetic_expression returns a valid string
        $$ = mknode(NULL, NULL, "For_Update", strdup(buffer));
    };  

arithmetic_expression:  
    IDENTIFIER PLUS_OPERATOR VALUE  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s + %s", $1, $3); // Ensure correct handling
        $$ = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
    }
    | IDENTIFIER MINUS_OPERATOR VALUE  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s - %s", $1, $3); // Ensure correct handling
        $$ = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
    };  

while_loop_statement:  
    WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        printf("While loop parsed successfully!\n"); 
        $$ = mknode($3, $6, "While_Loop", "While Loop");
    };  

do_while_statement:  
    DO OPEN_BRACE statement_list CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Do-while loop parsed successfully!\n"); 
        struct node *bodyNode = mknode($3, NULL, "Do_While_Body", "Do While Body");
        $$ = mknode(bodyNode, $6, "Do_While_Loop", "Do While Loop");
    };  

function_call_statement:  
    FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Function call encountered!\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "printf(%s)", $3); // Assume STRING_LITERAL is valid
        $$ = mknode(NULL, NULL, "Function_Call", strdup(buffer));
    };  

expression_statement:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE TERMINATOR_SYMBOL  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3); // Correct handling
        $$ = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
    }
    | IDENTIFIER INCREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s++", $1);
        $$ = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
    }
    | IDENTIFIER DECREMENT_OPERATOR TERMINATOR_SYMBOL  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s--", $1);
        $$ = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
    }
    | FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "printf(%s)", $3); // Assume STRING_LITERAL is valid
        $$ = mknode(NULL, NULL, "Function_Call", strdup(buffer));
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

    printf("\n=== Parse Tree ===\n\n");
    printtree(head, 0); // Start with level 0
    return 0;  
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
    fprintf(stderr, "Parse error: %s\n", s);
    return 0;
}
