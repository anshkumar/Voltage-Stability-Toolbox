% TO_PARAM
% Order parameters in the following manner; param=[p1....pn,q1,...qn]
% Order search direction in the same order as the parameter vector has
param;
p;
k_temp=no_gen+no_pv-1;
clear paramx px

for i=1:k_temp
   paramx(i)=param(i);
   px(i)=p(i);
end

for i=1:no_pq
   ii=k_temp+i;
   jj=k_temp+1+2*(i-1);
   paramx(ii)=param(jj);
   paramx(ii+no_pq)=param(jj+1);
   px(ii)=p(jj);
   px(ii+no_pq)=p(jj+1);
end
px;
param=paramx';
p=px';
param;
p;
