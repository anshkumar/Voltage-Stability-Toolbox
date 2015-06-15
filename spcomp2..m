% spcomp2.m file is written to search the singular points
% in the state-space by changing the dynamic variables.
% It implements a Newton-Raphson-Seydel algorithm
%to avoid the singularity of the load flow Jacobian,Dyg(x,y)


% Specify the initial parameter and some indexing
% *************************************************
alpha_sp=0;
n=length(x);
sub_strt=no_gen;

% Initial algebraic variables and data storing
% *****************************************************
fn=length(x);

param0=param;
XX_sp=[];
AA_sp=[];
LAMBDA_SP=[];
alpha_sp=0;
XX_sing=[];
PP_sp=[];
x_sub0=x(sub_strt:fn);
x_gen=x(1:no_gen-1);
alpha_up=AA(CurrentPoint);
x_up=XX(:,CurrentPoint);
for ii=(CurrentPoint+1):length(AA)
   alpha_temp=AA(ii)-alpha_up;
   if abs(alpha_temp)<=0.01
      alphalowindex=ii;
      alpha_low=AA(ii);
   end
      
end

x_low=XX(:,alphalowindex);
x_diff=(-x_up+x_low);
x_inter=x_diff(1:no_gen-1);
v=zeros(n,1);
x0=x;
% INITIALIZE NRS
% Obtain the smallest eigenvalue of Dy(g(x,y,p)) evaluated at the upper solution
% 1) Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near zero 
% and v0

[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);

B=J(sub_strt+1:fn+1,sub_strt:fn);
lambda_sp=0;
eig(B)
rand('state',100)
v=rand(n,1);
v=v/norm(v);
v;
for j=1:4
    y_sp=(B-lambda_sp*eye(size(B)))\v(sub_strt:fn);
    lambda_sp=lambda_sp+norm(v(sub_strt:fn))^2/((v(sub_strt:fn))'*y_sp);
   v(sub_strt:fn)=y_sp/norm(y_sp);
 end
 v;
 lambda_sp
 norm(v(sub_strt:fn));
 
 
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
           
            JJ_sp=[   J(sub_strt+1:fn+1,sub_strt:fn)  zeros(2*no_pq,2*no_pq)                                 (J(no_gen+1:n+1,1:no_gen-1))*x_inter
                J(sub_strt+1:fn+1,fn+no_gen:2*fn)  J(sub_strt+1:fn+1,sub_strt:fn)-lambda_sp*eye(2*no_pq)  (J(sub_strt+1:fn+1,fn+1:fn+no_gen-1))*x_inter
                zeros(1,2*no_pq)                   (v(sub_strt:fn))'/norm(v(sub_strt:fn))                                   0
               ];
            ff_sp=[f(sub_strt+1:fn+1)
                (J(sub_strt+1:fn+1,sub_strt:fn)-lambda_sp*eye(2*no_pq))*v(sub_strt:fn)
                norm(v(sub_strt:fn))-1
               ];
                 
            delta_sp=-(JJ_sp)\ff_sp;
            x(sub_strt:fn)=x_sub0+delta_sp(1:2*no_pq);
            x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);
            v(sub_strt:fn)=v0+delta_sp(2*no_pq+1:4*no_pq);
           	alpha_sp=alpha_sp0+delta_sp(4*no_pq+1);
            x(1:no_gen-1)=(1-alpha_sp)*x_up(1:no_gen-1)+alpha_sp*x_low(1:no_gen-1);
			

            
           end
           lambda_sp;
           
        
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
       if ~exist('Total_sing'),Total_sing=[];end
       Total_sing=[Total_sing XX_sing]
    end
    
   % if alpha_sp>=alphamax_sp
    %    return;
   % end

XX_sp=[XX_sp x];
AA_sp=[AA_sp alpha_sp];
PP_sp=[PP_sp param];
LAMBDA_SP=[LAMBDA_SP lambda_sp];  
lambda_sp=lambda_sp+deltalambda_sp;
         
 end
