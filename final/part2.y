%{
	#include "part2_helpers.h"
	#include <stdio.h>
	
	void yyerror(const char* c);
	extern int yylineno;
	extern char* yytext;
	extern int yylex();
	ParserNode *parseTree;

%}
	
	%token ID
	%token INT
	%token FLOAT
	%token VOID
	%token INTEGERNUM
	%token REALNUM
	%token BREAK
	%token RETURN
	%token WRITE
	%token STR
	%token READ
	%token FULL_WHILE
	%token WHILE
	%token DO
	%token IF
	%precedence THEN
	%precedence ELSE
	%left ','
	%right ASSIGN
	%left OR
	%left AND
	%left RELOP
	%left ADDOP
	%left MULOP
	%right NOT
	%left ';'
	%left '('
	%left ')'
	%left '{'
	%left '}'
	%left ':'

%%
	program		: fdefs
					{
						$$ = makeNode("PROGRAM", NULL, $1);
						parseTree = $$;
					};
	fdefs		: fdefs func_api blk
					{
						$$ = makeNode("FDEFS", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|fdefs func_api ';'
					{
						$$ = makeNode("FDEFS", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|/*EPSILON*/
					{
						ParserNode* eps = makeNode("EPSILON", NULL, NULL);
						$$ = makeNode("FDEFS", NULL, eps);
					};
	func_api	: type ID '(' func_args ')'
					{
						$$ = makeNode("FUNC_API", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
					};
	func_args 	: func_arglist
					{
						$$ = makeNode("FUNC_ARGS", NULL, $1);
					}
					|/*EPSILON*/
					{
						ParserNode* eps = makeNode("EPSILON", NULL, NULL);
						$$ = makeNode("FUNC_ARGS", NULL, eps);
					};
	func_arglist: func_arglist ',' dcl
					{
						$$ = makeNode("FUNC_ARGLIST", NULL, $1);
						concatList($1, $2);
						concatList($1, $3); 
					}
					|dcl
					{
						$$ = makeNode("FUNC_ARGLIST", NULL, $1);
					};
	blk			: '{' stlist '}'
					{
						$$ = makeNode("BLK", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					};
	dcl			: ID ':' type
					{
						$$ = makeNode("DCL", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);	
					}
					| ID ',' dcl
					{
						$$ = makeNode("DCL", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);		
					};
	type		: INT
					{
						$$ = makeNode("TYPE", NULL, $1);
					}
					|FLOAT
					{
						$$ = makeNode("TYPE", NULL, $1);
					}
					|VOID
					{
						$$ = makeNode("TYPE", NULL, $1);
					};
	stlist		: stlist stmt
					{
						$$ = makeNode("STLIST", NULL, $1);
						concatList($1, $2);
					}
					|/*EPSILON*/
					{
						ParserNode* eps = makeNode("EPSILON", NULL, NULL);
						$$ = makeNode("STLIST", NULL, eps);
					};
	stmt		: dcl ';'
					{
						$$ = makeNode("STMT", NULL, $1);
						concatList($1, $2);
					}
					|assn
					{
						$$ = makeNode("STMT", NULL, $1);
					}
					|exp ';'
					{
						$$ = makeNode("STMT", NULL, $1);
						concatList($1, $2);
					}
					|cntrl
					{
						$$ = makeNode("STMT", NULL, $1);
					}
					|read
					{
						$$ = makeNode("STMT", NULL, $1);
					}
					|write
					{
						$$ = makeNode("STMT", NULL, $1);
					}
					|return
					{
						$$ = makeNode("STMT", NULL, $1);
					}
					|blk
					{
						$$ = makeNode("STMT", NULL, $1);
					}
					|BREAK ';'
					{
						$$ = makeNode("STMT", NULL, $1);
						concatList($1, $2);
					};
	return 		: RETURN exp ';'
					{
						$$ = makeNode("RETURN", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					| RETURN ';'
					{
						$$ = makeNode("RETURN", NULL, $1);
						concatList($1, $2);
					};
	write		: WRITE '(' exp ')' ';'
					{
						$$ = makeNode("WRITE", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
					}
					| WRITE '(' STR ')' ';'
					{
						$$ = makeNode("WRITE", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
					};
	read		: READ '(' lval ')' ';'
					{
						$$ = makeNode("READ", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
					};
	assn		: lval ASSIGN exp ';'
					{
						$$ = makeNode("ASSN", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					};
	lval		: ID
					{
						$$ = makeNode("LVAL", NULL, $1);
					};
	fullwhile	: FULL_WHILE bexp DO stmt
					{
						$$ = makeNode("FULLWHILE", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					};
	cntrl		: IF bexp THEN stmt ELSE stmt
					{
						$$ = makeNode("CNTRL", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
						concatList($1, $6);
					}
					| IF bexp THEN stmt
					{
						$$ = makeNode("CNTRL", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					}
					| WHILE bexp DO stmt
					{
						$$ = makeNode("CNTRL", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					}
					|fullwhile
					{
						$$ = makeNode("CNTRL", NULL, $1);
					};
	bexp		: bexp OR bexp
					{
						$$ = makeNode("BEXP", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|bexp AND bexp
					{
						$$ = makeNode("BEXP", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|NOT bexp
					{
						$$ = makeNode("BEXP", NULL, $1);
						concatList($1, $2);
					}
					|exp RELOP exp
					{
						$$ = makeNode("BEXP", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|'(' bexp ')'
					{
						$$ = makeNode("BEXP", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|fullwhile
					{
						$$ = makeNode("BEXP", NULL, $1);
					};
	exp			: exp ADDOP exp
					{
						$$ = makeNode("EXP", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|exp MULOP exp
					{
						$$ = makeNode("EXP", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|'(' exp ')'
					{
						$$ = makeNode("EXP", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|'(' type ')' exp
					{
						$$ = makeNode("EXP", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					}
					|ID
					{
						$$ = makeNode("EXP", NULL, $1);
					}
					|num
					{
						$$ = makeNode("EXP", NULL, $1);
					}
					|call
					{
						$$ = makeNode("EXP", NULL, $1);
					};
	num			: INTEGERNUM
					{
						$$ = makeNode("NUM", NULL, $1);
					}
					|REALNUM
					{
						$$ = makeNode("NUM", NULL, $1);
					};
	call		: ID '(' call_args ')'
					{
						$$ = makeNode("CALL", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					};
	call_args	: call_arglist
					{
						$$ = makeNode("CALL_ARGS", NULL, $1);
					}
					|/*EPSILON*/
					{
						ParserNode* eps = makeNode("EPSILON", NULL, NULL);
						$$ = makeNode("CALL_ARGS", NULL, eps);
					};
	call_arglist: call_arglist ',' exp
					{
						$$ = makeNode("CALL_ARGLIST", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					} 
					|exp
					{
						$$ = makeNode("CALL_ARGLIST", NULL, $1);
					};	

%%

void yyerror(const char* c){
	printf("Syntax error: '%s' in line number %d\n", yytext, yylineno);
	exit(2);
}
