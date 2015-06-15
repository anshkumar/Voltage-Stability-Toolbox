%The M-file name is: sim_1.m.
%perform integration routine for simulation
%

OldFigNumber=watchon;

% form initial conditions for velocities (omega's)
xp0=zeros(1,no_gen-1);		%creates a zero row vector for w's whose dimension is 1x(no_gen-1)

% form initial state: coordinates first: generator bus(delta and omega)
x0=[x(1:no_gen-1)',xp0]; % creates a row vector for generator bus delta and omega 


% define remaining variables: Load bus variables( angles and magnitudes)
x_rem=x(no_gen:(no_gen-1)+no_pv+2*no_pq)'; % a row vector containing load bus voltage magnitude and angles
fn=length(x);
% Simulation starting time
t_sm_start=0;

set(simul_time, 'String',num2str(t_sm_start));
set(plotHANDLE,'Enable','off');

%update the algebraic variables after perturbation
x

smlf_sing; 
x_check=x;


[t_sm,x_sm,y_sm]=ode45dae('sim_2_sing',t_sm_start,t_final,x0,x_rem,...
   no_gen,no_pv,no_pq,data,param,CurrentSystem,...
   gen_inertia,gen_damp,simul_time);

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

% Enable variable list popup menu 
set(plotHANDLE,'Enable','on');

watchoff;
