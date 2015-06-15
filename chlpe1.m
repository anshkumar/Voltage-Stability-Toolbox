
% The name of the M-file:chlpe1.m
% It plots the location of eigenvalues at each load point
% **********************************************************

figure('NumberTitle','off','Name','Voltage Stability Toolbox- Loci of Eigenvalues',...
   'Color',[0.7 0.8 0.9]);
saf1=real(chleigv(:,1));
saf2=imag(chleigv(:,1));
saf=plot(saf1,saf2,'rx','EraseMode','none');
grid;

for i=2:3
   saf1=real(chleigv(:,i))
   saf2=imag(chleigv(:,i))
   set(saf,'XData',saf1,'YData',saf2);
   drawnow
  
end
axis([-20 20 -15 15])
title(['Eigenvalue Location: ',CurrentSystem]);
xlabel('Real');
ylabel('Imaginary');


