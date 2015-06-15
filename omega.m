% Compute the rate of change of generator variables wrt paramater alpha_sp
delta_alpha_sp=zeros(1,length(AA_sp)-1);
for kk=2:length(AA_sp)
   delta_alpha_sp(kk-1)=AA_sp(kk)-AA_sp(kk-1);
end

XX_sp_gen=XX_sp(1:no_gen-1,:);
DDAA=[];
for mm=2:length(AA_sp)
   delta_angle=XX_sp_gen(:,mm)-XX_sp_gen(:,mm-1);
   DDAA=[ DDAA delta_angle];
end
veloc=DDAA(1,:)./abs(delta_alpha_sp);
