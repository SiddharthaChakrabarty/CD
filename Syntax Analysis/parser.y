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
void printtree(struct node *tree);
void printInorder(struct node *tree, int depth);
int yylex(void);
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
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3);
        $$ = mknode(NULL, NULL, "Var_Declaration", strdup(buffer));
    }
    | IDENTIFIER 
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s", $1);
        $$ = mknode(NULL, NULL, "Var_Declaration", strdup(buffer));
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
        $$ = mknode($3, mknode($5, $7, "For_Update", "For Update"), "For_Loop", "For Loop");
    };  

for_initialization:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE  
    { 
        printf("For loop initialization parsed.\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3);
        $$ = mknode(NULL, NULL, "For_Initialization", strdup(buffer));
    };  

condition:  
    IDENTIFIER SPECIAL_SYMBOL VALUE  
    { 
        printf("Condition parsed.\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s %s %s", $1, $2, $3);
        $$ = mknode(NULL, NULL, "Condition", strdup(buffer));
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
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3);
        $$ = mknode(NULL, NULL, "For_Update", strdup(buffer));
    };  

arithmetic_expression:  
    IDENTIFIER PLUS_OPERATOR VALUE  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s + %s", $1, $3);
        $$ = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
    }
    | IDENTIFIER MINUS_OPERATOR VALUE  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s - %s", $1, $3);
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
        $$ = mknode($3, $6, "Do_While_Loop", "Do While Loop");
    };  

function_call_statement:  
    FUNCTION OPEN_PARENTHESIS STRING_LITERAL CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        printf("Function call encountered!\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "printf(%s)", $3);
        $$ = mknode(NULL, NULL, "Function_Call", strdup(buffer));
    };  

expression_statement:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE TERMINATOR_SYMBOL  
    { 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", $1, $3);
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
    };  

%%  

int main(void) {  
    FILE *file = fopen("test.txt", "r");     
    if (!file) {         
        perror("Failed to open input file");         
        return 1;  
    }      
    yyin = file;  
    yyparse();  
    fclose(file);  
    
    // Print the parse tree after parsing
    printf("\n\nParse Tree Inorder Traversal:\n");
    printtree(head);
    
    return 0;  
}  

int yyerror(const char *s) {     
    fprintf(stderr, "Syntax error detected: %s\n", s);     
    return 0;  
}

// Create a new node for the parse tree
struct node* mknode(struct node *left, struct node *right, const char *token, const char *code) {
    struct node *newnode = (struct node*)malloc(sizeof(struct node));
    newnode->left = left;
    newnode->right = right;
    newnode->token = strdup(token); // Allocate and copy token string
    newnode->code = strdup(code);   // Allocate and copy code string
    newnode->id = nodeCounter++;
    return newnode;
}

// Print the parse tree in Inorder
void printtree(struct node *tree) {
    if (tree != NULL) {
        printtree(tree->left);
        printf("  Node ID: %d, Token: %s, Code: %s\n", tree->id, tree->token, tree->code);
        printtree(tree->right);
    }
}
