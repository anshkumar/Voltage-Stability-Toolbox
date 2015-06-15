#include "global.h"
extern FILE *fp1;
extern int out_count;

output_exp(nodeptr p)
{		
	switch (p->node_id) 
	{
		case 'b':	fprintf(fp1,"(");
					output_exp(p->node_data.bi_term.left);
					fprintf(fp1,"%c",p->node_data.bi_term.oprt);
					if (out_count<=0) 
					{
						fprintf(fp1,"\r");
						out_count=10;
					}
					else
					{
						out_count--;
					};		
					output_exp(p->node_data.bi_term.right);
					fprintf(fp1,")");
					break;
		
		case 'u':	switch (p->node_data.un_term.oprt) 
					{
					case 's': fprintf(fp1,"sin(");output_exp(p->node_data.un_term.next);
							  fprintf(fp1,")");break;
					case 'y': fprintf(fp1,"cos(");output_exp(p->node_data.un_term.next);
							  fprintf(fp1,")");break;
					};
					break;
							
		case 'c':	if (p->node_data.cn_term.c_name[0]=='-')
					{
						fprintf(fp1,"(");fprintf(fp1,"%s",p->node_data.cn_term.c_name);
						fprintf(fp1,")");break;
					}
					else
					{
						fprintf(fp1,"%s",p->node_data.cn_term.c_name);break;
					};
					
		case 'v':	fprintf(fp1,"%s",p->node_data.va_term.v_name);break;
	};
}



