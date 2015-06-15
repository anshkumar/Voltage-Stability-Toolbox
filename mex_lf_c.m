function mexfuncname=mex_lf_c(pathname,filename,Yred)
%Creates C_code from Maple equation file, filename, that compiles 
%as a MEX-function. mexfilename is the name of the C_code file. 
%The inputs: filename and pathname can be obtained using uigetfile
% 

clear mex;
in_filename='model.src';
mexfilename=filename;
mexfuncname=mexfilename(1:length(mexfilename)-2);
%---------------------------------------
t=clock;
procread('model.src');
maple('model(0):')
'load maple model'
etime(clock,t)
procread('mclassic.src');
t=clock;
dummy_var=0;
[zrow,zcol,Sred]=find(Yred);
F=maple('mclassic',zrow,zcol);
'classical model'
etime(clock,t)
procread('mclasord.src');
procread('mc_subop.src');
ExpLimit=5;
t=clock;
dimensions=double(sym(maple('mclasord',ExpLimit)));
'reordered model'
etime(clock,t)
t=clock;
lengths=double(sym(maple('mc_subop',ExpLimit,dimensions(1),dimensions(2),dimensions(3))));
'suboptimized model'
etime(clock,t)
fid=fopen([pathname,mexfilename],'wt');
%------------------------- write header of C program -------------
fprintf(fid,'/*\n');
fprintf(fid,'   The calling syntax is:\n');
fprintf(fid,['          [f,J] = ',mexfuncname,'(data,x,param)\n']);
fprintf(fid,'*/\n\n');
fprintf(fid,'#include <math.h>\n');
fprintf(fid,'#include "mex.h"\n\n');
fprintf(fid,'/* Input Arguments */\n\n');
fprintf(fid,'#define Data_IN      prhs[0]\n');
fprintf(fid,'#define X_IN             prhs[1]\n');
fprintf(fid,'#define Param_IN     prhs[2]\n');
fprintf(fid,'/* Output Arguments */\n\n');
fprintf(fid,'#define F_OUT      plhs[0]\n');
fprintf(fid,'#define J_OUT      plhs[1]\n\n');
fprintf(fid,'static\n');
fprintf(fid,'#ifdef __STDC__\n');
fprintf(fid,['void ',mexfuncname,'(\n']);
fprintf(fid,'                           double  f[],\n');
fprintf(fid,'                           double  J[],\n');
fprintf(fid,'                           double  data[],\n');
fprintf(fid,'                           double  x[],\n');
fprintf(fid,'                           double  param[]\n');
fprintf(fid,'                     )\n');
fprintf(fid,'#else\n');
fprintf(fid,[mexfuncname,'(f,J,data,x,param)\n']);
fprintf(fid,'double             f[],J[];\n');
fprintf(fid,'double             data[],x[],param[];\n');
fprintf(fid,'#endif\n\n');
fprintf(fid,'/*      Computational Routine    */\n');
fprintf(fid,'{\n');

%-------------- write  variable declaration and optimized C code ------
remainder=lengths(2);
while remainder>0
        tv=maple(['seq(templist[ii+',num2str(lengths(2)-remainder,8),'],ii=1..min(10,',num2str(remainder,8),'));']);
        fprintf(fid,'   double   %s;\n',tv);
        remainder=remainder-10;
end;
fprintf(fid,'\n');
fprintf(fid,'   double   %s;\n','s1, s2, s3, s4, s5, s6, s7, s8, s9, s10');
fprintf(fid,'\n');
fclose(fid);
%------- write C code ---------------
maple('gc:');
maple('readlib(C):');
'C lib installed'

maple('interface(screenwidth=8000)');
procread('cwrite.src');
procread('cwriteln.src');

procread('c_conv.src');
t=clock;

fid=fopen([pathname,mexfilename],'a+');
NumExp=10;

remainder=lengths(1)
while remainder>0
        nd=fprintf(fid,'%s \n', maplemex(['c_conv(',num2str(min(NumExp,remainder),8),',',num2str(lengths(1)-remainder,8),'):']));
        remainder=remainder-NumExp;          
end;

fclose(fid);


'write C code'
etime(clock,t)
%------ write the end of computational routine and the begining of gateway routine ---------------------
fid=fopen([pathname,mexfilename],'a+');
fprintf(fid,'\n');
fprintf(fid,'   return;\n');
fprintf(fid,'}\n\n');
fprintf(fid,'/*         Gateway Routine         */\n\n');
fprintf(fid,'#ifdef __STDC__\n');
fprintf(fid,'void mexFunction(\n');
fprintf(fid,'   int             nlhs,\n');
fprintf(fid,'   Matrix  *plhs[],\n');
fprintf(fid,'   int             nrhs,\n');
fprintf(fid,'   Matrix  *prhs[]\n');
fprintf(fid,'   )\n');
fprintf(fid,'#else\n');
fprintf(fid,'mexFunction(nlhs, plhs, nrhs, prhs)\n');
fprintf(fid,'int nlhs, nrhs;\n');
fprintf(fid,'Matrix *plhs[], *prhs[];\n');
fprintf(fid,'#endif\n\n');
fprintf(fid,'{\n');
fprintf(fid,'   double          *f;\n');
fprintf(fid,'   double          *J;\n');
fprintf(fid,'   double          *data;\n');
fprintf(fid,'   double          *x;\n');
fprintf(fid,'   double          *param;\n');
fprintf(fid,'   /* Create a matrix for the return argument */\n\n');

%------------------ write the output matrix dimension ------------
fprintf(fid,'   F_OUT = mxCreateFull(%4i, 1, REAL);\n\n',dimensions(1));
fprintf(fid,'   J_OUT = mxCreateFull(%4i,%4i, REAL);\n\n',dimensions(2),dimensions(3));

%------------------ write the end of gateway routine ----------------
fprintf(fid,'   /* Assign pointers to the various parameters */\n\n');
fprintf(fid,'   f = mxGetPr(F_OUT);\n\n');
fprintf(fid,'   J = mxGetPr(J_OUT);\n\n');
fprintf(fid,'   data = mxGetPr(Data_IN);\n');
fprintf(fid,'   x = mxGetPr(X_IN);\n');
fprintf(fid,'   param = mxGetPr(Param_IN);\n');
fprintf(fid,'   /* Do the actual computations in a subroutine */\n\n');
fprintf(fid,['  ',mexfuncname,'(f,J,data,x,param);\n']);
fprintf(fid,'   return;\n');
fprintf(fid,'}\n');

fclose(fid);

