figure(grph_fig);
set(grph_fig,...
    'NumberTitle','off',...
    'Name','VST - Bifurcation Surface ',...
    'DefaultAxesPosition',[0.12 0.1 0.55 0.8]);



subplot(2,1,1);
plot(AA,XX(i_max,:),'r');
title(['Bifurcation Surface:',CurrentSystem]);
ylabel(statename(i_max,:));
xlabel('alpha');
grid;

subplot(2,1,2); 
plot(AA(ncols:length(AA)),XX(i_max,ncols:length(AA)),'r');
ylabel(statename(i_max,:));
xlabel('alpha');
grid;

simul_pt_idx=round((ncols+(length(AA)-ncols)/2));
simul_st_x=XX(:,simul_pt_idx);
simul_st_p=PP(:,simul_pt_idx);
