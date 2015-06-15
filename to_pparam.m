% TO_PPARAM

k_temp=no_gen+no_pv-1;
clear statex ax

for i=1:k_temp
   statex(i)=x(i);
   ax(i)=a(i);
end

for i=1:no_pq
   ii=k_temp+i;
   jj=k_temp+1+2*(i-1);
   statex(ii)=x(jj);
   statex(ii+no_pq)=x(jj+1);
   ax(ii)=a(jj);
   ax(ii+no_pq)=a(jj+1);
end

x=statex'
a=ax'
