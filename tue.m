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
x=XX_sp(:,211)
alpha_sp=0
XX_sp1=[];
reg_index3=[];
all_eig_Dyg1=[];
while x(1)>-(0.331365)
   
    ConvergenceFlag=0;
    for j=1:round(MaxIterations/ReportCycle),
        t0=clock;
        for i=1:ReportCycle,
            x_sub0=x(sub_strt:fn);
            [f,J]=eval([CurrentSystem,'(data,x,[0;param],v)']);
          delta=-J(sub_strt+1:fn+1,sub_strt:fn)\f(sub_strt+1:fn+1);
          x(sub_strt:fn)=x_sub0+delta;
          x(no_gen:(no_gen-1)+no_pv+2*no_pq)=x(sub_strt:fn);			%update y variables
       end
       f;


        AbsError=max(abs(x(sub_strt:fn)-x_sub0));
        %if x_sub0==0
            %RelError='NA';
        %else
            RelError=AbsError/max(abs(x_sub0));
        %end
          
        %set LF control control errors
        %set(AbsErrorDisp,'String',num2str(AbsError));
        %if isstr(RelError)
         %   set(RelErrorDisp,'String',RelError);
        %else
           % set(RelErrorDisp,'String',num2str(RelError));
        %end

        %set(NumIterations,'String',num2str(j*ReportCycle));
        %set(IterationTime,'String',num2str(etime(clock,t0)/ReportCycle))
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
        break;
     end
      

    XX_sp1=[XX_sp1 x];																			%update XX_sp
    %AA_sp=[AA_sp alpha_sp];																%update AA_sp
    %PP_sp=[PP_sp param];																	%update PP_sp
    options.disp=0;
    eig_Dyg=[eig_Dyg eigs(J(sub_strt+1:fn+1,sub_strt:fn),1,'SM',options)];   %store the smallest eigenvalue of Dyg
    %sign_Dyg=[sign_Dyg sign(det(J(sub_strt+1:fn+1,sub_strt:fn)))];
    all_eig_Dyg1=[all_eig_Dyg1 eig(J(sub_strt+1:fn+1,sub_strt:fn))];           %store all eigenvalues of Dyg
    %alpha_sp=alpha_sp+alphamax_sp/(4*NR_steps);
    ee=eig(J(sub_strt+1:fn+1,sub_strt:fn));		%eigenvalues of Dyg
    %============================================
    %indexing each equilibrium point based on the 
    %number of negative eigenvalues of Dyg
    [ind1]=find((imag(ee)==0)&(real(ee)<0));
    [ind2]=find((imag(ee)==0)&(real(ee)>0));
    reg_index3=[reg_index3 length(ind1)];				%determine the index of voltage causal region
    %reg_index2=[reg_index2 length(ind2)];


    
   
    %if alpha_sp>=alphamax_sp
       %[nrows_sp,ncols_sp]=size(XX_sp);
      % break  
    %end
    x(1:mm)=x(1:mm)-0.001;
    x(1);
    x(2);
    x(3);
    %x(1:mm)=-alpha_sp*x_up(1:mm);
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
