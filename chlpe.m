
% The name of the M-file:chlpe.m
% It plots the location of eigenvalues at each load point
% **********************************************************

figure('NumberTitle','off','Name','VST- Loci of Eigenvalues of System Matrix',...
   'Color',[0.7 0.8 0.9]);
plot(real(sys_eig),imag(sys_eig),'bx');
title(['Eigenvalue Location: ',CurrentSystem]);

xlabel('Real');
ylabel('Imaginary');
title(['Eigenvalue Location: ',CurrentSystem]);

grid;
