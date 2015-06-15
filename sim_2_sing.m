% This function is called by ode45 to compute values of xdot.
% It is set up to use PoC models.

function [xdot,xx_rem]=sim_2_sing(t,xx,x_rem,no_gen,no_pv,no_pq,...
   data,param,CurrentSystem,gen_inertia,gen_damp)


% Partition the states, the second part (xp) is velocity
    x=[xx(1:no_gen-1)',x_rem]';
    xp=xx(no_gen:2*(no_gen-1)); % velocity (omega)
        
% prepare index
fn=length(x);
jnn=fn*fn;
sub_strt=no_gen;
v=zeros(fn,1);

%add damping to the system
gen_damp=diag(gen_damp(2:length(gen_damp)))+.1*eye(no_gen-1);

% Perform Standard NR to solve the algebraic equations
max_itr=5;
n_itr=0;
x_sub0=x(sub_strt:fn); % extract the algebraic variables, a column vector

x;

while ((max(abs(x(sub_strt:fn)-x_sub0))>0.000001)&(n_itr<=max_itr))|(n_itr==0)
    x_sub0=x(sub_strt:fn);
    [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
    
    delta=-J(sub_strt+1:fn+1,sub_strt:fn)\f(sub_strt+1:fn+1);
    x(sub_strt:fn)=x_sub0+delta;
    
    % the following line was added to update the algebraic variables on 03/14/99
    x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);
    
    %x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x_rem';
    n_itr=n_itr+1;
 end
 
x;
 
 Inertia=diag(gen_inertia(2:length(gen_inertia)));

% form and compute differential equations
[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
xpp=Inertia\(-gen_damp*xp-f(2:sub_strt));

% form the output vector
    xdot(1:no_gen-1)=xp;
    xdot(no_gen:2*(no_gen-1))=xpp;
    xx_rem=x(sub_strt:fn);


