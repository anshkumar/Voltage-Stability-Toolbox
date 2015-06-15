#include "global.h"
extern	int	 n_gen, m_pv, s_pq;
extern	nameptr		name_header;


init_1()
{
	nameptr	p;
	nodeptr np, find_node();
	char	v_name[MAX_NAME];
	int 	i;
	

	for (i=1; i<=n_gen+m_pv; i++)
	{
		sprintf(v_name,"e[%d]",i);
		np=find_node(name_header,v_name,'c');
		np->node_id='c';
		np->node_data.cn_term.c_value=123.45;	
		/* any initial value other than 0 and 1 */
	};
	
	
/*	p=name_header;
	while (p!=NULL)	
	{
		printf("%s",p->name);
		if (p->addr->node_id=='c') printf("=%g", (long double) p->addr->node_data.cn_term.c_value);
		printf("  ");
		p=p->next;
	}
*/

}
