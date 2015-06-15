var_lst=[];
for i=1:k_var
    var_lst=str2mat(var_lst,['theta(',num2str(i+1),')']);
end

for i=1:k_var
    var_lst=str2mat(var_lst,['Omega(',num2str(i+1),')']);
end

var_lst(1:2*k_var,:)=var_lst(2:2*k_var+1,:);
