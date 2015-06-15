OldFigNumber=watchon;

lfcntrup;

Bif_Data_Flag=0;

alphamax=10;

to_param;
hpfcomp;
from_param;

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
