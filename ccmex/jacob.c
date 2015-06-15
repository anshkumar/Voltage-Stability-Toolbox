#include "global.h"

extern int              n_gen, m_pv, s_pq;
extern nameptr  name_header;

extern FILE *fp1;
extern int out_count;

jacob(nodeptr root, int i)
{
        int j, k;
        nodeptr  droot, diff(), simp();
        nameptr  p;

        j=1;
        p=name_header;
        while (p!=NULL)
        {
                if (p->addr->node_id=='v')
                {
                        fprintf(fp1,"             /*The derivative with respect to %s  */\r\n", 
                                                                                p->addr->node_data.va_term.v_name);
                        droot=diff(root, p->addr->node_data.va_term.v_name);
                        for (k=1; k<=8+n_gen+m_pv+s_pq; k++) droot=simp(droot);
                        fprintf(fp1,"j[%d][%d]=",i,j),output_exp(droot),fprintf(fp1,";\r\n\r\n");                                   
                        out_count=MAX_BI_TERM;
                        j++;
                }
                p=p->next;
        }
}
