% 	The M-file name is lnnrsm1.m
%	NRS	Newton-Raphson-Seydel method for load flow analysis
%	NRS provides convergent load flow results.
%=================================================================
lfcntrup;					%updateloadflow control parameters (error tolerance, max. iteration etc...)
n=length(x);					%size of the states
v=zeros(n,1);				%zero eigenvector
OldFigNumber=watchon;
% Reorder the parameters
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


% INITIALIZE NRS
% Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near 0 and v0
[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);	% mismatch and jacobian matrix
A=J(2:n+1,1:n);
rand('state',100)
v=rand(n,1);
v=v/norm(v);			%normalized random right eigenvector
lambda=0;				%initial estimate of eigenvalue
OPTIONS.disp=0;		%do not show the intermediate steps
sigma=eps;
[x1, x2,flag]=eigs(A,1,sigma,OPTIONS);		%the smallest eigenvalue and corresponding eigenvector

%Inverse iteration method
for j=1:6
    y=(A-lambda*eye(size(A)))\v;
    lambda=lambda+norm(v)^2/(v'*y);
    v=y/norm(y);
 end
 lambda_check=lambda;
 v_check=v;
 v=x1;
 lambda=x2;


ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle)
       OldFigNumber=watchon;

       t0=clock;
        for i=1:ReportCycle
            x0=x;
            v0=v;
            lambda0=lambda;
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
            JJ_nrs=[J(2:n+1,1:n)      zeros(n,n)                  zeros(n,1)
                J(2:n+1,n+1:2*n)  J(2:n+1,1:n)-lambda*eye(n)  		-v
                zeros(1,n)        v'/norm(v)                  		0
               ];
            ff_nrs=[f(2:n+1)
                (J(2:n+1,1:n)-lambda*eye(n))*v
                norm(v)-1];
             delta=-sparse(JJ_nrs)\ff_nrs;
            x=x0+delta(1:n);
            v=v0+delta(n+1:2*n);
            lambda=lambda0+delta(2*n+1)
        end

        AbsError=max([abs(x-x0);abs(v-v0);abs(lambda-lambda0)]);
        if ((x0==0) & (v0==0)& (lambda0==0))
            RelError='NA';
        else
            RelError=AbsError/max([abs(x0);abs(v0);abs(lambda0)]);
         end
         lfsetsta;	

        % set LF control control errors
        set(AbsErrorDisp,'String',num2str(AbsError));
        if isstr(RelError)
            set(RelErrorDisp,'String',RelError);
        else
            set(RelErrorDisp,'String',num2str(RelError));
        end
        set(NumIterations,'String',num2str(j*ReportCycle));
        set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle));

        if (AbsError<=LFAbsTol)&((~isstr(RelError))&(RelError<=LFRelTol)|isstr(RelError))
            ConvergenceFlag=1;
            break;
        end
    end

    if ConvergenceFlag==0
        'NRS Failed to Converge'
        break;
    end
 
 
for i=1:k_temp
   paramx(i)=param(i);
end
for i=1:no_pq
   ii=k_temp+i;
   jj=k_temp+1+2*(i-1);
   paramx(jj)=param(ii);
   paramx(jj+1)=param(ii+no_pq);
end
param=paramx;
param;
watchoff;
