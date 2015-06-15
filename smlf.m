% The M-file name:smlf.m
% It implements a NR iteration method to update the state values
% after any generator angles are perturbed in the time domain simulation interface.
% It updates the algebraic variables y (i.e load bus voltage magn. and 
% angles) for a given x states before the integration routine starts
% Note that g(x,y,p)=0 must be held all the time.


max_itr=50; % maximum number of iteration
n_itr=0;		% Initiate iteration
x_sub0=x_rem; % Define initial condition for NR algorithm (row vector) 

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
param

% NR iteration procedure
while ((max(abs(x_rem-x_sub0))>0.000001)&(n_itr<=max_itr))|(n_itr==0)
   x_sub0=x_rem;
   [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
   delta=-J(no_gen+1:fn+1,no_gen:fn)\f(no_gen+1:fn+1);
    x_rem=x_sub0+delta';
    %update the algebraic part of state variables
    x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x_rem';
    n_itr=n_itr+1;
end
x
 
 
