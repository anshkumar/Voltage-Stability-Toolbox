/*
   The calling syntax is:
          [f,J] = IEEE2(data,x,param,v)
*/

#include <math.h>
#include "mex.h"

static
#ifdef __STDC__
void IEEE2(
                           double  f[],
                           double  J[],
                           double  data[],
                           double  x[],
                           double  param[],
                           double  v[]
                     )
#else
IEEE2(f,J,data,x,param,v)
double             f[],J[];
double             data[],x[],param[],v[];
#endif

/*      Computational Routine    */
{
   double   t1, t2, t11, t6, t10, t7, t8, t9, t16, t13;
   double   t12, t14, t15, t21, t18, t19, t20, t25, t22, t23;
   double   t24, t26, t27, t30, t31, t32, t38, t39, t43, t44;
   double   t51, t52, t53, t56, t60;

   double   s1, s2, s3, s4, s5, s6, s7, s8, s9, s10;

      t1 = data[0];      t2 = t1*t1;      t6 = data[3]*t1;      t7 = x[0];      t8 = x[1];      t9 = sin(t8);      t10 = t7*t9;      t11 = t6*t10;      t12 = cos(t8);      t13 = t12*t7; 
      t14 = data[7];      t15 = t1*t14;      t16 = t13*t15;      f[0] = t2*data[5]-t11+t16-param[0];      t18 = data[2];      t19 = t18*t7;      t20 = t1*t9;      t21 = t19*t20;      t22 = t12*t1;      t23 = data[6]; 
      t24 = t7*t23;      t25 = t22*t24;      t26 = t7*t7;      t27 = data[8];      f[1] = t21+t25+t26*t27-param[1];      t30 = t24*t20;      t31 = t22*t19;      t32 = data[4];      f[2] = t30-t31-t26*t32-param[2];      J[0] = -t6*t9+t22*t14; 
      t38 = t18*t1*t9;      t39 = t22*t23;      J[1] = t38+t39+2.0*t7*t27;      t43 = t23*t1*t9;      t44 = t22*t18;      J[2] = t43-t44-2.0*t7*t32;      J[3] = -t6*t13-t10*t15;      J[4] = t31-t30;      J[5] = t25+t21;      t51 = -t6*t12-t20*t14; 
      t52 = v[1];      J[6] = t51*t52;      t53 = v[0];      t56 = t44-t43;      J[7] = 2.0*t27*t53+t56*t52;      t60 = t39+t38;      J[8] = -2.0*t32*t53+t60*t52;      J[9] = t51*t53+(t11-t16)*t52;      J[10] = t56*t53-J[5]*t52;      J[11] = t60*t53+J[4]*t52; 

   return;
}

/*         Gateway Routine         */

void mexFunction(
   int             nlhs,
   mxArray  *plhs[],
   int             nrhs,
   const mxArray  *prhs[]
   )
{
   double          *f;
   double          *J;
   double          *data;
   double          *x;
   double          *param;
   double          *v;
   /* Create a matrix for the return argument */

   plhs[0] = mxCreateDoubleMatrix(   3, 1, mxREAL);

   plhs[1] = mxCreateDoubleMatrix(   3,   4, mxREAL);

   /* Assign pointers to the various parameters */

   f = mxGetPr(plhs[0]);

   J = mxGetPr(plhs[1]);

   data = mxGetPr(prhs[0]);
   x = mxGetPr(prhs[1]);
   param = mxGetPr(prhs[2]);
   v = mxGetPr(prhs[3]);
   /* Do the actual computations in a subroutine */

  IEEE2(f,J,data,x,param,v);
   return;
}
