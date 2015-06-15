% The name of the M-files is spcomp.m.
% it computes the singular points that satisfies the g(x,y,p) algebraic
%equation between the upper and lower part solutions at given parameter value.
% **************************************************************************************

% specify direction in parameter space
% *************************************************n=length(x);
sub_strt=no_gen;
%Real and reactive power injections
% *****************************************************
fn=length(x);
param0=param;
x_low=XX(:,248);

% Define emty vectors for rigth and left eingenvectors at singular  point
% **********************************************************************
vpoc_sp=zeros(n,1);
wpoc_sp=zeros(n,1);

XX_sp=[];AA_sp=[];alpha_sp=0;PP_sp=[];
v=zeros(n,1);
x_sub0=x(sub_strt+1:fn);
% Perform Standard NR

for k=1:(4)*(NR_steps)+1
   
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle,
            x_sub0=x(sub_strt+1:fn);
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
				delta=-J(fn+1,fn)\f(fn+1);         
            x(sub_strt+1:fn)=x_sub0+delta;
            x(no_gen+1:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt+1:fn);

	end


        AbsError=max(abs(x(sub_strt+1:fn)-x_sub0));
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
     sign(det(J(sub_strt+1:fn+1,sub_strt:fn)));
     k;
     det(J(sub_strt+1:fn+1,sub_strt:fn));
     eig(J(sub_strt+1:fn+1,sub_strt:fn))
     
        if ConvergenceFlag==0
        break;
    end

    XX_sp=[XX_sp x];
    AA_sp=[AA_sp alpha_sp];
    PP_sp=[PP_sp param];

if k<=11
   alpha_sp=alpha_sp+alphamax_sp/(1000*NR_steps);
else
   alpha_sp=alpha_sp+alphamax_sp/(NR_steps);
end


    if alpha_sp>=alphamax_sp
        [nrows_sp,ncols_sp]=size(XX_sp);
        return;
     end
    x(no_gen:sub_strt)=(1-alpha_sp)*x(no_gen:sub_strt)+alpha_sp*x_low(no_gen:sub_strt);
end

% specify direction in parameter space
% *************************************************
%alphasp=0;
%n=length(x);
%sub_strt=no_gen;
% Initial real and reactive power injections
% *****************************************************
%fn=length(x);
%param0=param;
%XXsp=[];AAsp=[];alphasp=0;PPsp=[];
%x_sub0=x(sub_strt:fn);
%x_gen=x(1:no_gen-1);
%x_low=XX(:,248);
%v=zeros(n,1);
%x0=x
% INITIALIZE NRS
% Obtain the smallest eigenvalue of Dy(g(x,y,p)) evaluated at the upper solution
% 1) Starting Values for lambda0 and v0
% inverse iteration to obtain estimates of lambda0 near 0
% and v0

%[f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);

%B=J(sub_strt+1:fn+1,sub_strt:fn);
%lambda=0;
%eig(B);
%rand('state',100)
%v=rand(n,1);v=v/norm(v);
%v;
%for j=1:5,
    %y=(B-lambda*eye(size(B)))\v(sub_strt:fn);
    %lambda=lambda+norm(v(sub_strt:fn))^2/((v(sub_strt:fn))'*y);
    %v(sub_strt:fn)=y/norm(y);
 %end
 %v;
 %lambda
 %norm(v(sub_strt:fn));
 
 
 %2) Locate singular point


%deltalambda=-lambda/(0.1*NRS_Steps);
%for k=1:NRS_Steps+1	  
  %  ConvergenceFlag=0;
   % for j=1:round(MaxIterations/ReportCycle),
    %    t0=clock;
     %   for i=1:ReportCycle,
      %     x_sub0=x(sub_strt:fn);
       %    alphasp0=alphasp;
        %   v0=v(sub_strt:fn);
         %   [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
          %  JJ=[   J(sub_strt+1:fn+1,sub_strt:fn)  zeros(2*no_pq,2*no_pq)                             -J(no_gen+1:n+1,1:no_gen-1)
           %     J(sub_strt+1:fn+1,fn+no_gen:2*fn)  J(sub_strt+1:fn+1,sub_strt:fn)-lambda*eye(2*no_pq)  zeros(2*no_pq,1)
            %    zeros(1,2*no_pq)                   (v(sub_strt:fn))'/norm(v(sub_strt:fn))                      0
             %  ];
            %ff=[f(sub_strt+1:fn+1)
             %   (J(sub_strt+1:fn+1,sub_strt:fn)-lambda*eye(2*no_pq))*v(sub_strt:fn)
              %  norm(v(sub_strt:fn))-1
               %];
                 
            %delta=-sparse(JJ)\ff;
            %x(sub_strt:fn)=x_sub0+delta(1:2*no_pq);
            %x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);
            %v(sub_strt:fn)=v0+delta(2*no_pq+1:4*no_pq);
           	%alphasp=alphasp0+delta(4*no_pq+1)
            
            
           %end
           %lambda
        
        %AbsError=max([abs(x(sub_strt:fn)-x_sub0);abs(v(sub_strt:fn)-v0);abs(alphasp-alphasp0)]);
        %if (x_sub0==0)&(v0==0)
         %   RelError='NA';
        %else
         %   RelError=AbsError/max([abs(x_sub0);abs(v0);abs(alphasp0)]);
        %end

        % set state
        % VST_LFSetState;
        % VST_LFSetParam;

        % set LF control control errors
%        set(AbsErrorDisp,'String',num2str(AbsError));
 %       if isstr(RelError)
  %          set(RelErrorDisp,'String',RelError);
   %     else
    %        set(RelErrorDisp,'String',num2str(RelError));
     %   end

%        set(NumIterations,'String',num2str(j*ReportCycle));
 %       set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle));

%        if (AbsError<=LFAbsTol) ...
 %           & ((~isstr(RelError)) ...
  %          & (RelError<=LFRelTol) ...
   %         | isstr(RelError))
    %        ConvergenceFlag=1;

%            if k==NRS_Steps+1
 %               vpoc_sp=v(sub_strt:fn);
  %              wpoc_sp=-null(J(sub_strt+1:fn+1,sub_strt:fn)');
   %         end
    %        break;
     %   end
    %end

%    if ConvergenceFlag==0
 %       'NRS Failed to Converge'
  %      break;
   % end

%    if alphasp>=alphaspmax
 %       return;
  %  end

%    XXsp=[XXsp x];AAsp=[AAsp alphasp];
 %   PPsp=[PPsp param];
  %  lambda=lambda+deltalambda;
   % x(1:no_gen-1)=(1-alphasp)*x(1:no_gen-1)+alphasp*x_low(1:no_gen-1);

         
% end


