#include "global.h"


extern n_gen, m_pv, s_pq;
nodeptr		zero, one, mi_one;
nameptr		name_header;
funcptr		func_header;

init()

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
	
}
