stab=[];
[m,n]=size(chleigv);

for ii=1:n
   if max(real(chleigv(:,ii)))<=100*eps
      stab=[stab 1];
   else
      stab=[stab 0];
   end
end

[m,n]=find(stab==0);

[nx,ny]=size(n);

k_temp=no_gen+no_pv-1;
for i=1:k_temp
   px(i)=p(i);
end
for i=1:no_pq
   ii=k_temp+i;
   jj=k_temp+1+2*(i-1);
   px(ii)=p(jj);
   px(ii+no_pq)=p(jj+1);
end
for i=1:k_params
   p(i)=px(i);
end
[m1,n1]=find(p~=0)

disp('First unstable point:')
n(1,1)
PP(m1(1,1),n(1,1))

disp('Last unstable point:')
n(nx,1)
PP(m1(1,1),n(nx,1))
