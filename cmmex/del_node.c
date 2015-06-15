#include "global.h"

del_node(p)
nodeptr p;

{		
	switch (p->node_id) 
	{
		case 'b':	if (p->del_flg=='1') 
					{
					del_node(p->node_data.bi_term.left);				
					del_node(p->node_data.bi_term.right);
					mxFree(p);
					};	
					break;
					
		case 'u':	if (p->del_flg=='1') 
					{
					del_node(p->node_data.un_term.next);
				    mxFree(p);	
				    };	
					break;
											
		case 'c':	break;
					
					
		case 'v':	break;
					
	};
}



