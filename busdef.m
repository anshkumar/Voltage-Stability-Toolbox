% This script updates GUI data after any one of the 
% following actions:

% Response to Bus edit text

%CurrentBus=round(get(sli_bus,'Value'));
CurrentBus=max([1,round(get(sli_bus,'Value'))]);
NewData=get(BusName,'String');
NewDataLength=size(NewData,2);
if NewDataLength < 12,
	NewData=[NewData blanks(12-NewDataLength)];
	NewDataLength=12;
end
NewData=[NewData(1,1:10) NewData(1,NewDataLength-1:NewDataLength)]; 
bus_name(CurrentBus,:)=NewData;
% set(BusName,'String',bus_name(CurrentBus,:));

NewData=get(BusType,'String');
NewData=str2num(NewData);
if NewData ~= bus_type(CurrentBus),
	 bus_type(CurrentBus)=NewData;
	 reorder;
else
	bus_type(CurrentBus)=NewData;
end

NewData=get(BusP,'String');
NewData=str2num(NewData); 
bus_p(CurrentBus)=NewData;

NewData=get(BusQ,'String');
NewData=str2num(NewData); 
bus_q(CurrentBus)=NewData;

NewData=get(Conductance,'String');
NewData=str2num(NewData); 
bus_condc(CurrentBus)=NewData;

NewData=get(Susceptance,'String');
NewData=str2num(NewData); 
bus_suscp(CurrentBus)=NewData;

bus_data=[new_bus_nmbr;old_bus_nmbr;double(bus_name(1:NumBus,1:12)');bus_type(1:NumBus);bus_p;bus_q;bus_condc;bus_suscp;bus_v;bus_angl];

busdata
