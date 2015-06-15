% The name of the M-files is spcomp.m.
% it computes the singular points that satisfies the g(x,y,p) algebraic
%equation between the upper and lower part solutions at given parameter value.
% we change only the dynamic variables(generator angles)
% ***************************************************************************************

% specify direction in parameter space
% *************************************************
n=length(x);
sub_strt=no_gen;
%Real and reactive power injections
% *****************************************************
fn=length(x);
param0=param;
x_low=XX(:,248);		% lower solution at a given parameter value

% Define emty vectors for rigth and left eingenvectors at singular  point
% **********************************************************************
vpoc_sp=zeros(n,1);		%rigth eigenvector(empty)
wpoc_sp=zeros(n,1);		%left eigenvector (empty)

XX_sp=[];
AA_sp=[];
alpha_sp=0;
PP_sp=[];		% store data at each iteration
v=zeros(n,1);										% empty right eigenvector
x_sub0=x(sub_strt:fn);							% initial condition

% Perform Standard NR
% This NR algorithm searches for algebraic variables at a given dynamic variables and parameter
%it updates y's
x;
for k=1:NR_steps+1
   
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle,
            x_sub0=x(sub_strt:fn);
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
				delta=-J(sub_strt+1:fn+1,sub_strt:fn)\f(sub_strt+1:fn+1);          
            x(sub_strt:fn)=x_sub0+delta;
            x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);
            
	%==================================================================
   %check whether deltaF is zero or not
   if (k==35)&(j==1)&(i==ReportCycle)
      f;
      x;
     end
	%=====================================================================
	end

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

        if (AbsError<=LFAbsTol*0.001) ...
            & ((~isstr(RelError)) ...
            & (RelError<=LFRelTol*0.01) ...
            | isstr(RelError))
            ConvergenceFlag=1;
            break;
        end
     end
          
     x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);

     check1=sign(det(J(sub_strt+1:fn+1,sub_strt:fn)));
     check2=f(sub_strt+1:fn+1);
     
    if ConvergenceFlag==0
        break;
    end

    XX_sp=[XX_sp x];
    AA_sp=[AA_sp alpha_sp];
    PP_sp=[PP_sp param];
    alpha_sp=alpha_sp+alphamax_sp/(9*NR_steps);
    
    if alpha_sp>=alphamax_sp
        [nrows_sp,ncols_sp]=size(XX_sp);
        return;
     end
     
    %use weighted average to change the dynamic variables
    %x(1:no_gen-1)=(1-alpha_sp)*x(1:no_gen-1)+alpha_sp*x_low(1:no_gen-1);
    
	%use the search direction to change the dynamic variables
	x=x+a*alphamax_sp/(9*NR_steps);
end

