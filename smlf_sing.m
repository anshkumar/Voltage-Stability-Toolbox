% The M-file name:smlf_sing.m
% It implements a NR iteration method to update the state values
% after any generator angles are perturbed in the time domain simulation interface.
% It updates the algebraic variables y (i.e load bus voltage magn. and 
% angles) for a given x states before the integration routine starts
% Note that g(x,y,p)=0 must be held all the time.

n=length(x);
x_sub0=x_rem; % Define initial condition 
v=zeros(n,1);

% Reorder parameter values such that param=[P Q]'
k_temp=no_gen+no_pv-1;
for i=1:k_temp
   paramx(i)=param(i);
end
for i=1:no_pq
   ii=k_temp+i;
   jj=k_temp+1+2*(i-1);
   paramx(ii)=param(jj);
   paramx(ii+no_pq)=param(jj+1);
end

param=paramx';
param;
%Define Error Tolerances
LFAbsTol=.000001;
LFRelTol=.0001;

%Initialize NRS
% Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near 0 and v0
v=zeros(n,1);
[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
C=J(sub_strt+1:fn+1,sub_strt:fn);							%The matrix Dyg just before NRS
lambda_sm=0;														%Initial estimate for the smallest eigenvalue of Dyg													
rand('state',100)
v=rand(n,1);
v=v/norm(v);
v_gen=zeros(no_gen-1,1);										%components of v corresponding to dynamic variables are zero
v(1:no_gen-1)=v_gen;

% normalized initial estimate for the eigenvector of Dyg
%use matlab "eigs" command to estimate the smallest eigenvalue of Dyg
%=====================================================================
options.disp=0;
sigma=eps;
[x1_sm,x2_sm,flag4]=eigs(C,1,sigma,options);

%=====================================================================
%inverse iteration method to estimate the smallest eigenvalue of Dyg
%=====================================================================
for j=1:6
    y_sm=(C-lambda_sm*eye(size(C)))\v(sub_strt:fn);
    lambda_sm=lambda_sm+norm(v(sub_strt:fn))^2/((v(sub_strt:fn))'*y_sm);
   v(sub_strt:fn)=y_sm/norm(y_sm);
end
lambda_sm_check=lambda_sm;
 v_load=v(sub_strt:fn);
 lambda_sm=x2_sm;
 v(sub_strt:fn)=x1_sm;
  


% NRS iteration procedure

   
ConvergenceFlag=0;

for j=1:10
   for i=1:15
      
   	x_sub0=x_rem;
   	v0=v(sub_strt:fn);
   	lambda_sm0=lambda_sm;
   	[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
   	JJ_sm=[   J(sub_strt+1:fn+1,sub_strt:fn)            zeros(2*no_pq,2*no_pq)                                 		zeros(2*no_pq,1)
                J(sub_strt+1:fn+1,fn+no_gen:2*fn)  J(sub_strt+1:fn+1,sub_strt:fn)-lambda_sm*eye(2*no_pq) 	 		-v(sub_strt:fn)
                zeros(1,2*no_pq)                   (v(sub_strt:fn))'/norm(v(sub_strt:fn))                       			0
                ];
                ff_sm=[f(sub_strt+1:fn+1)
                   (J(sub_strt+1:fn+1,sub_strt:fn)-lambda_sm*eye(2*no_pq))*v(sub_strt:fn)
                   norm(v(sub_strt:fn))-1];
                
            delta_sm=-sparse(JJ_sm)\ff_sm;
            x_rem=x_sub0+delta_sm(1:2*no_pq)';
            x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x_rem';
            v(sub_strt:fn)=v0+delta_sm(2*no_pq+1:4*no_pq);
            lambda_sm=lambda_sm0+delta_sm(4*no_pq+1);
         end
         
         AbsError=max([abs(x_rem'-x_sub0');abs(v(sub_strt:fn)-v0);abs(lambda_sm-lambda_sm0)]);
         if ((x_sub0==0) & (v0==0)& (lambda_sm0==0))
            RelError='NA';
        else
            RelError=AbsError/max([abs(x_sub0');abs(v0);abs(lambda_sm0)]);
         end

        if (AbsError<=LFAbsTol)&((~isstr(RelError))&(RelError<=LFRelTol)|isstr(RelError))
            ConvergenceFlag=1;
            break;
        end
    end

    if ConvergenceFlag==0
        'NRS Failed to Converge'
        break;
    end
    
 


 
 
