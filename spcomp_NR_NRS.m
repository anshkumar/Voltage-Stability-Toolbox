 % spcomp_NR_NRS.m file is written to search the singular points
% in the state-space by changing the dynamic variables.
% It implements NR and Newton-Raphson-Seydel algorithms together
%to avoid the singularity of algebraic jacobian matrix, Dyg(x,y)
% The dynamic variables are parameterized as follows:
% x=(1-alpha)x_upper + alpha*x_lower
% This M-file enables us to change more than one dynamic variables
%For example, delta2, delta2+delta3, delta2+delta3+delta4....
%==========================================================================

% Reorder parameter values such that param=[P Q]'
t1=cputime;												%simulation starting time
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
f_mismatches=[];
%===========================================================================

% Specify the initial parameter and some indexing
% ==================================================================
alphamax_sp=30;							%maximum parameter value
alpha_sp=0;								%inital paramter value								
n=length(x);							%number of states
sub_strt=no_gen;						%number of generators

% Initial load bus variables and data storing
% ****************************************************
fn=length(x);						%number of states
all_eig_Dyg=[];					%all eigenvalues of Dyg
param0=param;						%bus injections
XX_sp=[];							%the states at each parameter value
AA_sp=[];							%paramater
LAMBDA_SP=[];						%the smallest eigenvalue of the matrix Dyg(x,y)from NRS method
eig_Dyg=[];							%the smallest eigenvalue of Dyg computed by "eigs" command
XX_sing=[];							%singular points
PP_sp=[];							%real and reactive power injections 
sign_Dyg=[];						%sign of the det[Dyg(x,y)]
reg_index1=[];						%voltage causal region index 1 based on the total number of negative eigenvalues of Dyg(x,y)
reg_index2=[];						%voltage causal region index 2 based on the total number of positive eiegenvalues of Dyg(x,y)
x_sub0=x(sub_strt:fn);			%initial load bus variables (voltage magnitude and angle) 	
alpha_up=AA(CurrentPoint);		%current paramater value in the parameter space
x_up=XX(:,CurrentPoint);		%state at the upper equilibrium point
alpha_low=[];
alphalowindex=[];

if ~exist('AAA'),AAA=[];end
      AAA=[AAA alpha_up];		%store parameter value at which singular point is computed along the nose curve 	


% Obtain the corresponding paramater values of the lower part
%=================================================================================
for ii=(np+1):length(AA)						%np :index corresponding to the nose point
   alpha_temp=AA(ii)-alpha_up;
   if abs(alpha_temp)<=0.0001
      alphalowindex=ii;
      alpha_low=AA(ii);			%closest parameter value in the lower part of the nose curve
   
else
   'No alpha_low found';
end

      
end
%====================================================================================================
x_low=XX(:,alphalowindex);	 	%lower equilibrium point at the current parameter value
x_diff=(-x_up+x_low);		 	%difference between the lower and upper equilibrium points
mm=find(a);							%index for gen. variables to be parameterized
%a1=a.*[sys_eig_small(:,CurrentPoint);zeros(2*no_pq,1)];
%a1=ones(size(a))-a;				% 08/18/00, another index column vector
%x_inter=x_diff.*a1;
x_inter=x_diff(1:mm);
%x_inter=x_diff.*a;				%08/18/00, get the corresponding gen. angle
v=zeros(n,1);						% initial right eiegenvector including generator angles and load bus variables					
x0=x;									% initial states

% Perform Standard NR
%==============================================================================

for k=1:NR_steps+1
   
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle,
            x_sub0=x(sub_strt:fn);
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
            J=full(J);
          delta=-J(sub_strt+1:fn+1,sub_strt:fn)\f(sub_strt+1:fn+1);
          x(sub_strt:fn)=x_sub0+delta;
          x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);			%update load bus variables
          
			end

		% Error checking
        AbsError=max(abs(x(sub_strt:fn)-x_sub0));
        if x_sub0==0
            RelError='NA';
        else
            RelError=AbsError/max(abs(x_sub0));
        end
          
        %set LF control control errors
        set(AbsErrorDisp,'String',num2str(AbsError));
        if isstr(RelError)
            set(RelErrorDisp,'String',RelError);
        else
            set(RelErrorDisp,'String',num2str(RelError));
        end

        set(NumIterations,'String',num2str(j*ReportCycle));
        set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle))
        
        % Compare errors with the tolerances
        %=========================================================================
        if (AbsError<=LFAbsTol*0.001) ...
            & ((~ischar(RelError)) ...
            & (RelError<=LFRelTol*0.01) ...
            | ischar(RelError))
            ConvergenceFlag=1;
            break;
        end
    end

if ConvergenceFlag==0
   'NR fails to converge'
   k
        break;
     end
      

    XX_sp=[XX_sp x];																%update XX_sp
    AA_sp=[AA_sp alpha_sp];													%update AA_sp
    PP_sp=[PP_sp param];														%update PP_sp
    options.disp=0;
    %eig_Dyg=[eig_Dyg eigs(J(sub_strt+1:fn+1,sub_strt:fn),1,'SM',options)];   %store the smallest eigenvalue of Dyg
    %sign_Dyg=[sign_Dyg sign(det(J(sub_strt+1:fn+1,sub_strt:fn)))];
    %ee=eig(J(sub_strt+1:fn+1,sub_strt:fn));
    %all_eig_Dyg=[all_eig_Dyg ee];           %store all eigenvalues of Dyg
    alpha_sp=alpha_sp+alphamax_sp/(NR_steps);
    
    %============================================
    %indexing each point on the constraint manifold based on the total number of positive (negative)real eigenvalues of Dyg(x,y)
    %[ind1]=find((imag(ee)==0)&(real(ee)<0));
    %[ind2]=find((imag(ee)==0)&(real(ee)>0));
    %reg_index1=[reg_index1 length(ind1)];				% index based on the total number negative real eigenvalues of Dyg(x,y)
    %reg_index2=[reg_index2 length(ind2)];				% index based in the total number positive real eigenvalues of Dyg(x,y) 
    
    x(1:mm)=[(1-alpha_sp)*x_up(1:mm)+alpha_sp*x_low(1:mm)];		%11/17/00
    %angle_temp=x(1:mm);
    %for i=1:length(angle_temp)
      % angle_temp(i)=unwrap(angle_temp(i),2*pi);
    %end
    %x(1:mm)=angle_temp;
    
    %x_temp=[(1-alpha_sp)*(x_up.*a)+alpha_sp*(x_low.*a)];  		%08/18/00
    %x=x.*a1+x_temp;															% 08/18/00
    %f_mismatches=[f_mismatches f];								%equations evaluated along the search
    
 end
 
 % evaluate Jacobian and equations at the end of NR iteration
 %[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
 %f_new=f;

% INITIALIZE NRS
% Obtain the smallest eigenvalue of Dy(g(x,y,p)) evaluated at the last step of NR
% 1) Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near zero 
% and v0

[nrows_sp,ncols_sp]=size(XX_sp);								%number of rows and columns before NRS starts
x=XX_sp(:,ncols_sp);
alpha_sp=AA_sp(1,ncols_sp);        							%paramater value before NRS
[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
J=full(J);
B=J(sub_strt+1:fn+1,sub_strt:fn);							%The matrix Dyg just before NRS
lambda_sp=0;														%Initial estimate for the smallest eigenvalue of Dyg													
rand('state',100);
v_load=rand(2*no_pq,1);											% a random eigenvector
v_load=v_load/norm(v_load);									% normalized random eigenvector
v_gen=zeros(no_gen-1,1);										%components of v corresponding to generator angles are zero


%=====================================================================
%inverse iteration method to estimate the smallest eigenvalue of Dyg
%=====================================================================
for j=1:3
   lambda_sp;
    y_sp=(B-lambda_sp*eye(size(B)))\v_load;
    lambda_sp=lambda_sp+norm(v_load)^2/((v_load)'*y_sp);
   v_load=y_sp/norm(y_sp);
 end

v_temp=v_load;
v(no_gen:fn)=v_load;
 lambda_temp=lambda_sp;
 
 % another algorithm to find the real eigenvalue of Dyg closed to the origin with
 %its corresponding eigenvector
 
%[aa,bb]=eig(B);
%bbb=diag(bb);
%real_eig=[];
%index=find(imag(diag(bb))==0);
%for ii=1:length(index)
%   jj=index(ii);
   
 %  real_eig=[real_eig bbb(jj)];
%end
%[lambda_sp, I]=min(abs(real_eig));
%if real_eig(I)<0
 %  lambda_sp=-lambda_sp;
%else
 %  lambda_sp=lambda_sp;
%end
%ttt2=lambda_sp;
%ttt3=aa(:,index(I));

%ttt2=lambda_sp;
%v(sub_strt:fn)=v_load;
%lambda_sp=ttt1;

  
 %===============================================================================
 
 % Locate singular point of algebraic equations (Newton-Raphson-Seydel Algorithm)
 %================================================================================


deltalambda_sp=-lambda_sp/(NRS_Steps);	%step-size while controlling the smallest eigenvalue of Dyg
for k=1:NRS_Steps+(0.51)*NRS_Steps
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
       t0=clock;
        for i=1:ReportCycle,
           x_sub0=x(sub_strt:fn);
           alpha_sp0=alpha_sp;
           v0=v(sub_strt:fn);
           [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
           J=full(J);

           %the following is based on new parameterization,08/18/00
             JJ_sp=[   J(sub_strt+1:fn+1,sub_strt:fn)  zeros(2*no_pq,2*no_pq)                                 (J(sub_strt+1:fn+1,1:mm))*(x_inter)
                J(sub_strt+1:fn+1,fn+sub_strt:2*fn)  J(sub_strt+1:fn+1,sub_strt:fn)-lambda_sp*eye(2*no_pq)  J(sub_strt+1:fn+1,fn+1:fn+mm)*(x_inter)
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
               
               x(1:mm)=[(1-alpha_sp)*x_up(1:mm)+alpha_sp*x_low(1:mm)];%11/17/00 
               %angle_temp=x(1:mm);
    %for i=1:length(angle_temp)
       %angle_temp(i)=unwrap(angle_temp(i),2*pi);
    %end
    %x(1:mm)=angle_temp;

               
               %x_temp=[(1-alpha_sp)*(x_up.*a)+alpha_sp*(x_low.*a)];  %08/18/00
               
               %x=x.*a1+x_temp;														% 08/18/00
               

              
              
              
         end
  
         % Define the errors in states, eigenvector and paramater
         %===========================================================================================
        AbsError=max([abs(x(sub_strt:fn)-x_sub0);abs(v(sub_strt:fn)-v0);abs(alpha_sp-alpha_sp0)]);
        if (x_sub0==0)&(v0==0)
            RelError='NA';
        else
            RelError=AbsError/max([abs(x_sub0);abs(v0);abs(alpha_sp0)]);
        end

        

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
            break;
        end
    end

    if ConvergenceFlag==0
        'NRS Failed to Converge'
        break;
    end
    if k==NRS_Steps+1
       Dyg=J(sub_strt+1:fn+1,sub_strt:fn);		% The matrix Dyg at the singular point
       [n_sp,m_sp]=size(AA_sp);							% index
       XX_sing=x;												% singular point
       vpoc_sp=v(sub_strt:fn);							% right eigenvector corresponding to zero eigenvalue of Dyg(x,y)
       mismatch=f(1:no_gen);								% real power mismatch at the singular point
       lamda_smallest=lambda_sp;							% zero eigenvalue of Dyg
       

		wpoc_sp=-null(J(sub_strt+1:fn+1,sub_strt:fn)'); % left eigenvector corresponding to zero eigenvalue of Dyg(x,y)
      if ~exist('Total_mis'),Total_mis=[];end
      Total_mis=[Total_mis mismatch];						% real power mismatches at different singular points
       if ~exist('Total_sing'),Total_sing=[];end
       Total_sing=[Total_sing XX_sing];					% singular points
    end
  
	XX_sp=[XX_sp x];
	AA_sp=[AA_sp alpha_sp];
	PP_sp=[PP_sp param];
	LAMBDA_SP=[LAMBDA_SP lambda_sp];  
   lambda_sp=lambda_sp+deltalambda_sp;
   
   %eig_Dyg=[eig_Dyg eigs(J(sub_strt+1:fn+1,sub_strt:fn),1,'SM',options)]; 
   %ee=eig(J(sub_strt+1:fn+1,sub_strt:fn));		
	%all_eig_Dyg=[all_eig_Dyg ee]; 
   %sign_Dyg=[sign_Dyg sign(det(J(sub_strt+1:fn+1,sub_strt:fn)))];
   %[ind1]=find((imag(ee)==0)&(real(ee)<0));
   %[ind2]=find((imag(ee)==0)&(real(ee)>0));
   %reg_index1=[reg_index1 length(ind1)];			
   %reg_index2=[reg_index2 length(ind2)];
   
   %angle_temp=x(1:mm);
    %for i=1:length(angle_temp)
       %angle_temp(i)=unwrap(angle_temp(i),2*pi);
    %end
    %x(1:mm)=angle_temp;


end
%Back to NR algorithm
[n_rows_sp,n_cols_sp]=size(AA_sp);
delta_alpha_sp=-(AA_sp(n_cols_sp))/(NR_steps);
for k=1:2*NR_steps+1
   
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle,
            x_sub0=x(sub_strt:fn);
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
           J=full(J);
          delta=-J(sub_strt+1:fn+1,sub_strt:fn)\f(sub_strt+1:fn+1);
          x(sub_strt:fn)=x_sub0+delta;
          x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);			%update load bus variables
          
			end

		 %Error checking
        AbsError=max(abs(x(sub_strt:fn)-x_sub0));
       if x_sub0==0
            RelError='NA';
        else
            RelError=AbsError/max(abs(x_sub0));
        end
          
        %set LF control control errors
        set(AbsErrorDisp,'String',num2str(AbsError));
        if isstr(RelError)
            set(RelErrorDisp,'String',RelError);
        else
            set(RelErrorDisp,'String',num2str(RelError));
        end

        set(NumIterations,'String',num2str(j*ReportCycle));
        set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle))
        
        % Compare errors with the tolerances
        %=========================================================================
        if (AbsError<=LFAbsTol*0.001) ...
            & ((~ischar(RelError)) ...
            & (RelError<=LFRelTol*0.01) ...
            | ischar(RelError))
            ConvergenceFlag=1;
            break;
        end
    end

if ConvergenceFlag==0
   'NR fails to converge'
   k
        break;
     end
      

    XX_sp=[XX_sp x];																%update XX_sp
    AA_sp=[AA_sp alpha_sp];													%update AA_sp
    PP_sp=[PP_sp param];														%update PP_sp
    alpha_sp=alpha_sp+delta_alpha_sp;
    x(1:mm)=[(1-alpha_sp)*x_up(1:mm)+alpha_sp*x_low(1:mm)];
    
    if alpha_sp >1.01
        return;
     end
  end
  




t2=cputime-t1;		%total simulation time


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
   

