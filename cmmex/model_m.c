/*

  The calling syntax is:

                        [mb] = model2_maple(y,zi,zj,zn)

*/

#include "global.h"

/* Input Arguments */

#define Y_IN    prhs[0]
#define Zi_IN   prhs[1]
#define Zj_IN   prhs[2]
#define Zn_IN   prhs[3]


/* Output Arguments */

#define Model_OUT       plhs[0]

FILE    *fp1;
int out_count;  /* used for count output string, add 'return' if exp is too long */
int n_gen, m_pv, s_pq;

static
#ifdef __STDC__
void model_maple(
                double  mb[],
                double  y[],
                double  zi[],
                double  zj[],
                double  zn[]
                )
#else
model_maple(mb,y,zi,zj,zn)
double mb[];
double y[],zi[],zj[],zn[];
#endif


{
        int zn1;
        
        n_gen=(int) y[0];
        m_pv=(int) y[1];
        s_pq=(int) y[2];
        
        zn1=(int) zn[0];
                
        fp1=fopen("model.src","w");
        fprintf(fp1,"model:=proc(X)\r\n");
        fprintf(fp1,"global n_gen,m_pv,s_pq,f1,f2;\r\n");
        fprintf(fp1,"n_gen:=%d:\r\n",n_gen);
        fprintf(fp1,"m_pv:=%d:\r\n",m_pv);
        fprintf(fp1,"s_pq:=%d:\r\n",s_pq);
        fprintf(fp1,"f1:=array(1..%d,1..1):\r\n",(n_gen)+m_pv+s_pq);
        if (s_pq!=0) fprintf(fp1,"f2:=array(1..%d,1..1):\r\n",s_pq);
        init();
        build_model(zi,zj,zn1);
        init_1();
        out_func();
        fprintf(fp1,"RETURN(1)\r\n");
        fprintf(fp1,"end:\r\n");          
        fclose(fp1);
        
        return;
}

#ifdef __STDC__
void mexFunction(
        int             nlhs,
        mxArray  *plhs[],
        int             nrhs,
        const mxArray  *prhs[]
        )
#else
mexFunction(nlhs, plhs, nrhs, prhs)
int nlhs, nrhs;
Matrix *plhs[], *prhs[];
#endif

{
        double  *mb;
        double  *y;
        double  *zi;
        double  *zj;
        double  *zn;


        /* Create a matrix for the return argument */

        Model_OUT = mxCreateDoubleMatrix(1, 1, mxREAL);


        /* Assign pointers to the various parameters */

        mb = mxGetPr(Model_OUT);

        y = mxGetPr(Y_IN);
        zi= mxGetPr(Zi_IN);
        zj= mxGetPr(Zj_IN);
        zn= mxGetPr(Zn_IN);

        /* Do the actual computations in a subroutine */

        model_maple(mb,y,zi,zj,zn);
        return;
}








