function str2=addbar(str1)
[m,n]=size(str1);
if m == 0
  str2=[];
  return
end
str2=num2str(str1(1,:));
for i=2:m
 str2=[str2,'|' num2str(str1(i,:))];
end    
