function drawvase
%MAKEVASE Generate and plot a surface of revolut

%axis off

%set(gca,'Position',[0.25 0.22 0.5 0.5]);
%colormap(fliplr(pink));

%xylist=[0.5 0.5 0;0.5 0.5 0.0;...
 %      0.3 0.3 0;0.7 0.3 0.0;...
  %      0.2 0.1 0;0.8 0.1 0.0;...
   %     0.9 0.0 0;];

%x=xylist(:,1)';  
%y=xylist(:,2)';    
%n=24;
%t=(0:n)'*2*pi/n;
%surfl(cos(t)*x,sin(t)*x,ones(n+1,1)*y);
%axis off; 
[x,y]=meshgrid(-8:.5:8);
R=sqrt(x.^2+y.^2)+eps;
Z=sin(R)./R;
mesh(Z);
