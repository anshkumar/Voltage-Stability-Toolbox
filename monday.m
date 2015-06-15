x4=neg(1,:);
x5=neg(3,:);
x6=neg(2,:);
voltage2=zeros(length(x4),length(x4));
for i=1:length(x4)
   voltage2(i,:)=x6;
end
figure
mesh(x4,x5,voltage2);
hold on
x1=pos(1,:);
x2=pos(3,:);
x3=pos(2,:);
voltage1=zeros(length(x1),length(x1));
for i=1:length(x1)
   voltage1(i,:)=x3;
end
mesh(x1,x2,voltage1);
hold on

x7=XX_sp1(1,:);
x8=XX_sp1(3,:);
x9=XX_sp1(2,:);
voltage3=zeros(length(x7),length(x7));
for i=1:length(x7)
   voltage3(i,:)=x9;
end
mesh(x7,x8,voltage3)
colorbar




