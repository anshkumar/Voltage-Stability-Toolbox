OldFigNumber=watchon;
% update the load flow control parameters
lfcntrup;	%update the LF control parameters

Bif_Data_Flag=0;

alphamax=10;
param;

to_param;	%order the parameters in the order of [P1,P2,....Pn,Q1,Q2,....Qn]
t_start=cputime;
lhpfcomp;
PP_new=PP;
t_final=cputime-t_start;
from_param; % order the parameter injections in the same order before lhpfcomp....
param;

watchoff;

[vpocmax,i_max]=max(abs(vpoc));

position=get(0,'DefaultFigurePosition');
position=position-[120 120 0 0];

grph_fig=figure(...
    'NumberTitle','off',...
    'Name','Bifurcation Surface ',...
    'Position',position,...
    'Color',[0.7 0.8 0.9]);

set(grph_fig,'defaulttextcolor','black');
set(grph_fig,'defaultaxesxcolor','black');
set(grph_fig,'defaultaxesycolor','black');
set(grph_fig,'defaultaxeszcolor','black');
set(grph_fig,'defaultsurfaceedgecolor','black');

hpfplot;

if Bif_Data_Flag==0
    gcontrol;
    uicontrol(static_fig,...
        'Style','pushbutton',...
         'BackgroundColor','R',...
         'Position',[405,75,125,20],...
         'HorizontalAlignment','Center',...
         'String','Replot',...
         'Callback','hpfplot');
end

set(Null_Space_HANDLES(3),'String',abs(vpoc));

set(RemedialAction_HANDLES(3),'String',wpoc);

