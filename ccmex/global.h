#include <stdio.h>     	/* load i/o routine */
#include <ctype.h>		/* load character test routine */
#include <stdlib.h>
#include <string.h>

#include <math.h>
#include "mex.h"

#define MAX_NAME		15
#define MAX_BI_TERM		10

 typedef struct binary_term{
 							char 	oprt;
 							struct	node	*left;
 							struct	node	*right;
 							} B_TERM;
 
 typedef struct unary_term{	
 							char	oprt;
 							struct	node	*next;
 							} U_TERM;				
 							
 typedef struct cnst_term{	
 							char	c_name[MAX_NAME];
 							double	c_value;
 							} C_TERM;	
 							
 typedef struct var_term{	
 							char	v_name[MAX_NAME];
 							double	v_value;
 							} V_TERM;
 
 
 typedef union node_type{	C_TERM 	cn_term;
 							V_TERM	va_term;
 							B_TERM 	bi_term;
 							U_TERM 	un_term;
 							} NODE_CONTENT;
 
 struct node	{
 				char				node_id;
 				char				del_flg;
 				NODE_CONTENT		node_data; 				
 				};


typedef struct node *nodeptr;

struct name_elem{
					char 				name[MAX_NAME];
					struct node			*addr;
					struct name_elem	*next;
				};
				
struct func_elem{
					char				fname[MAX_NAME];
					struct 	node		*faddr;
					struct	func_elem	*nextf;
				};
								
typedef struct name_elem *nameptr;

typedef struct func_elem *funcptr;

