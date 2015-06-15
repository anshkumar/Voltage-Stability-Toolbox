% TO_PARAM
% Order parameters in the following manner; param=[p1....pn,q1,...qn]
% Order search direction in the same order as the parameter vector has

load c:\derek1 no_gen; % no of gen buses
load c:\derek3 no_pv; % no of PV buses
load c:\derek4 PP_test; % PQ injections
load c:\derek5 XX; % states
load c:\derek6 no_pq; % no of PQ buses
load c:\derek AA; % the parameter alpha

clear PPx;
PP=PP_test';
a=(no_gen+no_pv+no_pq-1);
PPr=[ones(length(PP),1) abs(PP(:,1:a))];% this assumes that the slack is position1 and the value of P1 is 1


clear XXnew;
XX=XX';
k_temp=no_gen+no_pv-1;

[x,y]=size(XX);

for i=1:k_temp
   XXnew(1:x,i)=XX(1:x,i); % this selects all the deltas of the PV and gen buses
end

for i=1:no_pq
   t=k_temp+i;
   XXnew(1:x,t)=XX(1:x,k_temp+2*i); % this selects all the deltas of the PQ and places the after the deltas of the PV buses
end

for i=1:no_pq
   ii=2*i-1;
   s=t+i;
   XXnew(1:x,s)=XX(1:x,k_temp+ii); % this selects all the Vs and placesthem after the deltas
end

XXnew;

z=no_gen+no_pv+no_pq-1;
angle=[zeros(length(XXnew),1) XXnew(:,1:z)]; % angles with slack in position 1
voltage=[ones(length(XXnew),1+no_pq) XXnew(:,z+1:z+no_pq)]; % voltages with slack in position 1

% Energy difference between the operating ponit and the PoC of voltage
%---------------------------------------------------------------------
figure(101)
hold on
clear Ediff;
[alphamax,PoC]=max(AA);%gets the point of collapse
E(PoC)=energy(PoC,no_pv,no_gen,no_pq,PPr(PoC,:),angle(PoC,:),voltage(PoC,:));%energy at poni of collapse

for i=1:PoC,
   Ediff(i)=energy(i,no_pv,no_gen,no_pq,PPr(i,:),angle(i,:),voltage(i,:))-E(PoC);%energy difference
end
plot(AA(1:PoC),Ediff,'g.');

%Energy difference between the upper voltage solution and lower voltage solution at each operating point
%--------------------------------------------------------------------------------------------------------
figure(100)
clear Ediff1;
tol=0.001; % definition of tolerance

k=1;
for i=1:PoC,
   for j=PoC:length(AA),
      diff(j)=abs(AA(i)-AA(j));
   end
   [w,v]=min(diff(PoC:length(AA)));v=v+PoC-1;
   if w<=tol
      Ediff1(i)=energy(i,no_pv,no_gen,no_pq,PPr(i,:),angle(i,:),voltage(i,:))-energy(v,no_pv,no_gen,no_pq,PPr(v,:),angle(v,:),voltage(v,:));
      plot(AA(v),Ediff1(i),'r.--');
      hold on
   else 
      ;% do nothing!
   end
end



      




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[x,y]=size(PP);% y is the no of states .i.e n and the x is the no of iterations .i.e the length of PP_test

%for i=1:k_temp
   %PPx(1:x,i)=PP(1:x,i);
%end

%for i=1:no_pq
 %  ii=k_temp+i;
  % jj=k_temp+1+2*(i-1);
  % PPx(1:x,ii)=PP(1:x,jj);
  % PPx(1:x,ii+no_pq)=PP(1:x,jj+1);
%end
%PP=PPx;
%PP;

