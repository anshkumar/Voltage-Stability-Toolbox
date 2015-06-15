/*

  The calling syntax is:

			[mb] = model_c(y,zi,zj,zn)

*/

#include "global.h"

int init();
int build_model();
int init_1();
int out_func();

/* Input Arguments */

#define	Y_IN	prhs[0]
#define	Zi_IN	prhs[1]
#define	Zj_IN	prhs[2]
#define	Zn_IN	prhs[3]


/* Output Arguments */

#define	Model_OUT	plhs[0]

FILE	*fp1;
int out_count;	/* used for count output string, add 'return' if exp is too long */
int n_gen, m_pv, s_pq;

static
#ifdef __STDC__
void model_c(
		double	mb[],
		double	y[],
		double	zi[],
		double	zj[],
		double 	zn[]
		)
#else
model_c(mb,y,zi,zj,zn)
double mb[];
double y[],zi[],zj[],zn[];
double zn[];
#endif


{
	int zn1;
	
	n_gen=(int) y[0];
	m_pv=(int) y[1];
	s_pq=(int) y[2];
	
	zn1=(int) zn[0];
		
	fp1=fopen("model.c","w");
	init(zi,zj,zn1);
	build_model();
	init_1();
	out_func();		
	fclose(fp1);
	
	return;
}

#ifdef __STDC__
void mexFunction(		
	int		nlhs,
	mxArray	*plhs[],	/*EDITED BY: Vedanshu*/
	int		nrhs,
	const mxArray *prhs[]	/*EDITED BY: Vedanshu*/
	)
#else
mexFunction(nlhs, plhs, nrhs, prhs)
int nlhs, nrhs;
Matrix *plhs[], *prhs[];
#endif

{
	double	*mb;
	double  *y;
	double  *zi;
	double  *zj;
	double 	*zn;


	/* Create a matrix for the return argument */

	Model_OUT = mxCreateDoubleMatrix(1, 1, mxREAL);


	/* Assign pointers to the various parameters */

	mb = mxGetPr(Model_OUT);

	y = mxGetPr(Y_IN);
	zi= mxGetPr(Zi_IN);
	zj= mxGetPr(Zj_IN);
	zn= mxGetPr(Zn_IN);

	/* Do the actual computations in a subroutine */

	model_c(mb,y,zi,zj,zn);
	return;
}








