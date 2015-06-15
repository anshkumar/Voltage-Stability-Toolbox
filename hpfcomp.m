% Compute Point of Collapse & Hopf Bifurcation points
% ********************************************************

% specify direction in parameter space
% *************************************************

n=length(x);

% Initial real and reactive power injections
% *****************************************************

param0=param;

% Define emty vectors for rigth and left eingenvectors at collpase point
% **********************************************************************
vpoc=zeros(n,1);
wpoc=zeros(n,1);

XX=[];AA=[];alpha=0;PP=[];
v=zeros(n,1);
Stab=[];

chleigv=[];
imag_dd=[];
real_dd=[];
crt_dd=[];
% Perform Standard NR

for k=1:NR_steps+1
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle,
            x0=x;
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
            delta=-sparse(J(2:n+1,1:n))\f(2:n+1);
            x=x0+delta;
        end

        AbsError=max(abs(x-x0));
        if x0==0
            RelError='NA';
        else
            RelError=AbsError/max(abs(x0));
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
   alpha
   k
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

    dd=eig(Asys);
    imag_dd=[imag_dd imag(dd)];
    real_dd=[real_dd real(dd)];
    [r_maxdd,s]=max(real(dd));
    crt_dd=[crt_dd,dd(s)];
   
   chleigv=[chleigv dd];
   

    if r_maxdd<=100*eps      % all eigenvalues are on the LHP,stable
    	if sign(imag(dd(s)))~=0     
        Stab=[Stab 1]; 				% (1) means oscillatory stable 
        else
        Stab=[Stab 2];  				%(2) means asymp. stable
        end
     elseif r_maxdd>100*eps     % all eiegnvalues are on the RHP,unstable
    	if sign(imag(dd(s)))~=0       
        Stab=[Stab 3];   			%(3) means oscillatory unstable
        else
        Stab=[Stab 4];   			% (4) means asymp.unstable
        end   
    
    else
    	Stab=[Stab 5];	
    	
    end

    alpha=alpha+alphamax/NR_steps;
    if alpha>=alphamax
        [nrows,ncols]=size(XX);
        return;
    end

    param=param+p*alphamax/NR_steps;
end

% INITIALIZE NRS
% 2) Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near 0
% and v0

[nrows,ncols]=size(XX);
x=XX(:,ncols);alpha=AA(1,ncols);

param=param0+p*alpha;

[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);

A=J(2:n+1,1:n);lambda=0;

rand('seed',100);
v=rand(n,1);v=v/norm(v);
for j=1:6,
    y=(A-lambda*eye(size(A)))\v;
    lambda=lambda+norm(v)^2/(v'*y);
    v=y/norm(y);
end

%lambda
%v
%(A-lambda*eye(size(A)))*v
%eig(A)
% 3) Locate Point of Collapse


deltalambda=-lambda/NRS_Steps;
for k=1:(NRS_Steps+(0.51)*NRS_Steps)	%51   
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle,
            x0=x;alpha0=alpha;v0=v;
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
            JJ=[J(2:n+1,1:n)      zeros(n,n)                  -p
                J(2:n+1,n+1:2*n)  J(2:n+1,1:n)-lambda*eye(n)  zeros(n,1)
                zeros(1,n)        v'/norm(v)                  0
               ];
            ff=[f(2:n+1)
                (J(2:n+1,1:n)-lambda*eye(n))*v
                norm(v)-1
               ];
 
            delta=-sparse(JJ)\ff;
            x=x0+delta(1:n);
            v=v0+delta(n+1:2*n);
            alpha=alpha0+delta(2*n+1);
            param=param0+p*alpha;
        end
        
        AbsError=max([abs(x-x0);abs(v-v0);abs(alpha-alpha0)]);
        if (x0==0)&(v0==0)&(alpha0==0)
            RelError='NA';
        else
            RelError=AbsError/max([abs(x0);abs(v0);abs(alpha0)]);
        end

        % set state
        % VST_LFSetState;
        % VST_LFSetParam;

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
                vpoc=v;
                wpoc=-null(J(2:n+1,1:n)');
            end
            break;
        end
    end

    if ConvergenceFlag==0
        'NRS Failed to Converge'
        break;
    end

    if alpha>=alphamax
        return;
    end

    XX=[XX x];AA=[AA alpha];
    PP=[PP param];
    lambda=lambda+deltalambda;
   
    Ksys=J(2:no_gen,1:no_gen-1)-J(2:no_gen,no_gen:n)...
        *(J(no_gen+1:n+1,no_gen:n)\J(no_gen+1:n+1,1:no_gen-1));
    Asys=[zeros(size(diag(gen_inertia(2:no_gen)))) ...
        diag(gen_inertia(2:no_gen))
        -Ksys, -diag(gen_damp(2:no_gen))/diag(gen_inertia(2:no_gen))];

    dd=eig(Asys);
    imag_dd=[imag_dd imag(dd)];
    real_dd=[real_dd real(dd)];

	[r_maxdd,s]=max(real(dd));
   crt_dd=[crt_dd,dd(s)];
   chleigv=[chleigv dd];
  

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
    
end






                  
    