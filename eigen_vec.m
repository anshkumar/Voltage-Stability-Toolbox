% The name of the M-file: eigeb_vec
% This M-file creates a figure window and plots the absolute magnitudes of
%left and right eigenvector of the load flow Jacobian matrix at the point 
% of collapse.

figure(grph_fig);
set(grph_fig,...
   'NumberTitle','off',...
   'Name','VST-Sensitivity and Remedial Information',...
   'DefaultAxesPosition',[0.12 0.1 0.55 0.8],...
   'Color',[0.7 0.8 0.9],...
   'ReSize','off');

%Plot the right eigenvector
subplot(2,1,1);
stem(abs(vpoc),'r');
title(['Right and Left Eigenvector:',CurrentSystem]);
ylabel('Null Space Vector');
xlabel('State Variables');
grid;

%plot the left eigenvector
subplot(2,1,2);
stem(abs(wpoc),'r');
ylabel('Remedial Action Vector');
xlabel('State Variables');
grid;
gcontrol1;



   