%function [XX,AA,vpoc,ncols]=PCComp(data,x,param,...
%                            p,alphamax,CurrentSystem,...
%                            MaxIterations,ReportCycle,LFAbsTol,LFRelTol)
% Compute Point of Collapse

% specify direction in parameter space
n=length(x);

param0=param;

%vpoc='undetermined';
vpoc=zeros(n,1);
wpoc=zeros(n,1);

XX=[];AA=[];alpha=0;PP=[];
v=zeros(n,1);

% Perform Standard NR
NR_steps=100;   %100
for k=1:NR_steps+1
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle
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
          
        % set LF control control errors
        set(AbsErrorDisp,'String',num2str(AbsError));
        if isstr(RelError)
            set(RelErrorDisp,'String',RelError);
        else
            set(RelErrorDisp,'String',num2str(RelError));
        end

        set(NumIterations,'String',num2str(j*ReportCycle));
        set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle));

        if (AbsError<=LFAbsTol*.001) ...
            & ((~isstr(RelError))&(RelError<=LFRelTol*.01) ...
            | isstr(RelError))
            ConvergenceFlag=1;
            break;
        end
    end

    if ConvergenceFlag==0
        break;
    end

    XX=[XX x];
    AA=[AA alpha];
    PP=[PP param];

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
 

%lambda
%v
%(A-lambda*eye(size(A)))*v
%eig(A)

% 3) Locate Point of Collapse
NRS_Steps=100;   %100
deltalambda=-lambda/NRS_Steps;
for k=1:NRS_Steps+51   %51
   ConvergenceFlag=0;
   for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle,
            x0=x;alpha0=alpha;v0=v;
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
            JJ=[J(2:n+1,1:n)       zeros(n,n)                   -p
                J(2:n+1,n+1:2*n)   J(2:n+1,1:n)-lambda*eye(n)   zeros(n,1)
                zeros(1,n)         v'/norm(v)                   0
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

        if (AbsError<=LFAbsTol*10) ...
            & ((~isstr(RelError)) ...
            & (RelError<=LFRelTol*10) | isstr(RelError))
            ConvergenceFlag=1;

            if k==NRS_Steps+1
                vpoc=v;
                %wpoc=-null(J(2:n+1,1:n)');
                [mp,np]=size(XX)
                LF_jacob=J(2:n+1,1:n);
                det(LF_jacob)
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
end
