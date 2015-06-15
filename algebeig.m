%The name of the M-file:algebeig.m
%It provides the plot of the eigenvalues of Jacobian matrix Dyg
% at each parameter value

figure('NumberTitle','off','Name','VST- loci of Eigenvalues of Load-Flow Jacobian Matrix',...
   'Color',[0.7 0.8 0.9]);
plot(real(Dyg_eig),imag(Dyg_eig),'rx');
title(['Eigenvalue Location: ',CurrentSystem]);
xlabel('Real');
ylabel('Imaginary');
grid;

