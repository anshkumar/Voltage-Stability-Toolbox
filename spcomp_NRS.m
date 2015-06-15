% spcomp_NRS.m file is written to search the singular points
% in the state-space by changing the dynamic variables.
% It implements only  Newton-Raphson-Seydel (NRS) algorithm
% All the generator angles have been parameterized as follows:
% x=(1-alpha)x_upper + alpha*x_lower
% This M-file enables us to parameterize more than one dynamic variables
%For example, delta2, delta2+delta3, delta2+delta3+delta4....


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

% Specify the initial parameter and some indexing
% ************************************************
alpha_sp=0;
n=length(x);
sub_strt=no_gen;

% Initial algebraic variables and data storing
% *****************************************************
fn=length(x);						%the number of states
all_eig_Dyg=[];					%store all eigenvalues of Dyg
param0=param;						%initial bus injections
XX_sp=[];							%store the states at each parameter value
AA_sp=[];							%store paramater
LAMBDA_SP=[];						%store the smallest eigenvalue that we force to be zero
eig_Dyg=[];							%store the smallest eigenvalue of Dyg computed by eigs command
XX_sing=[];							%store the singular points
PP_sp=[];
sign_Dyg=[];
										%store the real and reactive power injections 
x_sub0=x(sub_strt:fn);			%extract the load bus variables,before the search starts	
alpha_up=AA(CurrentPoint);		%current paramater value in the parameter space
x_up=XX(:,CurrentPoint);		%dynamic and algebraic states at the current parameter,alpha_up

%% Obtain the corresponding paramater values of the lower part
%=================================================================================

for ii=(np+1):length(AA)					%np, the index corresponding to the nose point
   alpha_temp=AA(ii)-alpha_up;
   if abs(alpha_temp)<=0.01
      alphalowindex=ii;
      alpha_low=AA(ii);					%the closest parameter value in the lower part of the nose curve

   end
      
end
%================================================================================================================
x_low=XX(:,alphalowindex);
x_diff=(-x_up+x_low);
mm=find(a);
x_inter=x_diff(1:mm);
x0=x;
% INITIALIZE NRS
% Obtain the smallest eigenvalue of Dy(g(x,y,p)) evaluated at the upper solution
% 1) Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near zero 
% and v0

[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
J=full(J);
B=J(sub_strt+1:fn+1,sub_strt:fn);
lambda_sp=0;
[aa,bb]=eig(B);
rand('state',100);
v=rand(n,1);
v=v/norm(v);
v_gen=zeros(no_gen-1,1);
v(1:no_gen-1)=v_gen;
%options.disp=0;
%sigma=0;
%[try1,try2,flag3]=eigs(B,1,sigma,options);

for j=1:5
    y_sp=(B-lambda_sp*eye(size(B)))\v(sub_strt:fn);
    lambda_sp=lambda_sp+norm(v(sub_strt:fn))^2/((v(sub_strt:fn))'*y_sp);
   v(sub_strt:fn)=y_sp/norm(y_sp);
 end
 
 ttt=lambda_sp;
 norm(v(sub_strt:fn));
 v_load=v(sub_strt:fn);
 %v(sub_strt:fn)=try1;
 %lambda_sp=try2;
 
 
 
 %2) Locate singular point of algebraic equations


deltalambda_sp=-lambda_sp/(NRS_Steps);
for k=1:NRS_Steps+(0.1)*NRS_Steps
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
       t0=clock;
        for i=1:ReportCycle,
           x_sub0=x(sub_strt:fn);
           alpha_sp0=alpha_sp;
           v0=v(sub_strt:fn);
           [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
           J=full(J);
           
            JJ_sp=[   J(sub_strt+1:fn+1,sub_strt:fn)  zeros(2*no_pq,2*no_pq)                                 (J(no_gen+1:n+1,1:mm))*x_inter
                J(sub_strt+1:fn+1,fn+no_gen:2*fn)  J(sub_strt+1:fn+1,sub_strt:fn)-lambda_sp*eye(2*no_pq)  (J(sub_strt+1:fn+1,fn+1:fn+mm))*x_inter
                zeros(1,2*no_pq)                   (v(sub_strt:fn))'/norm(v(sub_strt:fn))                                   0
               ];
            ff_sp=[f(sub_strt+1:fn+1)
                (J(sub_strt+1:fn+1,sub_strt:fn)-lambda_sp*eye(2*no_pq))*v(sub_strt:fn)
                norm(v(sub_strt:fn))-1
               ];
                 
            delta_sp=-sparse(JJ_sp)\ff_sp;
            x(sub_strt:fn)=x_sub0+delta_sp(1:2*no_pq);
            x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);
            v(sub_strt:fn)=v0+delta_sp(2*no_pq+1:4*no_pq);
          
           	alpha_sp=alpha_sp0+delta_sp(4*no_pq+1);
            x(1:mm)=(1-alpha_sp)*x_up(1:mm)+alpha_sp*x_low(1:mm);
            



            
           end
           
        
        AbsError=max([abs(x(sub_strt:fn)-x_sub0);abs(v(sub_strt:fn)-v0);abs(alpha_sp-alpha_sp0)]);
        if (x_sub0==0)&(v0==0)
            RelError='NA';
        else
            RelError=AbsError/max([abs(x_sub0);abs(v0);abs(alpha_sp0)]);
        end

        % set state
         %VST_LFSetState;
         %VST_LFSetParam;

        % set LF control control errors
        set(AbsErrorDisp,'String',num2str(AbsError));
        if isstr(RelError)
            set(RelErrorDisp,'String',RelError);
        else
            set(RelErrorDisp,'String',num2str(RelError));
        end

        set(NumIterations,'String',num2str(j*ReportCycle));
        set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle));

        if (AbsError<=LFAbsTol) ...
            & ((~isstr(RelError)) ...
            & (RelError<=LFRelTol) ...
            | isstr(RelError))
            ConvergenceFlag=1;

            if k==NRS_Steps+1
                vpoc_sp=v(sub_strt:fn);
                wpoc_sp=-null(J(sub_strt+1:fn+1,sub_strt:fn)');
            end
            break;
        end
    end

    if ConvergenceFlag==0
        'NRS Failed to Converge'
        break;
    end
    if k==NRS_Steps+1
       lambda_sp;
       alpha_sp;
       check1=J(sub_strt+1:fn+1,sub_strt:fn);
       XX_sing=[XX_sing x];
       mismatch=f(1:no_gen);
       if ~exist('Total_sing'),Total_sing=[];end
       Total_sing=[Total_sing XX_sing];
    end
    
   
XX_sp=[XX_sp x];
AA_sp=[AA_sp alpha_sp];
PP_sp=[PP_sp param];
LAMBDA_SP=[LAMBDA_SP lambda_sp];
lambda_sp=lambda_sp+deltalambda_sp;
options.disp=0;
%eig_Dyg=[eig_Dyg eigs(J(sub_strt+1:fn+1,sub_strt:fn),1,'SM',options)]; 
%all_eig_Dyg=[all_eig_Dyg eig(J(sub_strt+1:fn+1,sub_strt:fn))];
%sign_Dyg=[sign_Dyg sign(det(J(sub_strt+1:fn+1,sub_strt:fn)))];


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

