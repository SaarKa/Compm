%{
	#include <stdio.h>
	#include "part2_helpers.h"
	#include "part2.tab.h"

%}

%option yylineno
%option noyywrap


digit			[0-9]
id			[a-zA-Z]({digit}|[a-zA-Z]|_)*
integernum		{digit}+
realnum			{digit}+\.{digit}+
str			\"(([^"\n\r\\])|(\\[\"nt]))*\"
symbol			[(){},;:\.]
relop			==|<>|<|<=|>|>=
addop			\+|\-
mulop			\*|\/ 
assign			=
and			&&
or			\|\|
not			!
comment			#[^\n\r]*
whitespaces		[\t ]
newline			[\n\r]

%%

int				{
				yylval = makeNode(yytext, NULL, NULL);
				return INT;
				}
float			{
				yylval = makeNode(yytext, NULL, NULL);
				return FLOAT;
				}
void			{
				yylval = makeNode(yytext, NULL, NULL);
				return VOID;
				}
write			{
				yylval = makeNode(yytext, NULL, NULL);
				return WRITE;
				}
read			{
				yylval = makeNode(yytext, NULL, NULL);
				return READ;
				}
while			{
				yylval = makeNode(yytext, NULL, NULL);
				return WHILE;
				}
do				{
				yylval = makeNode(yytext, NULL, NULL);
				return DO;
				}
if				{
				yylval = makeNode(yytext, NULL, NULL);
				return IF;
				}
then			{
				yylval = makeNode(yytext, NULL, NULL);
				return THEN;
				}
else			{
				yylval = makeNode(yytext, NULL, NULL);
				return ELSE;
				}
return			{
				yylval = makeNode(yytext, NULL, NULL);
				return RETURN;
				}
full_while		{
				yylval = makeNode(yytext, NULL, NULL);
				return FULL_WHILE;
				}
break			{
				yylval = makeNode(yytext, NULL, NULL);
				return BREAK;
				}
{integernum}	{
				yylval = makeNode("integernum", yytext, NULL);
				return INTEGERNUM;
				}
{id}			{
				yylval = makeNode("id", yytext, NULL);
				return ID;
				}
{symbol}		{
				yylval = makeNode(yytext, NULL, NULL);
				return yytext[0];
				}
{realnum}		{
				yylval = makeNode("realnum", yytext, NULL);
				return REALNUM;
				}
{str}			{
				char* s = yytext;
				s[yyleng-1]=0;
				s++;
				yylval = makeNode("str", s, NULL);
				return STR;
				}
{relop}			{
				yylval = makeNode("relop", yytext, NULL);
				return RELOP;
				}
{addop}			{
				yylval = makeNode("addop", yytext, NULL);
				return ADDOP;
				}
{mulop}			{
				yylval = makeNode("mulop", yytext, NULL);
				return MULOP;
				}
{assign}		{
				yylval = makeNode("assign", yytext, NULL);
				return ASSIGN;
				}
{and}			{
				yylval = makeNode("and", yytext, NULL);
				return AND;
				}
{or}			{
				yylval = makeNode("or", yytext, NULL);
				return OR;
				}
{not}			{
				yylval = makeNode("not", yytext, NULL);
				return NOT;
				}
{whitespaces}	{} 
{newline}		{}
{comment}		{}
.				{
				printf("Lexical error: '%s' in line number %d\n", yytext, yylineno);
				exit(1);
				}
%%

