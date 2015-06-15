
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
ConvergenceFlag=0;
for j=1:round(MaxIterations/ReportCycle)
    OldFigNumber=watchon;

    t0=clock;
    for i=1:ReportCycle
        x0=x;
        [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
        delta_x=-sparse(J(2:n+1,1:n))\f(2:n+1);
        x=x0+delta_x;
    end

    AbsError=max(abs(x-x0));
    if x0==0
        RelError='NA';
    else
        RelError=AbsError/max(abs(x0));
    end

   

    
    if ((AbsError<=LFAbsTol) & ((~isstr(RelError)) & ...
          (RelError<=LFRelTol) | isstr(RelError)))
       ConvergenceFlag=1;
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
