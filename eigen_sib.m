% The name of the M-file is:eigen_sib.m
% This M-file creates a figure window and plots the absolute value of magnitudes of 
% right eigenvectors of the system matrix(Asys) and Jacobian matrix of the algebraic 
% equation, Dyg.
% Note that the DAE model is given as : xdot=f(x,y,p) and 0=g(x,y,p)
%At the singularity-induced bifurcation point, the matrix Asys has an unbounded eigenvalue 
%theoretically (a large eigenvalue practically) and Dyg has an unique eigenvalue at the origin 
% (or very small real eigenvalue close to zero, practically)
% for Asys, we look for the right eigenvector corresponding to the largest eigenvalue of Asys.
%For Dyg, we look for the right eigenvector corresponding the the smallest eiegenvalue of Dyg

sen_sib=figure('NumberTitle','off',...
   'Name','VST-Sensitivity Information Around Singularity-Induced Bifurcation',...
   'DefaultAxesPosition',[0.12 0.1 0.55 0.8],...
   'Color',[0.7 0.8 0.9],...
   'ReSize','off');

%Plot the right eigenvector
subplot(2,1,1);
stem(abs(sib_v1),'r');
title(['Right eigenvector of Asys and Dyg',CurrentSystem]);
ylabel('Magnitude');
xlabel('State Variables');
grid;

%plot the left eigenvector
subplot(2,1,2);
stem(abs(dyg_v1),'r');
ylabel('Magnitude');
xlabel('State Variables');
grid;
%gcontrol_sib;




   