% FROM_PARAM
param;
p;
k_temp=no_gen+no_pv-1;
clear paramx px PPx;

for i=1:k_temp
   paramx(i)=param(i);
   px(i)=p(i);
   PPx(i,:)=PP(i,:);
 
end

for i=1:no_pq
   ii=k_temp+i;
   jj=k_temp+1+2*(i-1);
   paramx(jj)=param(ii);
   paramx(jj+1)=param(ii+no_pq);
   px(jj)=p(ii);
   px(jj+1)=p(ii+no_pq);
   PPx(jj,:)=PP(ii,:);
   PPx(jj+1,:)=PP(ii+no_pq,:); 
   
   
end
px;
param=paramx;
param;
p=px;
p;
PP=PPx;
PP_nose=PP(:,1:np);
XX_nose=XX(:,1:np);
