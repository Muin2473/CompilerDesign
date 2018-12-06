/* Compiler  Project: 1507119*/

%{
	#include <stdio.h>
	#include <string.h>
	#include "1.tab.h"
	#include <stdlib.h>
	

%}

identifiers "var_"[a-zA-Z]([a-zA-Z0-9])*
unary_operator "inc+"|"dec-"
single_line_comment [#].*
multiple_line_comment [ ]*[.][.][.][a-zA-Z0-9!@#*(){}_'+-,.:\|?><\n\t ]*[.][.][.]

/*RE and Action*/

%%


{single_line_comment} {
	printf("\nSingle line comment successful\n");

}
{multiple_line_comment} {
	printf("\nMultiple line comment done\n");
}

{unary_operator}   {return inc;}
"cbo"	 { return LB; } 
"cbc"	  { return RB; }
"dismiss"    {   return BREAK;     }
"event"      { return CASE;      }
"shift"      { return SWITCH;	}
"general"     {  return DEFAULT; 	}
"untill" { return WHILE;}
"Integer"	{ return INT; }
"Float"	{ return FLOAT; }
"Ch"	{ return CHAR; }
[:]     { return COL;}
[0-9]+	{ 
		yylval.number = atoi(yytext);
		return NUM;
	}
"since"   { return FOR;}	
"rbo"	{ return LP; }
"rbc"	{ return RP; }
",,"	{ return CM; }
";;"	{ return SM; }
"sum"	{ return PLUS;}
"sub"	{ return MINUS; }
"mul"	{ return MULT; }
"div"	{ return DIV; }
"exp"	{ return POW; }
"~="		{ return ASSIGN;  }
"gt"	{ return GT; }
"lt"	{ return LT; }

{identifiers} {
	 yylval.string=strdup(yytext);
	 return VAR;
	}

"checkIf"		{ return IF;}
"elseIf"		{ return ELIF; }
"Ifnot"			{ return ELSE;}

"action "[A-Za-z]+	{ return MAIN; }

[ \t\n]*	

.	{
		yyerror("Unknown Character.\n");
	}
%%

/* user subroutines */

int main()
{
	yyin = freopen("in.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();
	
}

