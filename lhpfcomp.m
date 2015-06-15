% Compute Point of Collapse & Hopf Bifurcation points 
% Trace the equilibrium points with their Stability Properties
% ********************************************************


param';
% specify direction in parameter space
% *************************************************
n=length(x);				% The number of States
sub_strt=no_gen;			% The number of generators

% Initial real and reactive power injections
% *****************************************************
fn=length(x);
param0=param;

% Define emty vectors for rigth and left eingenvectors at collpase point
% **********************************************************************
vpoc=zeros(n,1);			 % right eigenvector
wpoc=zeros(n,1);			 % left eigenvector

XX=[];						 % stores the states at each parameter
AA=[];						 % stores the parameter 
alpha=0;						 % initial parameter value
PP=[];						 % stores the real and reactive power injection
v=zeros(n,1);				 % A zero right eiegenvector
Stab=[];						 % stores the stability properties of equilibrium points
sys_eig_small1=[];
sys_small=[];
sys_eig_small=[];
sys_eig=[];					% stores the eigenvalues of system matrix: delta_x_dot=(Asys)*delta_x
Dyg_eig=[];					% stores the eiegenvalues of Dyg matrix
imag_dd=[];					% stores the imaginary part of the Asys eiegenvalues
real_dd=[];					% Stores the real part of the Asys eiegenvalues
Ksys_eig=[];				% Stores the eigenvalues of Ksys=[Dxf]-[Dyf]*inv([Dyg])*[Dxg]
reg_index1=[];				% Stores the index of voltage causal region
reg_index2=[];
% Perform Standard NR
gen_damp=(0.3).*ones(1,no_gen);

N=n;
for k=1:NR_steps+1
  ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle), %start iteratioons
        t0=clock;
        for i=1:ReportCycle, % Start iterations
            x0=x;
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']); %evaluate Jacobian and mismatch vectors
            J=full(J);
            delta=-sparse(J(2:n+1,1:n))\f(2:n+1);
            x=x0+delta;
         end
     	% Define absolute and real errors
        AbsError=max(abs(x-x0));
        if x0==0
            RelError='NA';		% Real error is not availbale (NA)
        else
            RelError=AbsError/max(abs(x0)); % normalize the absolute error
        end
          
        %set LF control control errors
        set(AbsErrorDisp,'String',num2str(AbsError));
        if ischar(RelError)
            set(RelErrorDisp,'String',RelError);
        else
            set(RelErrorDisp,'String',num2str(RelError));
        end

        set(NumIterations,'String',num2str(j*ReportCycle));
        set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle))
        
        % Compare the absolute and real error eith the tolerances
        if (AbsError<=LFAbsTol*0.001) ...		%Tolerence=LFAbsTol
            & ((~ischar(RelError)) ...
            & (RelError<=LFRelTol*0.01) ...	%RelTolerence=LFRelTol
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

    XX=[XX x];				%Update XX matrix after the iteration
    AA=[AA alpha];		%Update AA matrix after the iteration
    PP=[PP param];		%Update PP matrix after the iteration
    
    % Define the system matrix
    %*************************************************************************************************
    Ksys=J(2:no_gen,1:no_gen-1)-J(2:no_gen,no_gen:n)...
       *(J(no_gen+1:n+1,no_gen:n)\J(no_gen+1:n+1,1:no_gen-1));
    %**************************************************************************************************
    % Information on the each Jacobian matrix
    % Dxf=J(2:no_gen,1:no_gen-1), Dyf=J(2:no_gen,no_gen:n),Dyg=J(no_gen+1:n+1,no_gen:n) and 
    %Dxg=J(no_gen+1:n+1,1:no_gen-1)
    % In matlab, A\B=inv(A)*B
    % Ksys=[Dxf]-[Dyf]*inv([Dyg])*[Dxg]
    %**************************************************************************************************
    Asys=[zeros(size(diag(gen_inertia(2:no_gen))))...
        diag(gen_inertia(2:no_gen))
     -Ksys, -diag(gen_damp(2:no_gen))/diag(gen_inertia(2:no_gen))];
%  Asys_1=[zeros(size(diag(gen_inertia(2:no_gen)))) eye(no_gen-1)
 %    -diag(gen_inertia(2:no_gen))\Ksys -diag(gen_inertia(2:no_gen))\diag(gen_damp(2:no_gen))];
%*******************************************************************************88

	OPTIONS.disp=0;
%   [v_small dd_small]=eigs(Asys_1,1,'LR',OPTIONS);
 %  sys_small=[sys_small dd_small];
  % sys_eig_small1=[sys_eig_small1 (v_small)];
   %v_small_gen=abs(v_small(1:no_gen-1));
   %v_small_gen=real(v_small(1:no_gen-1));
   %v_small_gen=v_small_gen/norm(v_small_gen);
   %v_small_gen=abs(v_small_gen);
   %sys_eig_small=[sys_eig_small v_small_gen];
   
   dd=eig(Asys);                               %compute eigenvalues of system matrix, Asys
    imag_dd=[imag_dd imag(dd)];						%update imag_dd 
    real_dd=[real_dd real(dd)];						%update real_dd
    [r_maxdd,s]=max(real(dd));						%maximum of real_dd
    sys_eig=[sys_eig dd];								%update eigenvalues of system matrix
    
    %ee=eigs(J(sub_strt+1:fn+1,sub_strt:fn),OPTIONS);		%eigenvalues of Dyg
    %============================================
    %indexing each equilibrium point based on the 
    %number of negative eigenvalues of Dyg
    %[ind1]=find((imag(ee)==0)&(real(ee)<0));
    %[ind2]=find((imag(ee)==0)&(real(ee)>0));
    %reg_index1=[reg_index1 length(ind1)];				%determine the index of voltage causal region
    %reg_index2=[reg_index2 length(ind2)];
    %==========================================
    %Dyg_eig=[Dyg_eig ee];								%update Dyg_eig
    %ff=eigs(Ksys,OPTIONS);											%eigenvalues of Ksys
    %Ksys_eig=[Ksys_eig ff];							%updat Ksys
    								
    									

    if r_maxdd<=100*eps  			% All eigenvalues are on the LFP, which means stability
    	if sign(imag(dd(s)))~=0       
        Stab=[Stab 1];				% (1) means oscillatory stable
        else
        Stab=[Stab 2];				% (2) asymptotically stable;
        end
     elseif r_maxdd>100*eps  		% eigenvalue  on the RHP, which means instability
    	if sign(imag(dd(s)))~=0       
        Stab=[Stab 3];				% (3) means oscillatory unstable
        else
        Stab=[Stab 4];				% (4) means asymptotically unstable
        end   
    
    else
    	Stab=[Stab 5];	
    	
       
    end
    
    alpha=alpha+alphamax/(NR_steps);
    if alpha>=alphamax
        [nrows,ncols]=size(XX);
        return;
    end

param=param+p*alphamax/(NR_steps);
end

% INITIALIZE NRS
% 2) Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near 0
% and v0

[nrows,ncols]=size(XX); 							% size of XX matrix
x=XX(:,ncols);											% states vector right after the NR (just before NRS starts)
alpha=AA(1,ncols);									% paramater right after the NR (just before NRS starts)
param=param0+p*alpha;								% Real and reactive injections just before (just before NRS)
[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']); 	% load-flow eqn. and Jacobian
J=full(J);
A=J(2:n+1,1:n);										%load-flow Jacobian matrix
lambda=0;												%initial estimate for the eigenvalue of A
rand('state',100)
v=rand(n,1);
v=v/norm(v);									%initial estimate for the right eigenvector of A correspondin to lambda

%Inverse iteration (inverse power) method
%==========================================
for j=1:10,
    y=(A-lambda*eye(size(A)))\v;
    lambda=lambda+norm(v)^2/(v'*y);
    v=y/norm(y);
 end
 
 %==========================================
 check1=lambda;
 check2=v;
 %===========================================
  %use Matlab eigs command to find estimate eigenvalue close to zero and the corresponding eigenvector
 %====================================================================================================
 sigma=0; 												% the zero eigenvalue
 OPTIONS.disp=0;										% no intermediate output
 [eig_vect0,lambda0,flag1]=eigs(A,1,sigma,OPTIONS); % the eigenvalue and eigenvector
 %=====================================================================================================
 v=eig_vect0;											%assign the eigenvector from eigs rather than inverse iteration
 lambda=lambda0								%assign the eigenvalue from eigs	rather than inverse iteration
 
 
% 3) Locate Point of Collapse
deltalambda=-lambda/NRS_Steps;
%============================================================================================================
for k=1:NRS_Steps+(0.51)*NRS_Steps    
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
       t0=clock;
        %====================================================================
        for i=1:ReportCycle,
           x0=x;
           alpha0=alpha;
           v0=v;
           [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
           J=full(J);
           
           % Define the extended Jacobian Matrix to avoid the singularity
           
            JJ=[   J(2:n+1,1:n)   zeros(n,n)                  -p
                J(2:n+1,n+1:2*n)  J(2:n+1,1:n)-lambda*eye(n)  zeros(n,1)
                zeros(1,n)        v'/norm(v)                  0
               ];
            ff=[f(2:n+1)
                (J(2:n+1,1:n)-lambda*eye(n))*v
                norm(v)-1
               ];
               
            delta=-sparse(JJ)\ff;
            x=x0+delta(1:n);					%states
            v=v0+delta(n+1:2*n);				%right eigenvector
            alpha=alpha0+delta(2*n+1);		%parameter
            param=param0+p*alpha;			%update the active and reactive power injections
            
         end
         %=====================================================================
        
         AbsError=max([abs(x-x0);abs(v-v0);abs(alpha-alpha0)]);
         %=======================================================
        if (x0==0)&(v0==0)&(alpha0==0)
            RelError='NA';
        else
            RelError=AbsError/max([abs(x0);abs(v0);abs(alpha0)]);
         end
         %====================================================

        % set state
        % VST_LFSetState;
        % VST_LFSetParam;

			% set LF control control errors
         set(AbsErrorDisp,'String',num2str(AbsError));
         %==============================================
        	if isstr(RelError)
            set(RelErrorDisp,'String',RelError);
        	else
            set(RelErrorDisp,'String',num2str(RelError));
         end
         %==============================================
         

        set(NumIterations,'String',num2str(j*ReportCycle));
        set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle));
        %=====================================
        if (AbsError<=LFAbsTol) ...
            & ((~isstr(RelError)) ...
            & (RelError<=LFRelTol) ...
            | isstr(RelError))
         	ConvergenceFlag=1;
         
            % check the zero eigenvalue
            %=========================
            if k==NRS_Steps+1
               LF_jacob=J(2:n+1,1:n);
               eig_LF_Jacob=eig(LF_jacob);
               eig_Dyg_tip=eig(J(sub_strt+1:fn+1,sub_strt:fn));
            end
            %======================
            % Evaluate right and left eigenvector 
            % at the point of collpase
            %=====================================
            if k==NRS_Steps+1
               vpoc=v;
               wpoc=-null(J(2:n+1,1:n)');
               [mp,np]=size(XX);
            end
            %=======================================  
            
            break;
         end
         %===============================================================================
      end
      %====================================================================================
	%===============================
   if ConvergenceFlag==0
      'NRS Failed to Converge'
       
        break;
     end
     %=============================
	%=======================
    if alpha>=alphamax
        return;
     end
     %=======================

XX=[XX x];
AA=[AA alpha];
PP=[PP param];
lambda=lambda+deltalambda;
Ksys=J(2:no_gen,1:no_gen-1)-J(2:no_gen,no_gen:n)...
   *(J(no_gen+1:n+1,no_gen:n)\J(no_gen+1:n+1,1:no_gen-1));
Asys=[zeros(size(diag(gen_inertia(2:no_gen)))) ...
        diag(gen_inertia(2:no_gen))
     -Ksys, -diag(gen_damp(2:no_gen))/diag(gen_inertia(2:no_gen))];
%Asys_1=[zeros(size(diag(gen_inertia(2:no_gen)))) eye(no_gen-1)
 %    -diag(gen_inertia(2:no_gen))\Ksys -diag(gen_inertia(2:no_gen))\diag(gen_damp(2:no_gen))];


dd=eig(Asys);
[r_maxdd,s]=max(real(dd));
sys_eig=[sys_eig dd];

%if k<=NRS_Steps
 %  OPTIONS.disp=0;
  % [v_small dd_small]=eigs(Asys_1,1,'LR',OPTIONS);
   %sys_small=[sys_small dd_small];
   %sys_eig_small1=[sys_eig_small1 (v_small)];
   %v_small_gen=abs(v_small(1:no_gen-1));
	%v_small_gen=real(v_small(1:no_gen-1));
   %v_small_gen=v_small_gen/norm(v_small_gen);
   %v_small_gen=abs(v_small_gen);
	%sys_eig_small=[sys_eig_small v_small_gen];


%end



%ee=eigs(J(sub_strt+1:fn+1,sub_strt:fn),OPTIONS);
%[ind1]=find((imag(ee)==0)&(real(ee)<0));
%reg_index1=[reg_index1 length(ind1)];
%[ind2]=find((imag(ee)==0)&(real(ee)>0));
%reg_index2=[reg_index2 length(ind2)];

%Dyg_eig=[Dyg_eig ee];
%ff=eigs(Ksys,OPTIONS);											
%Ksys_eig=[Ksys_eig ff];	
							
	%=================================
    if r_maxdd<=100*eps  
    	if sign(imag(dd(s)))~=0       
        Stab=[Stab 1];
        else
        Stab=[Stab 2];
        end
     elseif r_maxdd>100*eps  
    	if sign(imag(dd(s)))~=0      
        Stab=[Stab 3];
        else
        Stab=[Stab 4];
        end   
    
    else
    	Stab=[Stab 5];	
    	
    end
    %===============================
    
 end
 %===================================================================

 'back to the NR algorithm'

% Back to NR algorithm

[n_rows,n_cols]=size(AA);
%***********************************************
%the following is used for IEEE14 bus system
del_alpha=(AA(n_cols)/(NR_steps));  
%***********************************************
%del_alpha=(alphamax/(NR_steps));

%alpha=alpha-del_alpha;

for k=1:NR_steps+(0.6)*NR_steps
	ConvergenceFlag=0;
	for j=1:round(MaxIterations/ReportCycle)
        t0=clock;
        for i=1:ReportCycle
            x0=x;
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
            J=full(J);
            delta=-sparse(J(2:n+1,1:n))\f(2:n+1);
            x=x0+delta;
         end
         
        AbsError=max(abs(x-x0));
        if x0==0
            RelError='NA';
        else
            RelError=AbsError/max(abs(x0));
        end
          
        %%set LF control control errors
        
       set(AbsErrorDisp,'String',num2str(AbsError));
        if isstr(RelError)
            set(RelErrorDisp,'String',RelError);
        else
           set(RelErrorDisp,'String',num2str(RelError));
        end

       set(NumIterations,'String',num2str(j*ReportCycle));
       set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle))

        if (AbsError<=LFAbsTol*0.001) ...
           & ((~isstr(RelError)) ...
            & (RelError<=LFRelTol*0.01) ...
             | isstr(RelError))
            ConvergenceFlag=1;
            break;
        end
    end

if ConvergenceFlag==0
   'NR fails to converge'
   
   break;
    end

    XX=[XX x];
    AA=[AA alpha];
    PP=[PP param];
   
    Ksys=J(2:no_gen,1:no_gen-1)-J(2:no_gen,no_gen:n)...
        *(J(no_gen+1:n+1,no_gen:n)\J(no_gen+1:n+1,1:no_gen-1));
    Asys=[zeros(size(diag(gen_inertia(2:no_gen))))...
        diag(gen_inertia(2:no_gen))
     -Ksys, -diag(gen_damp(2:no_gen))/diag(gen_inertia(2:no_gen))];
%  Asys_1=[zeros(size(diag(gen_inertia(2:no_gen)))) eye(no_gen-1)
 %    -diag(gen_inertia(2:no_gen))\Ksys -diag(gen_inertia(2:no_gen))\diag(gen_damp(2:no_gen))];


dd=eig(Asys);

    sys_eig=[sys_eig dd];
    %ee=eigs(J(sub_strt+1:fn+1,sub_strt:fn),OPTIONS);
    %[ind1]=find((imag(ee)==0)&(real(ee)<0));
    %reg_index1=[reg_index1 length(ind1)];
    %[ind2]=find((imag(ee)==0)&(real(ee)>0));
    %reg_index2=[reg_index2 length(ind2)];

	% Dyg_eig=[Dyg_eig ee];
    %ff=eigs(Ksys,OPTIONS);										
    %Ksys_eig=[Ksys_eig ff];
    [r_maxdd,s]=max(real(dd));

    if r_maxdd<=100*eps  
    	if sign(imag(dd(s)))~=0       
        Stab=[Stab 1];
        else
        Stab=[Stab 2];
        end
     elseif r_maxdd>100*eps  
    	if sign(imag(dd(s)))~=0       
        Stab=[Stab 3];
        else
        Stab=[Stab 4];
        end   
    
    else
    	Stab=[Stab 5];	
    	
    end
    alpha=alpha-del_alpha;
    if alpha<=0
        return;
     end
     %*****************************************************************************
     % The following investigates the sensitivity around SIB if it happens....
     % I want to identify the stability exchange from unstable to stable 
     sib=length(Stab);				% obtain length of the Stab
     sib_1=Stab(sib);				% Check stability feature
     sib_2=Stab(sib-1);				%Check stability feature of previous load value
     if sib_2~=sib_1					%check stability exchanges
        'hello:Singularity-Induced Bifurcation has occured';
        sib
        options.disp=0;
        Dyg=J(sub_strt+1:fn+1,sub_strt:fn);			%Dyg is the Jacobian of algebraic part
       [dyg_v1,dygeig1,flag1]=eigs(Dyg,1,'SM',options);		
       [sib_v1,sib_eig1,flag2]=eigs(Asys,1,'LM',options);
    end
    
  % ===================================================================  
  param=param-p*del_alpha;
  
end



