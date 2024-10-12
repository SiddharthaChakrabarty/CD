%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct ParseTreeNode {
    char *value;                           // Holds the value of the node (e.g., token or rule name)
    struct ParseTreeNode **children;      // Array of child nodes
    int childCount;                       // Number of children
} ParseTreeNode;

// Function prototypes
ParseTreeNode *createNode(const char *value);
void printParseTree(ParseTreeNode *node, int level);
void freeParseTree(ParseTreeNode *node);

int yylex(void); 
int yyerror(const char *s); 
extern FILE *yyin;  
%}

// Define YYSTYPE to be a pointer to ParseTreeNode
%union {
    ParseTreeNode *node;  // Use this to hold the parse tree nodes
    int intval;           // If you need to hold integer values
}

%token <node> PREPROCESSOR PREPROCESSOR_KEYWORD HEADER_FILE FUNCTION  
%token <node> KEYWORD IDENTIFIER VALUE STRING_LITERAL  
%token <node> ASSIGNMENT_OPERATOR SPECIAL_SYMBOL TERMINATOR_SYMBOL COMMA  
%token <node> OPEN_BRACE CLOSE_BRACE OPEN_PARENTHESIS CLOSE_PARENTHESIS  
%token <node> PLUS_OPERATOR MINUS_OPERATOR INCREMENT_OPERATOR DECREMENT_OPERATOR  
%token <node> FOR WHILE DO UNKNOWN_SYMBOL

%% 

program:  
    preprocessor_statement function_definition 
    { 
        $$ = createNode("program");
        $$->children = malloc(2 * sizeof(ParseTreeNode*));
        $$->children[0] = $1; // Preprocessor statement
        $$->children[1] = $2; // Function definition
        $$->childCount = 2;
        printf("Parsing completed. Printing parse tree:\n");
        printParseTree($$, 0); // Print the parse tree
        freeParseTree($$); // Clean up after printing
    }
    ;

preprocessor_statement:  
    PREPROCESSOR PREPROCESSOR_KEYWORD SPECIAL_SYMBOL HEADER_FILE SPECIAL_SYMBOL  
    { 
        $$ = createNode("preprocessor_statement");
        $$->children = malloc(5 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode("#");
        $$->children[1] = createNode(yytext); // Preprocessor keyword
        $$->children[2] = createNode("<"); // Special symbol
        $$->children[3] = createNode(yytext); // Header file
        $$->children[4] = createNode(">"); // Special symbol
        $$->childCount = 5;
        printf("Preprocessor directive parsed successfully!\n"); 
    }
    ;  

function_definition:  
    KEYWORD FUNCTION OPEN_PARENTHESIS CLOSE_PARENTHESIS OPEN_BRACE declarations statement_list CLOSE_BRACE  
    { 
        $$ = createNode("function_definition");
        $$->children = malloc(6 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode(yytext); // Keyword
        $$->children[1] = createNode(yytext); // Function name
        $$->children[2] = createNode("(");
        $$->children[3] = createNode(")");
        $$->children[4] = $6; // Body of the function
        $$->childCount = 5;
        printf("Function definition processed correctly!\n"); 
    }
    ;  

declarations:  
    KEYWORD declaration_list TERMINATOR_SYMBOL  
    { 
        $$ = createNode("declarations");
        $$->children = malloc(2 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode(yytext); // Keyword
        $$->children[1] = $2; // Declaration list
        $$->childCount = 2;
        printf("Variables declared and initialized.\n"); 
    }
    ;  

declaration_list:  
    variable_declaration 
    { 
        $$ = createNode("declaration_list");
        $$->children = malloc(1 * sizeof(ParseTreeNode*));
        $$->children[0] = $1; // Variable declaration
        $$->childCount = 1;
    }
    | variable_declaration COMMA declaration_list 
    { 
        $$ = createNode("declaration_list");
        $$->children = malloc(2 * sizeof(ParseTreeNode*));
        $$->children[0] = $1; // Variable declaration
        $$->children[1] = $3; // Recursive declaration list
        $$->childCount = 2;
    }
    ; 

variable_declaration:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE 
    { 
        $$ = createNode("variable_declaration");
        $$->children = malloc(3 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode($1); // Identifier
        $$->children[1] = createNode("="); // Assignment operator
        $$->children[2] = createNode($3); // Value
        $$->childCount = 3; 
    }
    | IDENTIFIER // Allow for declaration without initialization
    { 
        $$ = createNode("variable_declaration");
        $$->children = malloc(1 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode($1); // Identifier
        $$->childCount = 1; 
    }
    ; 

statement_list:  
    statement 
    { 
        $$ = createNode("statement_list");
        $$->children = malloc(1 * sizeof(ParseTreeNode*));
        $$->children[0] = $1; // Statement
        $$->childCount = 1; 
    }
    | statement_list statement  
    { 
        $$ = createNode("statement_list");
        $$->children = malloc(2 * sizeof(ParseTreeNode*));
        $$->children[0] = $1; // Previous statement list
        $$->children[1] = $2; // New statement
        $$->childCount = 2; 
    }
    ;  

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
        $$ = createNode("for_loop_statement");
        $$->children = malloc(8 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode("for");
        $$->children[1] = createNode("(");
        $$->children[2] = $3; // For initialization
        $$->children[3] = createNode(";"); // Terminator
        $$->children[4] = $5; // Condition
        $$->children[5] = createNode(";"); // Terminator
        $$->children[6] = $7; // For update
        $$->children[7] = $9; // Statement list
        $$->childCount = 8; 
        printf("For loop parsed successfully!\n"); 
    }
    ;  

for_initialization:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE  
    { 
        $$ = createNode("for_initialization");
        $$->children = malloc(3 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode($1); // Identifier
        $$->children[1] = createNode("="); // Assignment operator
        $$->children[2] = createNode($3); // Value
        $$->childCount = 3; 
        printf("For loop initialization parsed.\n"); 
    }
    ;  

condition:  
    IDENTIFIER SPECIAL_SYMBOL VALUE  
    { 
        $$ = createNode("condition");
        $$->children = malloc(3 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode($1); // Identifier
        $$->children[1] = createNode(yytext); // Condition operator
        $$->children[2] = createNode($3); // Value
        $$->childCount = 3; 
        printf("Condition parsed.\n"); 
    }
    ;  

for_update:  
    IDENTIFIER INCREMENT_OPERATOR  
    | IDENTIFIER DECREMENT_OPERATOR  
    | IDENTIFIER ASSIGNMENT_OPERATOR arithmetic_expression  
    { 
        $$ = createNode("for_update");
        $$->children = malloc(3 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode($1); // Identifier
        $$->children[1] = createNode(yytext); // Increment/Decrement operator
        $$->children[2] = $3; // Arithmetic expression
        $$->childCount = 3; 
        printf("For loop update parsed.\n"); 
    }
    ;  

arithmetic_expression:  
    IDENTIFIER PLUS_OPERATOR VALUE  
    | IDENTIFIER MINUS_OPERATOR VALUE  
    ;  

while_loop_statement:  
    WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE statement_list CLOSE_BRACE  
    { 
        $$ = createNode("while_loop_statement");
        $$->children = malloc(6 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode("while");
        $$->children[1] = createNode("(");
        $$->children[2] = $4; // Condition
        $$->children[3] = createNode(")");
        $$->children[4] = $6; // Statement list
        $$->childCount = 5; 
        printf("While loop parsed successfully!\n"); 
    }
    ;  

do_while_statement:  
    DO OPEN_BRACE statement_list CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        $$ = createNode("do_while_statement");
        $$->children = malloc(6 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode("do");
        $$->children[1] = $3; // Statement list
        $$->children[2] = createNode("while");
        $$->children[3] = createNode("(");
        $$->children[4] = $6; // Condition
        $$->children[5] = createNode(")");
        $$->childCount = 6; 
        printf("Do-while loop parsed successfully!\n"); 
    }
    ;  

function_call_statement:  
    IDENTIFIER OPEN_PARENTHESIS CLOSE_PARENTHESIS TERMINATOR_SYMBOL  
    { 
        $$ = createNode("function_call");
        $$->children = malloc(4 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode($1); // Function identifier
        $$->children[1] = createNode("(");
        $$->children[2] = createNode(")"); // Placeholder for parameters
        $$->children[3] = createNode(";"); // Terminator
        $$->childCount = 4; 
        printf("Function call parsed successfully!\n"); 
    }
    ;  

expression_statement:  
    IDENTIFIER ASSIGNMENT_OPERATOR VALUE TERMINATOR_SYMBOL  
    { 
        $$ = createNode("expression_statement");
        $$->children = malloc(4 * sizeof(ParseTreeNode*));
        $$->children[0] = createNode($1); // Identifier
        $$->children[1] = createNode("="); // Assignment operator
        $$->children[2] = createNode($3); // Value
        $$->children[3] = createNode(";"); // Terminator
        $$->childCount = 4; 
        printf("Expression statement parsed successfully!\n"); 
    }
    ;  

%% 

// Function to create a new parse tree node
ParseTreeNode *createNode(const char *value) {
    ParseTreeNode *node = malloc(sizeof(ParseTreeNode));
    node->value = strdup(value);
    node->children = NULL;
    node->childCount = 0;
    return node;
}

// Function to print the parse tree (with indentation for clarity)
void printParseTree(ParseTreeNode *node, int level) {
    if (!node) return;
    for (int i = 0; i < level; i++) printf("  "); // Indentation
    printf("%s\n", node->value);
    for (int i = 0; i < node->childCount; i++) {
        printParseTree(node->children[i], level + 1);
    }
}

// Function to free the parse tree
void freeParseTree(ParseTreeNode *node) {
    if (!node) return;
    for (int i = 0; i < node->childCount; i++) {
        freeParseTree(node->children[i]);
    }
    free(node->value);
    free(node->children);
    free(node);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Failed to open file");
            return 1;
        }
    }
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
    return 0;
}
