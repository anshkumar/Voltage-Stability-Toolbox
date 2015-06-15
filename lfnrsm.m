% NRS	Newton-Raphson-Seydel method for load flow analysis
%	NRS provides convergent load flow results.
%

lfcntrup;
n=length(x);
v=zeros(n,1);
OldFigNumber=watchon;
param;
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
% 2) Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near 0
% and v0
v=zeros(n,1);
[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
A=J(2:n+1,1:n);

v=rand(n,1);
v=v/norm(v);
lambda=0;
for j=1:6
    y=(A-lambda*eye(size(A)))\v;
    lambda=lambda+norm(v)^2/(v'*y);
    v=y/norm(y);
end

ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle)
       OldFigNumber=watchon;

       t0=clock;
        for i=1:ReportCycle
            x0=x;
            v0=v;
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
            JJ=[J(2:n+1,1:n)      zeros(n,n)    -p
                J(2:n+1,n+1:2*n)  J(2:n+1,1:n)  zeros(n,1)
                zeros(1,n)        v'/norm(v)    0
               ];
            ff=[f(2:n+1)
                J(2:n+1,1:n)*v
                norm(v)-1];
             delta=-sparse(JJ)\ff;
             

            x=x0+delta(1:n);
            v=v0+delta(n+1:2*n);
        end

        AbsError=max([abs(x-x0);abs(v-v0)]);
        if ((x0==0) & (v0==0))
            RelError='NA';
        else
            RelError=AbsError/max([abs(x0);abs(v0)]);
        end

        % set state
        % VST_LFSetState;
        % VST_LFSetParam;

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
