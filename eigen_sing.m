% The name of the M-file: eigeb_sing
% This M-file creates a figure window and plots the absolute magnitudes of
%left and right eigenvector of Dyg at singular point
figure(grph_fig);
set(grph_fig,...
   'NumberTitle','off',...
   'Name','VST-Sensitivity Information around a Singular Point',...
   'DefaultAxesPosition',[0.12 0.1 0.55 0.8],...
   'Color',[0.7 0.8 0.9],...
   'ReSize','off');

%Plot the right eigenvector
subplot(2,1,1);
stem(abs(vpoc_sp),'r');
title(['Right and Left Eigenvector of Dyg:',CurrentSystem]);
ylabel('Null Space Vector');
xlabel('State Variables');
grid;

%plot the left eigenvector
subplot(2,1,2);
stem(abs(wpoc_sp),'r');
ylabel('Remedial Action Vector');
xlabel('State Variables');
grid;




   