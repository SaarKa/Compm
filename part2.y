%{
	#include <iostream>
	#include <map>
	#include <string>
	#include "t7.hpp"
	#include "part2_helpers.h"
	using namespace std;
	
	void yyerrOR(const char* c);
	extern int yylineno;
	extern char* yytext;
	extern int yylex();

	map<string, int> vars;
}%
	
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
	%token DO
	%token IF
	%token THEN
	%token ELSE
	%right ASSIGN
	%right NOT
	%left OR
	%left AND
	%left RELOP
	%left ADDOP
	%left MULOP
	%left ';'
	%left '('
	%left ')'
	%left ','
	%left '{'
	%left '}'
	%left ':'

	
%%
	program		: fdefs
					{
						$$ = makeNode("program", NULL, $1);
						parseTree = $$;
					};
	fdefs		: fdefs func_api blk
					{
						$$ = makeNode("fdefs", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|fdefs func_api ';'
					{
						$$ = makeNode("fdefs", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|/*EPSILON*/
					{
						*makeNode eps = makeNode("EPSILON", NULL, NULL) 
						$$ = makeNode("fdefs", NULL, eps);
					};
	func_api	: type ID '(' func_args ')'
					{
						$$ = makeNode("func_api", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
					};
	func_args 	: func_arglist
					{
						$$ = makeNode("func_args", NULL, $1);
					}
					|/*EPSILON*/
					{
						*makeNode eps = makeNode("EPSILON", NULL, NULL);
						$$ = makeNode("func_api", NULL, eps);
					};
	func_arglist: func_arglist ',' dcl
					{
						$$ = makeNode("func_arglist", NULL, $1);
						concatList($1, $2);
						concatList($1, $3); 
					}
					|dcl
					{
						$$ = makeNode("func_arglist", NULL, $1);
					};
	blk			: '{' stlist '}'
					{
						$$ = makeNode("blk", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					};
	dcl			: ID ':' type
					{
						$$ = makeNode("dcl", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);	
					}
					| ID ',' dcl
					{
						$$ = makeNode("dcl", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);		
					};
	type		: INT
					{
						$$ = makeNode("type", NULL, $1);
					}
					|FLOAT
					{
						$$ = makeNode("type", NULL, $1);
					}
					|VOID
					{
						$$ = makeNode("type", NULL, $1);
					};
	stlist		: stlist stmt
					{
						$$ = makeNode("stlist", NULL, $1);
					}
					|/*EPSILON*/
					{
						*makeNode eps = makeNode("EPSILON", NULL, NULL);
						$$ = makeNode("func_api", NULL, eps);
					};
	stmt		: dcl ';'
					{
						$$ = makeNode("stmt", NULL, $1);
						concatList($1, $2);
					}
					|assn
					{
						$$ = makeNode("stmt", NULL, $1);
					}
					|exp ';'
					{
						$$ = makeNode("stmt", NULL, $1);
						concatList($1, $2);
					}
					|cntrl
					{
						$$ = makeNode("stmt", NULL, $1);
					}
					|read
					{
						$$ = makeNode("stmt", NULL, $1);
					}
					|write
					{
						$$ = makeNode("stmt", NULL, $1);
					}
					|return
					{
						$$ = makeNode("stmt", NULL, $1);
					}
					|blk
					{
						$$ = makeNode("stmt", NULL, $1);
					}
					|BREAK ';'
					{
						$$ = makeNode("stmt", NULL, $1);
						concatList($1, $2);
					};
	return 		: RETURN exp ';'
					{
						$$ = makeNode("return", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					| RETURN ';'
					{
						$$ = makeNode("return", NULL, $1);
						concatList($1, $2);
					};
	write		: WRITE '(' exp ')' ';'
					{
						$$ = makeNode("write", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
					}
					| WRITE '(' STR ')' ';'
					{
						$$ = makeNode("write", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
					};
	read		: READ '(' lval ')' ';'
					{
						$$ = makeNode("read", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
					};
	assn		: lval ASSIGN exp ';'
					{
						$$ = makeNode("assn", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					};
	lval		: ID
					{
						$$ = makeNode("lval", yytext, $1);
					};
	fullwhile	: FULL_WHILE bexp DO stmt
					{
						$$ = makeNode("fullwhile", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					};
	cntrl		: IF bexp THEN stmt ELSE stmt
					{
						$$ = makeNode("cntrl", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
						concatList($1, $5);
						concatList($1, $6);
					}
					| IF bexp THEN stmt
					{
						$$ = makeNode("cntrl", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					}
					| WHILE bexp DO stmt
					{
						$$ = makeNode("cntrl", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					}
					|fullwhile
					{
						$$ = makeNode("cntrl", NULL, $1);
					};
	bexp		: bexp OR bexp
					{
						$$ = makeNode("bexp", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|bexp AND bexp
					{
						$$ = makeNode("bexp", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|NOT bexp
					{
						$$ = makeNode("bexp", NULL, $1);
						concatList($1, $2);
					}
					|exp RELOP exp
					{
						$$ = makeNode("bexp", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|'(' bexp ')'
					{
						$$ = makeNode("bexp", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|fullwhile
					{
						$$ = makeNode("bexp", NULL, $1);
					};
	exp			: exp ADDOP exp
					{
						$$ = makeNode("exp", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|exp MULOP exp
					{
						$$ = makeNode("exp", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|'(' exp ')'
					{
						$$ = makeNode("exp", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					}
					|'(' type ')' exp
					{
						$$ = makeNode("exp", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					}
					|ID
					{
						$$ = makeNode("exp", NULL, $1);
					}
					|num
					{
						$$ = makeNode("exp", NULL, $1);
					}
					|call
					{
						$$ = makeNode("exp", NULL, $1);
					};
	num			: INTEGERNUM
					{
						$$ = makeNode("num", NULL, $1);
					}
					|REALNUM
					{
						$$ = makeNode("num", NULL, $1);
					};
	call		: ID '(' call_args ')'
					{
						$$ = makeNode("call", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
						concatList($1, $4);
					};
	call_args	: call_arglist
					{
						$$ = makeNode("call_args", NULL, $1);
					}
					|/*EPSILON*/
					{
						*makeNode eps = makeNode("EPSILON", NULL, NULL);
						$$ = makeNode("call_args", NULL, eps);
					};
	call_arglist: call_arglist ',' exp
					{
						$$ = makeNode("call_arglist", NULL, $1);
						concatList($1, $2);
						concatList($1, $3);
					} 
					|exp
					{
						$$ = makeNode("call_arglist", NULL, $1);
					};	

%%

void yyerror(const char* c){
	printf("\nSyntax error: %s in line number %d\n", yytext, yylineno);
	exit(2);
}