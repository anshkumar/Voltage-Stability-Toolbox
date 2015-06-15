#include "global.h"

extern FILE     *fp1;
extern int              n_gen, m_pv, s_pq;
extern int              out_count;
extern funcptr  func_header;

out_func()
{
        funcptr         p;
        int i,k;
        char    s[MAX_NAME];
        

        i=1;
        p=func_header;
        while (p!=NULL) 
        {
                fprintf(fp1,"%s", p->fname);
                out_count=MAX_BI_TERM;
                output_exp(p->faddr);
                fprintf(fp1,":\r\n\r\n");
                
        /* numbering the corresponding rows in the Jacobian matrix */
                
                for (k=0; (s[k]=p->fname[k+3]) !=']'; k++);
                s[k]='\0';
                sscanf(s,"%d",&i);
                
                if (p->fname[1]=='2') i=i+n_gen+m_pv+s_pq-1;
                        
        /* compute the jaccobian matrix */      
                
        /*      jacob(p->faddr,i);          */
                
                del_node(p->faddr);             
                
                p=p->nextf;     
                
        }
}
