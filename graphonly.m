
% The name of the M-file:graphonly.m
% It plots the bofurcation surface of either static or dynamic bifurcation.
% It gets rid of the slider in the bifurcation surfce window
% and provides the bifurcation surface of the desired state.
%*************************************************************************


%if exist('graph_only')
 %   figure(graph_only);

%    position=get(0,'DefaultFigurePosition');
 %   position=position-[170,170,0,0];

%    set(graph_only,'Position',position);
%else
 %   position=get(0,'DefaultFigurePosition');
  %  position=position-[170,170,0,0];

  %graph_only
  
  figure('NumberTitle','off',...
        'Name','Voltage Stability Toolbox- Bifurcation Surface ',...
        'Position',position,...
        'Color',[0.7 0.8 0.9]);
%end
stableindex=find(Stab==1);
asystableindex=find(Stab==2);
oscunstableindex=find(Stab==3);
asyunstableindex=find(Stab==4);

%subplot(2,1,1);
plot(AA(:),XX(i_max,:),'g',AA(oscunstableindex),...
   XX(i_max,oscunstableindex),'ro',...
    AA(asyunstableindex), XX(i_max,asyunstableindex),'ro');

%plot(AA,XX(i_max,:),'r');
title(['Bifurcation Surface:',CurrentSystem]);
ylabel(statename(i_max,:));
xlabel('alpha');
grid;

stableind=stableindex(find(stableindex>=ncols));
oscunstableind=oscunstableindex(find(oscunstableindex>=ncols));
asyunstableind=asyunstableindex(find(asyunstableindex>=ncols));

%subplot(2,1,2);
%plot(AA(ncols:length(AA)),XX(i_max,ncols:length(AA)),...
   % 'g',AA(oscunstableind),XX(i_max,oscunstableind),'ro',...
    %AA(asyunstableind),XX(i_max,asyunstableind),'ro');

%plot(AA(ncols:length(AA)),XX(i_max,ncols:length(AA)),'r');
%ylabel(statename(i_max,:));
%title(['Zoomed Bifurcation Surface: ',CurrentSystem]);
%xlabel('alpha');
%grid;

simul_pt_idx=round((ncols+(length(AA)-ncols)/2));
simul_st_x=XX(:,simul_pt_idx);
simul_st_p=PP(:,simul_pt_idx);
