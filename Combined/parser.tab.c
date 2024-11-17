
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 1 "parser.y"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_SYMBOLS 40
#define MAX_TOKENS 100
#define MAX_REGISTERS 10


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

int available_registers[MAX_REGISTERS] = {0};
FILE *output_file; // File pointer for writing output

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

void register_allocate();
void register_free(char* register_name);

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
void generate_code_conditional_jump(char* label);
void generate_code_mul_2(char* left, char* right, char* temp);
void generate_code_mul_4(char* left, char* right, char* temp);
void generate_code_div_2(char* left, char* right, char* temp);
void generate_code_div_4(char* left, char* right, char* temp);
void generate_code_jump(char* label);
void generate_code_add(char* left, char* right, char* temp);
void generate_code_sub(char* left, char* right, char* temp);
void generate_code_mul(char* left, char* right, char* temp);
void generate_code_div(char* left, char* right, char* temp);

int count = 0; 
char type[10];
int current_scope = 0; 

struct node *head;
int nodeCounter = 1;

// Function prototypes for symbol table
void add(char *name, char *dtype, int line, int scope);
int search(char *name);



/* Line 189 of yacc.c  */
#line 174 "parser.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PREPROCESSOR = 258,
     PREPROCESSOR_KEYWORD = 259,
     HEADER_FILE = 260,
     FUNCTION = 261,
     KEYWORD = 262,
     IDENTIFIER = 263,
     VALUE = 264,
     STRING_LITERAL = 265,
     ASSIGNMENT_OPERATOR = 266,
     SPECIAL_SYMBOL = 267,
     TERMINATOR_SYMBOL = 268,
     COMMA = 269,
     OPEN_BRACE = 270,
     CLOSE_BRACE = 271,
     OPEN_PARENTHESIS = 272,
     CLOSE_PARENTHESIS = 273,
     PLUS_OPERATOR = 274,
     MINUS_OPERATOR = 275,
     MULTIPLY_OPERATOR = 276,
     DIVIDE_OPERATOR = 277,
     INCREMENT_OPERATOR = 278,
     DECREMENT_OPERATOR = 279,
     FOR = 280,
     WHILE = 281,
     DO = 282,
     UNKNOWN_SYMBOL = 283
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 101 "parser.y"

    struct node* nd; 
    char* str;         



/* Line 214 of yacc.c  */
#line 245 "parser.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 257 "parser.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  5
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   106

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  29
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  19
/* YYNRULES -- Number of rules.  */
#define YYNRULES  34
/* YYNRULES -- Number of states.  */
#define YYNSTATES  95

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   283

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint8 yyprhs[] =
{
       0,     0,     3,     6,    12,    21,    25,    27,    31,    35,
      37,    39,    42,    44,    46,    48,    50,    52,    54,    66,
      70,    74,    77,    80,    84,    88,    92,    96,   100,   108,
     118,   124,   129,   133,   137
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      30,     0,    -1,    31,    32,    -1,     3,     4,    12,     5,
      12,    -1,     7,     6,    17,    18,    15,    33,    36,    16,
      -1,     7,    34,    13,    -1,    35,    -1,    35,    14,    34,
      -1,     8,    11,     9,    -1,     8,    -1,    37,    -1,    36,
      37,    -1,    38,    -1,    46,    -1,    47,    -1,    39,    -1,
      44,    -1,    45,    -1,    25,    17,    40,    13,    41,    13,
      42,    18,    15,    36,    16,    -1,     8,    11,     9,    -1,
       8,    12,     9,    -1,     8,    23,    -1,     8,    24,    -1,
       8,    11,    43,    -1,     8,    19,     9,    -1,     8,    20,
       9,    -1,     8,    21,     9,    -1,     8,    22,     9,    -1,
      26,    17,    41,    18,    15,    36,    16,    -1,    27,    15,
      36,    16,    26,    17,    41,    18,    13,    -1,     6,    17,
      10,    18,    13,    -1,     8,    11,     9,    13,    -1,     8,
      23,    13,    -1,     8,    24,    13,    -1,     6,    17,    10,
      18,    13,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   118,   118,   125,   134,   149,   158,   159,   166,   176,
     185,   186,   192,   193,   194,   198,   199,   200,   204,   235,
     250,   263,   273,   283,   295,   309,   323,   347,   373,   404,
     439,   453,   466,   477,   488
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "PREPROCESSOR", "PREPROCESSOR_KEYWORD",
  "HEADER_FILE", "FUNCTION", "KEYWORD", "IDENTIFIER", "VALUE",
  "STRING_LITERAL", "ASSIGNMENT_OPERATOR", "SPECIAL_SYMBOL",
  "TERMINATOR_SYMBOL", "COMMA", "OPEN_BRACE", "CLOSE_BRACE",
  "OPEN_PARENTHESIS", "CLOSE_PARENTHESIS", "PLUS_OPERATOR",
  "MINUS_OPERATOR", "MULTIPLY_OPERATOR", "DIVIDE_OPERATOR",
  "INCREMENT_OPERATOR", "DECREMENT_OPERATOR", "FOR", "WHILE", "DO",
  "UNKNOWN_SYMBOL", "$accept", "program", "preprocessor_statement",
  "function_definition", "declarations", "declaration_list",
  "variable_declaration", "statement_list", "statement", "loop_statement",
  "for_loop_statement", "for_initialization", "condition", "for_update",
  "arithmetic_expression", "while_loop_statement", "do_while_statement",
  "function_call_statement", "expression_statement", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    29,    30,    31,    32,    33,    34,    34,    35,    35,
      36,    36,    37,    37,    37,    38,    38,    38,    39,    40,
      41,    42,    42,    42,    43,    43,    43,    43,    44,    45,
      46,    47,    47,    47,    47
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     5,     8,     3,     1,     3,     3,     1,
       1,     2,     1,     1,     1,     1,     1,     1,    11,     3,
       3,     2,     2,     3,     3,     3,     3,     3,     7,     9,
       5,     4,     3,     3,     5
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     1,     0,     2,     0,     0,
       0,     0,     3,     0,     0,     0,     0,     9,     0,     6,
       0,     0,     0,     0,     0,     0,    10,    12,    15,    16,
      17,    13,    14,     0,     5,     0,     0,     0,     0,     0,
       0,     0,     0,     4,    11,     8,     7,     0,     0,    32,
      33,     0,     0,     0,     0,     0,     0,    31,     0,     0,
       0,     0,     0,    30,    19,     0,    20,     0,     0,     0,
       0,     0,     0,     0,    28,     0,     0,    21,    22,     0,
       0,     0,    23,     0,    29,     0,     0,     0,     0,     0,
      24,    25,    26,    27,    18
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     2,     3,     7,    16,    18,    19,    25,    26,    27,
      28,    52,    54,    73,    82,    29,    30,    31,    32
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -57
static const yytype_int8 yypact[] =
{
       3,     1,     7,     4,    -3,   -57,    11,   -57,    14,    15,
      13,    -5,   -57,     5,    40,    53,    33,    29,    35,    48,
      46,    20,    49,    50,    54,    -4,   -57,   -57,   -57,   -57,
     -57,   -57,   -57,    56,   -57,    53,    58,    61,    59,    60,
      63,    66,    33,   -57,   -57,   -57,   -57,    57,    64,   -57,
     -57,    65,    67,    69,    68,     2,    70,   -57,    73,    66,
      75,    72,    52,   -57,   -57,    76,   -57,    33,    62,    77,
       8,    66,    26,    74,   -57,    78,    80,   -57,   -57,    79,
      82,    32,   -57,    33,   -57,    81,    84,    88,    89,    30,
     -57,   -57,   -57,   -57,   -57
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -57,   -57,   -57,   -57,   -57,    71,   -57,   -41,   -25,   -57,
     -57,   -57,   -56,   -57,   -57,   -57,   -57,   -57,   -57
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      44,    55,    20,    65,    21,     4,     1,     5,    20,     8,
      21,     6,    43,    13,    20,    75,    21,     9,    62,    10,
      14,    22,    23,    24,    74,    12,    70,    22,    23,    24,
      44,    37,    11,    22,    23,    24,    20,    76,    21,    20,
      33,    21,    89,    38,    39,    44,    94,    15,    34,    77,
      78,    85,    86,    87,    88,    22,    23,    24,    22,    23,
      24,    17,    35,    36,    44,    45,    40,    41,    47,    42,
      48,    51,    49,    50,    53,    56,    58,    57,    68,    71,
      59,    60,    64,    63,    66,    72,    61,    67,    81,    69,
      90,     0,    79,    91,    83,    84,    80,    92,    93,     0,
       0,     0,     0,     0,     0,     0,    46
};

static const yytype_int8 yycheck[] =
{
      25,    42,     6,    59,     8,     4,     3,     0,     6,    12,
       8,     7,    16,    18,     6,    71,     8,     6,    16,     5,
      15,    25,    26,    27,    16,    12,    67,    25,    26,    27,
      55,    11,    17,    25,    26,    27,     6,    11,     8,     6,
      11,     8,    83,    23,    24,    70,    16,     7,    13,    23,
      24,    19,    20,    21,    22,    25,    26,    27,    25,    26,
      27,     8,    14,    17,    89,     9,    17,    17,    10,    15,
       9,     8,    13,    13,     8,    18,    11,    13,    26,    17,
      13,    12,     9,    13,     9,     8,    18,    15,     8,    13,
       9,    -1,    18,     9,    15,    13,    18,     9,     9,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    35
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,    30,    31,     4,     0,     7,    32,    12,     6,
       5,    17,    12,    18,    15,     7,    33,     8,    34,    35,
       6,     8,    25,    26,    27,    36,    37,    38,    39,    44,
      45,    46,    47,    11,    13,    14,    17,    11,    23,    24,
      17,    17,    15,    16,    37,     9,    34,    10,     9,    13,
      13,     8,    40,     8,    41,    36,    18,    13,    11,    13,
      12,    18,    16,    13,     9,    41,     9,    15,    26,    13,
      36,    17,     8,    42,    16,    41,    11,    23,    24,    18,
      18,     8,    43,    15,    13,    19,    20,    21,    22,    36,
       9,     9,     9,     9,    16
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:

/* Line 1455 of yacc.c  */
#line 119 "parser.y"
    { 
        (yyval.str) = mknode((yyvsp[(1) - (2)].str), (yyvsp[(2) - (2)].str), "program", "Program Structure"); 
        head = (yyval.str); 
    ;}
    break;

  case 3:

/* Line 1455 of yacc.c  */
#line 126 "parser.y"
    { 
        printf("Preprocessor directive parsed successfully!\n"); 
        (yyval.str) = mknode(NULL, NULL, "Preprocessor", "Preprocessor directive");
        add_token(keywords, &keyword_count, "#include");
        add_token(keywords, &keyword_count, "<stdio.h>");
    ;}
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 135 "parser.y"
    { 
        current_scope++; 
        printf("Function definition processed correctly!\n"); 
        (yyval.str) = mknode((yyvsp[(6) - (8)].str), (yyvsp[(7) - (8)].str), "Function", "Function definition");
        add_token(keywords, &keyword_count, "void");
        add_token(keywords, &keyword_count, "main");
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, "{");
        add_token(punctuations, &punctuation_count, "}");
        current_scope--; 
    ;}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 150 "parser.y"
    { 
        printf("Variables declared and initialized.\n"); 
        (yyval.str) = mknode((yyvsp[(2) - (3)].str), NULL, "Declarations", "Declarations");
        add_token(keywords, &keyword_count, "int");
        add_token(punctuations, &punctuation_count, ";");
    ;}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 160 "parser.y"
    { 
        (yyval.str) = mknode((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), "Declaration_List", "Declaration List");
        add_token(punctuations, &punctuation_count, ",");
    ;}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 167 "parser.y"
    { 
        char buffer[100];
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add((yyvsp[(1) - (3)].str), type, yylineno, current_scope); 
        (yyval.str) = mknode(NULL, NULL, "Var_Declaration", strdup(buffer)); // Ensure proper representation
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(constants, &constant_count, (yyvsp[(3) - (3)].str)); 
        add_token(operators, &operator_count, "=");
    ;}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 177 "parser.y"
    { 
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add((yyvsp[(1) - (1)].str), type, yylineno, current_scope); 
        (yyval.str) = mknode(NULL, NULL, "Var_Declaration", strdup((yyvsp[(1) - (1)].str))); 
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (1)].str)); 
    ;}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 187 "parser.y"
    { 
        (yyval.str) = mknode((yyvsp[(1) - (2)].str), (yyvsp[(2) - (2)].str), "Statements", "Statement List");
    ;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 205 "parser.y"
    { 
        current_scope++; // Increase scope level for the loop
        printf("For loop parsed successfully!\n"); 
        (yyval.str) = mknode(mknode((yyvsp[(3) - (11)].str), mknode((yyvsp[(5) - (11)].str), (yyvsp[(7) - (11)].str), "For_Update", "For Update"), "For_Loop", "For Loop"), NULL, "For_Loop", "For Loop Body");
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
        fprintf(output_file,"MOV %s, %s\n", (yyvsp[(3) - (11)].str), (yyvsp[(5) - (11)].str)); // Initial assignment for the loop variable
        fprintf(output_file,"%s:\n", start_label); 
        generate_for_loop((yyvsp[(4) - (11)].str), (yyvsp[(6) - (11)].str)); // Use $5 for the condition limit
        printf("Loop body code generation:\n");
        
        // Generate the condition check and jump
        generate_cmp((yyvsp[(8) - (11)].str), (yyvsp[(6) - (11)].str)); 
        generate_conditional_jump("JE", end_label);
        fprintf(output_file,"    ; Output: printf(\"For loop\")\n"); // Output for the for loop
        fprintf(output_file,"    JMP %s\n", start_label);  // Jump back to the start of the loop
        fprintf(output_file,"%s:\n", end_label);  // End label
    ;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 236 "parser.y"
    { 
        generate_assignment((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)); 
        printf("For loop initialization parsed.\n"); 
        snprintf(type, sizeof(type), "int"); // Assigning data type
        add((yyvsp[(1) - (3)].str), type, yylineno, current_scope); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)); // Correct handling
        (yyval.str) = mknode(NULL, NULL, "For_Initialization", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(constants, &constant_count, (yyvsp[(3) - (3)].str)); 
        add_token(operators, &operator_count, "=");
    ;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 251 "parser.y"
    { 
        printf("Condition parsed: %s %s %s\n", (yyvsp[(1) - (3)].str), (yyvsp[(2) - (3)].str), (yyvsp[(3) - (3)].str));
        (yyval.str) = (yyvsp[(3) - (3)].str);
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s %s %s", (yyvsp[(1) - (3)].str), (yyvsp[(2) - (3)].str), (yyvsp[(3) - (3)].str)); // Ensure correct condition representation
        (yyval.str) = mknode(NULL, NULL, "Condition", strdup(buffer)); 
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(constants, &constant_count, (yyvsp[(3) - (3)].str)); 
        add_token(operators, &operator_count, "<");
    ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 264 "parser.y"
    { 
        generate_increment((yyvsp[(1) - (2)].str));
        printf("For loop update parsed.\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s++", (yyvsp[(1) - (2)].str));
        (yyval.str) = mknode(NULL, NULL, "For_Update", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (2)].str)); 
        add_token(operators, &operator_count, "++");
    ;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 274 "parser.y"
    { 
        generate_decrement((yyvsp[(1) - (2)].str));
        char buffer[100];
        printf("For loop update parsed.\n"); 
        snprintf(buffer, sizeof(buffer), "%s--", (yyvsp[(1) - (2)].str));
        (yyval.str) = mknode(NULL, NULL, "For_Update", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (2)].str)); 
        add_token(operators, &operator_count, "--");
    ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 284 "parser.y"
    { 
        generate_assignment((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)); 
        printf("For loop update parsed.\n");
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)); // Assume arithmetic_expression returns a valid string
        (yyval.str) = mknode(NULL, NULL, "For_Update", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(operators, &operator_count, "=");
    ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 296 "parser.y"
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("ADD", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), temp);
        generate_code_add((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), temp); // Generate intermediate code for addition
        (yyval.str) = temp;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s + %s", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)); // Ensure correct handling
        (yyval.str) = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(constants, &constant_count, (yyvsp[(3) - (3)].str));  
        add_token(operators, &operator_count, "+");
    ;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 310 "parser.y"
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        generate_code("SUB", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), temp);
        generate_code_sub((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), temp); // Generate intermediate code for subtraction
        (yyval.str) = temp;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s - %s", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)); // Ensure correct handling
        (yyval.str) = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(constants, &constant_count, (yyvsp[(3) - (3)].str)); 
        add_token(operators, &operator_count, "-");
    ;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 324 "parser.y"
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        if (atoi((yyvsp[(3) - (3)].str)) == 2) {
            // Replace x * 2 with x << 1
            generate_code("SHL", (yyvsp[(1) - (3)].str), "1", temp); 
            generate_code_mul_2((yyvsp[(1) - (3)].str), "1", temp); // SHL is bitwise left shift// SHL is bitwise left shift
        } else if (atoi((yyvsp[(3) - (3)].str)) == 4) {
            // Replace x * 4 with x << 2
            generate_code("SHL", (yyvsp[(1) - (3)].str), "2", temp);
            generate_code_mul_4((yyvsp[(1) - (3)].str), "2", temp); // SHL is bitwise left shift // SHL is bitwise left shift
        } else {
            generate_code("MUL", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), temp); 
            generate_code_mul((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), temp); // Generate intermediate code for multiplication// Generate intermediate code for multiplication
        }
        (yyval.str) = temp;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s * %s", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)); // Ensure correct handling
        (yyval.str) = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(constants, &constant_count, (yyvsp[(3) - (3)].str)); 
        add_token(operators, &operator_count, "*");
    ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 348 "parser.y"
    { 
        printf("Arithmetic expression parsed.\n");
        char *temp = new_temp();
        if (atoi((yyvsp[(3) - (3)].str)) == 2) {
            // Replace x / 2 with x >> 1
            generate_code("SHR", (yyvsp[(1) - (3)].str), "1", temp); 
            generate_code_div_2((yyvsp[(1) - (3)].str), "1", temp); // SHR is bitwise right shift// SHR is bitwise right shift
        } else if (atoi((yyvsp[(3) - (3)].str)) == 4) {
            // Replace x / 4 with x >> 2
            generate_code("SHR", (yyvsp[(1) - (3)].str), "2", temp); 
            generate_code_div_4((yyvsp[(1) - (3)].str), "2", temp); // SHR is bitwise right shift// SHR is bitwise right shift
        } else {
            generate_code("DIV", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), temp); 
            generate_code_div((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str), temp); // Generate intermediate code for division// Generate intermediate code for division
        }
        (yyval.str) = temp;
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s / %s", (yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].str)); // Ensure correct handling
        (yyval.str) = mknode(NULL, NULL, "Arithmetic_Expression", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(constants, &constant_count, (yyvsp[(3) - (3)].str)); 
        add_token(operators, &operator_count, "/");
    ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 374 "parser.y"
    { 
        current_scope++; 
        printf("While loop parsed successfully!\n"); 
        (yyval.str) = mknode((yyvsp[(3) - (7)].str), (yyvsp[(6) - (7)].str), "While_Loop", "While Loop");
        add_token(keywords, &keyword_count, "while");
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, "{");
        add_token(punctuations, &punctuation_count, "}");
        current_scope--; 
        char* start_label = new_label(); 
        char* end_label = new_label(); 

        printf("%s:\n", start_label);
        generate_while_loop((yyvsp[(4) - (7)].str)); // Generate while loop with condition
        
        // Generate the condition check and jump
        generate_cmp((yyvsp[(7) - (7)].str), (yyvsp[(4) - (7)].str)); 
        generate_conditional_jump("JE", end_label); // Jump to end if condition is false

        fprintf(output_file,"    ; Output: printf(\"While loop\")\n");  // Output for the while loop
        fprintf(output_file,"    JMP %s\n", start_label);  // Jump back to the start of the loop
        fprintf(output_file,"%s:\n", end_label);  // End label

        // Loop body
        printf("Loop body code generation:\n");
        printf("%s:\n", end_label);
    ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 405 "parser.y"
    { 
        current_scope++; // Increase scope level for the loop
        printf("Do-while loop parsed successfully!\n"); 
        struct node *bodyNode = mknode((yyvsp[(3) - (9)].str), NULL, "Do_While_Body", "Do While Body");
        (yyval.str) = mknode(bodyNode, (yyvsp[(6) - (9)].str), "Do_While_Loop", "Do While Loop");
        add_token(keywords, &keyword_count, "do");
        add_token(keywords, &keyword_count, "while");
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, ";");
        current_scope--; // Decrease scope level after loop
         char* start_label = new_label(); 
        char* end_label = new_label(); 

        printf("%s:\n", start_label);

        fprintf(output_file,"    ; Output: printf(\"Do-while loop\")\n");  // Output for the do-while loop
        fprintf(output_file,"    INC %s\n", (yyvsp[(1) - (9)].str));  // Increment first, for demonstration
        generate_do_while_loop((yyvsp[(6) - (9)].str)); // Generate do-while loop with condition
        
        // Generate the condition check and jump
        generate_cmp((yyvsp[(6) - (9)].str), (yyvsp[(8) - (9)].str)); 
        generate_conditional_jump("JE", end_label); 
        
        
        fprintf(output_file,"    JMP %s\n", start_label);  // Jump back to the start of the loop
        fprintf(output_file,"%s:\n", end_label);  // End label// Jump to end if condition is false

        // Loop body
        printf("Loop body code generation:\n");
        printf("%s:\n", end_label);
    ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 440 "parser.y"
    { 
        printf("Function call encountered!\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "printf(%s)", (yyvsp[(3) - (5)].str)); // Assume STRING_LITERAL is valid
        (yyval.str) = mknode(NULL, NULL, "Function_Call", strdup(buffer));
        add_token(keywords, &keyword_count, "printf");
        add_token(strings, &string_count, (yyvsp[(3) - (5)].str));
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, ";");
    ;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 454 "parser.y"
    { 
        generate_assignment((yyvsp[(1) - (4)].str), (yyvsp[(3) - (4)].str));
        snprintf(type, sizeof(type), "int"); 
        add((yyvsp[(1) - (4)].str), type, yylineno, current_scope); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s = %s", (yyvsp[(1) - (4)].str), (yyvsp[(3) - (4)].str)); // Correct handling
        (yyval.str) = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (4)].str)); 
        add_token(constants, &constant_count, (yyvsp[(3) - (4)].str));
        add_token(operators, &operator_count, "=");
        add_token(punctuations, &punctuation_count, ";");
    ;}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 467 "parser.y"
    { 
        generate_increment((yyvsp[(1) - (3)].str));
        printf("Increment operation parsed.\n");
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s++", (yyvsp[(1) - (3)].str));
        (yyval.str) = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(operators, &operator_count, "++");
        add_token(punctuations, &punctuation_count, ";");
    ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 478 "parser.y"
    { 
        generate_decrement((yyvsp[(1) - (3)].str));
        printf("Decrement operation parsed.\n");
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "%s--", (yyvsp[(1) - (3)].str));
        (yyval.str) = mknode(NULL, NULL, "Expression_Statement", strdup(buffer));
        add_token(identifiers, &identifier_count, (yyvsp[(1) - (3)].str)); 
        add_token(operators, &operator_count, "--");
        add_token(punctuations, &punctuation_count, ";");
    ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 489 "parser.y"
    { 
        printf("Function call encountered!\n"); 
        char buffer[100];
        snprintf(buffer, sizeof(buffer), "printf(%s)", (yyvsp[(3) - (5)].str)); // Assume STRING_LITERAL is valid
        (yyval.str) = mknode(NULL, NULL, "Function_Call", strdup(buffer));
        add_token(strings, &string_count, (yyvsp[(3) - (5)].str));
        add_token(punctuations, &punctuation_count, "(");
        add_token(punctuations, &punctuation_count, ")");
        add_token(punctuations, &punctuation_count, ";");
    ;}
    break;



/* Line 1455 of yacc.c  */
#line 1987 "parser.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 500 "parser.y"
  

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

void generate_assignment(const char* var, const char* expr) {
    fprintf(output_file, "MOV %s, %s\n", var, expr); // Move expr into var
}

void generate_increment(const char* variable) {  
    char* temp = new_temp();  
    printf("Intermediate Code: %s = %s + 1\n", temp, variable);  
    fprintf(output_file, "INC %s\n", variable); // Increment var
}  

void generate_decrement(const char* variable) {  
    char* temp = new_temp();  
    printf("Intermediate Code: %s = %s - 1\n", temp, variable); 
    fprintf(output_file, "DEC %s\n", variable); // Decrement var
} 



void generate_code_add(char* left, char* right, char* temp) {
    fprintf(output_file, "ADD %s, %s, %s\n", left, right, temp); // Generate add code
}

void generate_code_sub(char* left, char* right, char* temp) {
    fprintf(output_file, "SUB %s, %s, %s\n", left, right, temp); // Generate subtract code
}

void generate_code_mul(char* left, char* right, char* temp) {
    fprintf(output_file, "MUL %s, %s, %s\n", left, right, temp); // Generate multiply code
}

void generate_code_div(char* left, char* right, char* temp) {
    fprintf(output_file, "DIV %s, %s, %s\n", left, right, temp); // Generate divide code
}

void generate_for_loop(const char* loop_var, const char* limit) {  
    printf("For loop variable: %s, Limit: %s\n", loop_var, limit);
    fprintf(output_file,"For loop variable: %s, Limit: %s\n", loop_var, limit);  
}  

void generate_while_loop(const char* condition) {  
    printf("While loop condition: %s\n", condition);  
    fprintf(output_file, "WHILE loop for condition: %s\n", condition);
}


void generate_do_while_loop(const char* condition) {  
    printf("Do-while loop condition: %s\n", condition);  
    fprintf(output_file, "DO-WHILE loop for condition: %s\n", condition);
}  

void generate_cmp(const char* operand1, const char* operand2) {  
    printf("Intermediate Code: CMP %s, %s\n", operand1, operand2);  
    fprintf(output_file, "CMP %s, %s\n", operand1, operand2); // Compare the two operands
}  

void generate_jump(const char* label) {  
    printf("Intermediate Code: JMP %s\n", label); 
    fprintf(output_file, "JUMP %s\n", label); 
}  

void generate_conditional_jump(const char* condition, const char* label) {  
    printf("Intermediate Code: %s %s\n", condition, label);  
    fprintf(output_file, "JUMP_IF_FALSE %s\n", label);
}  

void generate_code_jump(char* label) {
    fprintf(output_file, "JUMP %s\n", label);
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

    fclose(yyin);
    fclose(output_file); 

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

