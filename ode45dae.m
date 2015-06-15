function [tout, yout, vout] = ode45dae(ypfun, t0, tfinal, y0, y_rem0, ...
                                  no_gen,no_pv,no_pq,data,param,...
								  CurrentSystem,...
								  gen_inertia,gen_damp,...
								  simul_time,...
							      tol, trace)
%ODE45	Solve differential equations, higher order method.
%	ODE45 integrates a system of ordinary differential equations using
%	4th and 5th order Runge-Kutta formulas.
%	[T,Y] = ODE45('yprime', T0, Tfinal, Y0) integrates the system of
%	ordinary differential equations described by the M-file YPRIME.M,
%	over the interval T0 to Tfinal, with initial conditions Y0.
%	[T, Y] = ODE45(F, T0, Tfinal, Y0, TOL, 1) uses tolerance TOL
%	and displays status while the integration proceeds.
%
%	INPUT:
%	F     - String containing name of user-supplied problem description.
%	        Call: yprime = fun(t,y) where F = 'fun'.
%	        t      - Time (scalar).
%	        y      - Solution column-vector.
%	        yprime - Returned derivative column-vector; yprime(i) = dy(i)/dt.
%	t0    - Initial value of t.
%	tfinal- Final value of t.
%	y0    - Initial value column-vector.
%   y_rem0 - non-dynamic variables for the algebraic equations
%   no_gen,no_pv,no_pq,data,param are variables passed to equation subroutine
%	tol   - The desired accuracy. (Default: tol = 1.e-6).
%	trace - If nonzero, each step is printed. (Default: trace = 0).
%
%	OUTPUT:
%	T  - Returned integration time points (column-vector).
%	Y  - Returned solution, one solution column-vector per tout-value.
%
%	The result can be displayed by: plot(tout, yout).
%
%	See also ODE23, ODEDEMO.

%	C.B. Moler, 3-25-87, 8-26-91, 9-08-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% The Fehlberg coefficients:
alpha = [1/4  3/8  12/13  1  1/2]';
beta  = [ [    1      0      0     0      0    0]/4
          [    3      9      0     0      0    0]/32
          [ 1932  -7200   7296     0      0    0]/2197
          [ 8341 -32832  29440  -845      0    0]/4104
          [-6080  41040 -28352  9295  -5643    0]/20520 ]';
gamma = [ [902880  0  3953664  3855735  -1371249  277020]/7618050
          [ -2090  0    22528    21970    -15048  -27360]/752400 ]';
pow = 1/5;
if nargin < 15, tol = 1.e-6; end
if nargin < 16, trace = 0; end
% Initialization
t = t0; 								% initiate the simulation time t0=t_sm_start=0
hmax = (tfinal - t)/16; 		% maximum step-size in time
hmin = (tfinal - t)/1024;		% minimum step-size in time

h = hmax/24;							% set initial step-size
y = y0(:);							% set initial value for dynamic variables,y is a column vector
y_rem=y_rem0;						% set initial values for algebraic variables,y_rem is row vector
length(y);
f = zeros(length(y),6);			%define a zero matrix  
chunk = 128;
tout = zeros(chunk,1);			% allocate space for time,size is chunk x 1
yout = zeros(chunk,length(y));% allocate space for dynamic variable, size is chunk x length(y)
vout=zeros(chunk,length(y_rem));  % allocate space for algebraic variables, size is chunk xlength(y_rem)
k = 1;
tout(k) = t;
yout(k,:) = y.';	%take non-conjugate transpose of dynamic variables,first row of yout
vout(k,:)=y_rem;	%take(added trans) non-conjugate transpose of algebraic variables,first row of vout


if trace
   clc, t, h, y
end

% The main loop
%======================================================================================================

while (t < tfinal) & (t + h > t+hmin/2)     % put a flag on time
   if t + h > tfinal, h = tfinal - t; end   
   
   %step 3 in page 290
   
   % Compute the slopes
   [temp,temp2] = feval(ypfun,t,y,y_rem,no_gen,no_pv,no_pq,...
   				data,param,CurrentSystem,...
               gen_inertia,gen_damp);			% compute K1
            temp;    							   %temp is xdot which is the slope at the current point
            f(:,1) = temp(:);
            %now f=K1
   %======================================================================
   for j = 1:5
      [temp,temp2] = feval(ypfun, t+alpha(j)*h, y+h*f*beta(:,j),y_rem,...
	  				no_gen,no_pv,no_pq,data,param,...
                 CurrentSystem,gen_inertia,gen_damp);
            f(:,j+1) = temp(:);
         end
   %=============================================================================
   % End of step 3
   
   
   % step 4
   % Estimate the error and the acceptable error
   delta = norm(h*f*gamma(:,2),'inf');			%error estimation
   tau = tol*max(norm(y,'inf'),1.0);			%tolerance
   % the end of step 4
   
   
   %step 5
   % Update the solution only if the error is acceptable
   %======================================================
   if (delta <= tau)|(h<=hmin)
      t = t + h;
      y = y + h*f*gamma(:,1);     
      % based on the acceptable dynamic variables, 
      %update the algebraic variables
      %if y(1)<=(-0.4993)
        % param(1)=5;
         %t
      %end
      
      [temp,temp2] = feval(ypfun, t+h, y,y_rem,...
	  				no_gen,no_pv,no_pq,data,param,...
					CurrentSystem,gen_inertia,gen_damp);
            y_rem=temp2';
            k = k+1;
      %============================================      
      if k > length(tout)
         tout = [tout; zeros(chunk,1)];
         yout = [yout; zeros(chunk,length(y))];
         vout = [vout; zeros(chunk,length(y_rem))]; 
      end
      %=============================================
      tout(k) = t;
	  set(simul_time,'String',num2str(t));
     yout(k,:) = y.';
     vout(k,:)=y_rem;
   end
   %=========================================================
   %========================
   if trace
      home, t, h, y,y_rem 
   end
  %=========================
  %step 8 and 9 :Update the step size
  %=============================================
   if delta ~= 0.0
      h1 = min(hmax, 0.8*h*(tau/delta)^pow);
      h = max(h1,hmin);
   end
   %============================================
end
%=========================================================================================
if (t < tfinal)
   disp('Singularity likely.');
end
%=================================
tout = tout(1:k);
yout = yout(1:k,:);
vout=vout(1:k,:); 
size(yout); 
size(vout); 
