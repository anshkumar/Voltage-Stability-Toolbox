#include "global.h"


extern n_gen, m_pv, s_pq;
nodeptr		zero, one, mi_one;
nameptr		name_header;
funcptr		func_header;

init(double zi[], double zj[], int zn)

{
	nodeptr new_node();
	nameptr p, last_name, new_name();
	int i,j;
	
	
	zero=new_node();
	zero->node_id='c';
	sprintf(zero->node_data.cn_term.c_name,"0");	
	zero->node_data.cn_term.c_value=0.0;
	
	one=new_node();
	one->node_id='c';
	sprintf(one->node_data.cn_term.c_name,"1");	
	one->node_data.cn_term.c_value=1.0;
	
	mi_one=new_node();
	mi_one->node_id='c';
	sprintf(mi_one->node_data.cn_term.c_name,"-1");	
	mi_one->node_data.cn_term.c_value=-1.0;
	
	func_header=NULL;
	name_header=NULL;
	
	for (i=0; i<=zn-1; i++)
	{
		p=new_name();
		if (name_header==NULL) 
		{
			name_header=p;
			last_name=p;
		}
		else
		{				
			last_name->next=p;
		};			
		sprintf(p->name,"b[%d][%d]",(int) zi[i],(int) zj[i]);
		p->addr=zero;
		p->next=NULL;
		last_name=p;
				
		p=new_name();
		last_name->next=p;
		sprintf(p->name,"g[%d][%d]",(int) zi[i],(int) zj[i]);
		p->addr=zero;
		p->next=NULL;
		last_name=p;
	}
	
}
