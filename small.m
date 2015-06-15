[aa,bb]=eig(B);
bbb=diag(bb);
real_eig=[];
index=find(imag(diag(bb))==0);
for ii=1:length(index)
   jj=index(ii)
   real_eig=[real_eig bbb(jj)]
end
lambda_sp=bbb(jj)
v=aa(:,jj)

   
