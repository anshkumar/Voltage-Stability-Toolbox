
% This script updates GUI data after any one of the 
% following actions:

% New bus selection
NewBusNo=max([1,round(get(sli_bus,'Value'))]); 
set(bus_cur,'String',num2str(NewBusNo));
set(BusName,'String',bus_name(NewBusNo,:));
set(BusType,'String',num2str(bus_type(NewBusNo)));
set(BusP,'String',num2str(bus_p(NewBusNo)));
set(BusQ,'String',num2str(bus_q(NewBusNo)));
set(Conductance,'String',num2str(bus_condc(NewBusNo)));
set(Susceptance,'String',num2str(bus_suscp(NewBusNo)));
