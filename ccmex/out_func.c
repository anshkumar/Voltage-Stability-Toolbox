#include "global.h"

extern FILE     *fp1;
extern int              n_gen, m_pv, s_pq;
extern int              out_count;
extern funcptr  func_header;

out_func()
{
        funcptr         p;
        char    s[MAX_NAME];
        int i,k;
        
fprintf(fp1,"/* Number of Generators:%d,  They are bus #1 to bus #%d*/\r\n",n_gen, n_gen);
if (m_pv>1) fprintf(fp1,"/* Number of PV loads:%d,  They are bus #%d to bus #%d*/\r\n",m_pv,n_gen+1,n_gen+m_pv);
if (m_pv==1) fprintf(fp1,"/* Number of PV loads:%d,  It is bus #%d */\r\n",m_pv,n_gen+1);
if (m_pv==0) fprintf(fp1,"/* Number of PV loads:0  */\r\n");
if (s_pq>1) fprintf(fp1,"/* Number of PQ loads:%d,  They are bus #%d to bus #%d*/\r\r\n",s_pq,n_gen+m_pv+1,n_gen+m_pv+s_pq);
if (s_pq==1) fprintf(fp1,"/* Number of PQ loads:%d,  It is bus #%d */\r\n",s_pq,n_gen+m_pv+1);
if (s_pq==0) fprintf(fp1,"/* Number of PQ loads:0  */\r\n");
        
        fprintf(fp1,"/*The classic steady state model: */\r\n\r\n");
        
        p=func_header;
        while (p!=NULL) 
        {
                fprintf(fp1,"%s", p->fname);
                out_count=MAX_BI_TERM;
                output_exp(p->faddr);
                fprintf(fp1,";\r\n\r\n");
        
        /* numbering the corresponding rows in the Jaccobian matrix */
                
                for (k=0; (s[k]=p->fname[k+3]) !=']'; k++);
                s[k]='\0';
                sscanf(s,"%d",&i);
                
                if (p->fname[1]=='2') i=i+n_gen+m_pv+s_pq;
                        
        /* compute the jaccobian matrix */      
                
                jacob(p->faddr,i);
                p=p->nextf;
                
        }
}
