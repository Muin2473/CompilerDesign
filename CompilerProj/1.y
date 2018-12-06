/* Compiler  Project: 1507119 */

%{
	#include<stdio.h>
	#include <math.h>
	int cnt=1,cntt=0,val;
	typedef struct entry {
    	char *str;
    	int n;
	}store;
	store st[1000],sym[1000];
	void ins(store *p, char *s, int n);
	int cnt2=1; 
	void ins2 (store *p, char *s, int n);
	
%}
%union 
{
        int number;
        char *string;
}
/* BISON Declarations */

%token <number> NUM
%token <string> VAR 
%token <string> IF ELSE ELIF MAIN INT FLOAT DOUBLE CHAR LP RP LB RB CM SM PLUS MINUS MULT DIV POW ASSIGN FOR COL WHILE BREAK DEFAULT CASE SWITCH inc 
%type <string> statement
%type <number> expression
%nonassoc IFX
%nonassoc ELSE
%left LT GT
%left PLUS MINUS
%left MULT DIV
%left POW

/* Simple grammar rules */

%%

program: MAIN LP RP LB cstatement RB { printf("\nCongratulations! Compilation Successful :D\n"); }
	 ;

cstatement: /* empty */

	| cstatement statement
	
	| cdeclaration
	;

cdeclaration:	TYPE ID1 SM	{ printf("\nValid declaration\n"); }
   
			;
			
TYPE : INT

     | FLOAT

     | CHAR
     ;

ID1  : ID1 CM VAR	{
						if(look_for_key($3))
						{
							printf("\n%s is already declared!\n", $3 );
						}
						else
						{
							ins(&st[cnt],$3, cnt);
							cnt++;
							
						}
			}

     |VAR	{
				if(look_for_key($1))
				{
					printf("\n%s is already declared!\n", $1 );
				}
				else
				{
					ins(&st[cnt],$1, cnt);
							cnt++;
				}
			}
     ;

statement: SM
	| SWITCH LP expression RP LB BASE RB    {printf("This is a 'switch case'.\n");val=$3;} 

	| expression SM 			{ printf("\nValue of expression: %d\n", ($1)); }

        | VAR ASSIGN expression SM 		{
							if(look_for_key($1)){
								int i = look_for_key2($1);
								if (!i){
									ins(&sym[cntt], $1, $3);
									cntt++;
								}
								sym[i].n = $3;
								printf("\n(%s) Value of the variable: %d\t\n",$1,$3);
							}
							else {
								printf("\n%s Not declared yet!\n",$1);
							}
							
						}

	| IF LP expression RP LB expression SM RB %prec IFX {
								if($3)
								{
									printf("\nValue of expression in IF: %d\n",($6));
								}
								else
								{
									printf("\nCondition value '0' in IF block\n");
								}
							}

	| IF LP expression RP LB expression SM RB ELSE LB expression SM RB {
								 	if($3)
									{
										printf("\nValue of expression in IF: %d\n",$6);
									}
									else
									{
										printf("\nValue of expression in ELSE: %d\n",$11);
									}
								   }
	| IF LP expression RP LB IF LP expression RP LB expression SM RB ELSE LB expression SM RB expression SM RB ELSE LB expression SM RB %prec IFX {
								 	if($3)
									{
										if($8)
											printf("\nValue of expression nested IF: %d\n",$11);
										else
											printf("\nValue of expression nested ELSE: %d\n",$16);
										printf("\nValue of expression in first IF: %d\n",$19);
									}
									else
									{
										printf("\nValue of expression in else: %d\n",$24);
									}
								   }
	| IF LP expression RP LB expression SM RB ELIF LP expression RP LB expression SM RB ELSE LB expression SM RB {
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else if($11)
									{
										printf("\nvalue of expression in elseIF: %d\n",$14);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$19);
									}
								   }		
						   
	| FOR LP NUM COL NUM RP LB expression RB     {
	   int i=0;
	   for(i=$3;i<$5;i++){
	   printf("\nThis is a 'for loop' statement\n");
	   }
	   printf("\n");
	   printf("Value of the expression: %d\n",$8);
	}
	| WHILE LP NUM GT NUM RP LB expression RB   {
										int i;
										printf("\nWhile LOOP: ");
										for(i=$3;i<=$5;i++)
										{
											printf("%d ",i);
										}
										printf("\n");
										printf("Value of the expression: %d\n",$8);

	}
	;

///////////////////////
	
			BASE : Bas   
				 | Bas Dflt 
				 ;

			Bas   : /*NULL*/
				 | Bas Cs     
				 ;

			Cs    : CASE NUM COL expression SM   {
						if($2==2){
							  cntt=1;
							  printf("\nCase No : %d  and Result :  %d\n",$2,$4);
						}
					}
				 ;

			Dflt    : DEFAULT COL NUM SM    {
						if(cntt==0){
							printf("\nResult in default value is :  %d \n",$3);
						}
					}
				 ;

/////////////////////////////
	
	
expression: NUM				{ $$ = $1; 	}

	| VAR				{ $$ = look_for_key2($1); printf("Variable value: %d",$$)}

	| expression PLUS expression	{ $$ = $1 + $3; }

	| expression MINUS expression	{ $$ = $1 - $3; }

	| expression MULT expression	{ $$ = $1 * $3; }

	| expression DIV expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\nDivision by zero\t");
				  		} 	
				    	}
	| expression POW expression { $$ = pow($1,$3); }


	| expression LT expression	{ $$ = $1 < $3; }

	| expression GT expression	{ $$ = $1 > $3; }

	| LP expression RP		{ $$ = $2;	}
	
	| inc expression inc         { $$=$2+1; printf("\nValue after increment: %d\n",$$);}
	;
%%
//////////////////////////
void ins(store *p, char *s, int n)
{
  p->str = s;
  p->n = n;
}

int look_for_key(char *key)
{
    int i = 1;
    char *name = st[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return st[i].n;
        name = st[++i].str;
    }
    return 0;
}
/////////////////////////
void ins2 (store *p, char *s, int n)
{
  p->str = s;
  p->n = n;
  
}

int look_for_key2(char *key)
{
    int i = 1;
    char *name = sym[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return i;
        name = sym[++i].str;
    }
    return 0;
}

///////////////////////////


int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}