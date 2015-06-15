#include "global.h"
extern nodeptr zero, one, mi_one;

nodeptr	diff(nodeptr fpt, char v[])
	
{
	nodeptr p, pl, pr, new_node();
	
	switch (fpt->node_id) {
	 case 'b':
		switch (fpt->node_data.bi_term.oprt) 
		{
		 case '+':
			p=new_node();
			p->node_id='b';
			p->node_data.bi_term.oprt='+';
			p->node_data.bi_term.left=diff(fpt->node_data.bi_term.left, v);
			p->node_data.bi_term.right=diff(fpt->node_data.bi_term.right, v);
			break;
		 case '-':
		 	p=new_node();
			p->node_id='b';
			p->node_data.bi_term.oprt='-';
			p->node_data.bi_term.left=diff(fpt->node_data.bi_term.left, v);
			p->node_data.bi_term.right=diff(fpt->node_data.bi_term.right, v);
			break;
		 case '*':
		 	p=new_node();
			p->node_id='b';
			p->node_data.bi_term.oprt='+';
			pl=new_node();
			p->node_data.bi_term.left=pl;
			pl->node_id='b';
			pl->node_data.bi_term.oprt='*';
			pl->node_data.bi_term.left=diff(fpt->node_data.bi_term.left, v);
			pl->node_data.bi_term.right=fpt->node_data.bi_term.right;
			pr=new_node();
			p->node_data.bi_term.right=pr;
			pr->node_id='b';
			pr->node_data.bi_term.oprt='*';
			pr->node_data.bi_term.left=fpt->node_data.bi_term.left;
			pr->node_data.bi_term.right=diff(fpt->node_data.bi_term.right, v);
			break;
		};
		break;
	case 'u':
		switch (fpt->node_data.un_term.oprt)
		{
		case 's':
			p=new_node();
			p->node_id='b';
			p->node_data.bi_term.oprt='*';
			pl=new_node();
			p->node_data.bi_term.left=pl;
			pl->node_id='u';
			pl->node_data.un_term.oprt='y';
			pl->node_data.un_term.next=fpt->node_data.un_term.next;
			p->node_data.bi_term.right=diff(fpt->node_data.un_term.next, v);
			break;
		case 'y':
			p=new_node();
			p->node_id='b';
			p->node_data.bi_term.oprt='*';
			
			pl=mi_one;
			p->node_data.bi_term.left=pl;
			
/*			pl=new_node();
			p->node_data.bi_term.left=pl;
			pl->node_id='c';
			sprintf(pl->node_data.cn_term.c_name,"-1");	
			pl->node_data.cn_term.c_value=-1;			*/
			
			
			
			pr=new_node();
			p->node_data.bi_term.right=pr;
			pr->node_id='b';
			pr->node_data.bi_term.oprt='*';
			pl=new_node();
			pr->node_data.bi_term.left=pl;
			pl->node_id='u';
			pl->node_data.un_term.oprt='s';
			pl->node_data.un_term.next=fpt->node_data.un_term.next;
			pr->node_data.bi_term.right=diff(fpt->node_data.un_term.next, v);
			break;
		};
		break;
	case 'c':
		p=zero;
		break;
	case 'v':
		if (strcmp(fpt->node_data.va_term.v_name, v)==0) p=one;
		else
			p=zero;
		break;
	};
	return(p);
}
