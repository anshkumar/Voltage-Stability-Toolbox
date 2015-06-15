/*
   The calling syntax is:
          [f,J] = IEEE3(data,x,param,v)
*/

#include <math.h>
#include "mex.h"

static
#ifdef __STDC__
void IEEE3(
                           double  f[],
                           double  J[],
                           double  data[],
                           double  x[],
                           double  param[],
                           double  v[]
                     )
#else
IEEE3(f,J,data,x,param,v)
double             f[],J[];
double             data[],x[],param[],v[];
#endif

/*      Computational Routine    */
{
   double   t2, t1, t139, t144, t11, t6, t10, t7, t8, t9;
   double   t16, t13, t12, t15, t23, t18, t22, t19, t20, t21;
   double   t28, t25, t24, t26, t27, t33, t31, t32, t37, t34;
   double   t36, t38, t46, t100, t102, t103, t42, t45, t43, t44;
   double   t51, t48, t47, t49, t50, t56, t53, t54, t55, t60;
   double   t57, t58, t59, t68, t64, t61, t62, t63, t65, t66;
   double   t67, t69, t70, t73, t74, t75, t76, t77, t84, t85;
   double   t91, t92, t95, t94, t99, t109, t114, t115, t117, t118;
   double   t121, t123, t127, t132, t134;

   double   s1, s2, s3, s4, s5, s6, s7, s8, s9, s10;

      t1 = data[0];      t2 = t1*t1;      t6 = data[5]*t1;      t7 = data[1];      t8 = x[0];      t9 = sin(t8);      t10 = t7*t9;      t11 = t6*t10;      t12 = cos(t8);      t13 = t12*t7; 
      t15 = t1*data[14];      t16 = t13*t15;      t18 = data[8]*t1;      t19 = x[1];      t20 = x[2];      t21 = sin(t20);      t22 = t19*t21;      t23 = t18*t22;      t24 = cos(t20);      t25 = t24*t19; 
      t26 = data[17];      t27 = t1*t26;      t28 = t25*t27;      f[0] = t2*data[11]-t11+t16-t23+t28-param[0];      t31 = data[3]*t7;      t32 = t1*t9;      t33 = t31*t32;      t34 = t12*t1;      t36 = t7*data[12];      t37 = t34*t36; 
      t38 = t7*t7;      t42 = data[9]*t7;      t43 = t8-t20;      t44 = sin(t43);      t45 = t19*t44;      t46 = t42*t45;      t47 = cos(t43);      t48 = t47*t19;      t49 = data[18];      t50 = t7*t49; 
      t51 = t48*t50;      f[1] = t33+t37+t38*data[15]+t46+t51-param[1];      t53 = data[4];      t54 = t53*t19;      t55 = t1*t21;      t56 = t54*t55;      t57 = t24*t1;      t58 = data[13];      t59 = t19*t58;      t60 = t57*t59; 
      t61 = data[7];      t62 = t61*t19;      t63 = t7*t44;      t64 = t62*t63;      t65 = t47*t7;      t66 = data[16];      t67 = t19*t66;      t68 = t65*t67;      t69 = t19*t19;      t70 = data[19]; 
      f[2] = t56+t60-t64+t68+t69*t70-param[2];      t73 = t59*t55;      t74 = t57*t54;      t75 = t67*t63;      t76 = t65*t62;      t77 = data[10];      f[3] = t73-t74-t75-t76-t69*t77-param[3];      J[0] = -t6*t13-t10*t15;      t84 = t42*t48;      t85 = t45*t50; 
      J[1] = t31*t34-t32*t36+t84-t85;      J[2] = -t76-t75;      J[3] = -t68+t64;      J[4] = -t18*t21+t57*t26;      J[5] = t42*t44+t65*t49;      t91 = t53*t1*t21;      t92 = t57*t58;      t94 = t61*t7*t44;      t95 = t65*t66;      J[6] = t91+t92-t94+t95+2.0*t19*t70; 
      t99 = t58*t1*t21;      t100 = t57*t53;      t102 = t66*t7*t44;      t103 = t65*t61;      J[7] = t99-t100-t102-t103-2.0*t19*t77;      J[8] = -t18*t25-t22*t27;      J[9] = -t84+t85;      J[10] = t74-t73+t76+t75;      J[11] = t60+t56+t68-t64;      t109 = v[0]; 
      J[12] = (t11-t16)*t109;      t114 = t42*t47-t63*t49;      t115 = v[1];      t117 = t46+t51;      t118 = v[2];      J[13] = (-t33-t37-t46-t51)*t109+t114*t115+t117*t118;      t121 = -t103-t102;      t123 = -J[3];      J[14] = J[3]*t109+t121*t115+t123*t118;      t127 = -t95+t94; 
      J[15] = -J[2]*t109+t127*t115+J[2]*t118;      t132 = -t18*t24-t55*t26;      J[16] = t132*t118;      t134 = -t114;      J[17] = t114*t109+t134*t118;      t139 = t100-t99+t103+t102;      J[18] = t121*t109+2.0*t70*t115+t139*t118;      t144 = t92+t91+t95-t94;      J[19] = t127*t109-2.0*t77*t115+t144*t118;      J[20] = t132*t115+(t23-t28)*t118; 
      J[21] = t117*t109+t134*t115-t117*t118;      J[22] = t123*t109+t139*t115-J[11]*t118;      J[23] = J[2]*t109+t144*t115+J[10]*t118; 

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

   plhs[0] = mxCreateDoubleMatrix(   4, 1, mxREAL);

   plhs[1] = mxCreateDoubleMatrix(   4,   6, mxREAL);

   /* Assign pointers to the various parameters */

   f = mxGetPr(plhs[0]);

   J = mxGetPr(plhs[1]);

   data = mxGetPr(prhs[0]);
   x = mxGetPr(prhs[1]);
   param = mxGetPr(prhs[2]);
   v = mxGetPr(prhs[3]);
   /* Do the actual computations in a subroutine */

  IEEE3(f,J,data,x,param,v);
   return;
}
