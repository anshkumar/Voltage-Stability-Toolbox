
simul_i=max([1,round(get(sli_var,'Value'))]);

position=get(0,'DefaultFigurePosition');
position=position-[120 120 0 0];

simul_fig=figure(...
    'NumberTitle','off',...
    'Name','Voltage Stability Toolbox - Dynamic Simulation Graph',...
    'Position',position,...
    'Color',[0.7 0.8 0.9],...
    'Resize','off');
 %uicontrol(simul_fig,...
  %      'Style','pushbutton',...
   %     'BackgroundColor','g',...
    %    'Position',[510,300,55,30],...
     %   'HorizontalAlignment','Center',...
      %  'String','zoom_on',...
       % 'CallBack','zoomin');

set(simul_fig,'defaulttextcolor','black');
set(simul_fig,'defaultaxesxcolor','black');
set(simul_fig,'defaultaxesycolor','black');
set(simul_fig,'defaultaxeszcolor','black');
set(simul_fig,'defaultsurfaceedgecolor','black');

plot(t_sm,x_sm(:,simul_i),'r');
if simul_i<=k_var
    ylabel(['theta(',num2str(simul_i+1),')']);
else
    ylabel(['Omega(',num2str(simul_i+1-k_var),')']);
end

xlabel('Time');
title(['Time Domain Simulation:',CurrentSystem]);
grid;

