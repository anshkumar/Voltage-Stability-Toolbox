  figure(grph_fig);

set(grph_fig,...
    'NumberTitle','off',...
    'Name','Voltage Stability Toolbox - Bifurcation Surface ',...
    'DefaultAxesPosition',[0.12 0.1 0.55 0.8]);

stableindex=find(Stab==1);
asystableindex=find(Stab==2);
oscunstableindex=find(Stab==3);
asyunstableindex=find(Stab==4);
subplot(2,1,1);
plot(AA(:),XX(i_max,:),'g',AA(oscunstableindex),...
   XX(i_max,oscunstableindex),'ro',...
    AA(asyunstableindex), XX(i_max,asyunstableindex),'ro');
   
title(['Bifurcation Surface: ',CurrentSystem]);
ylabel(statename(i_max,:));
xlabel('alpha');
grid;


stableind=stableindex(find(stableindex>=ncols));
oscunstableind=oscunstableindex(find(oscunstableindex>=ncols));
asyunstableind=asyunstableindex(find(asyunstableindex>=ncols));
subplot(2,1,2);
plot(AA(ncols:length(AA)),XX(i_max,ncols:length(AA)),...
    'g',AA(oscunstableind),XX(i_max,oscunstableind),'ro',...
    AA(asyunstableind),XX(i_max,asyunstableind),'ro');
 ylabel(statename(i_max,:));
 xlabel('alpha');
 grid;

 simul_pt_idx=round((ncols+(length(AA)-ncols)/2));
simul_st_x=XX(:,simul_pt_idx);
simul_st_p=PP(:,simul_pt_idx);
