% Locate Bus by name and update screen

NewData=get(FindBus,'String');
NewDataLength=size(NewData,2);
if NewDataLength < 12,
	NewData=[NewData blanks(12-NewDataLength)];
	NewDataLength=12;
end
FindBusName=[NewData(1,1:10) NewData(1,NewDataLength-1:NewDataLength)];
set(FindBus,'String',FindBusName);
LengthBusName=size(bus_name,1);
NameMatch=0;BusNameIndex=1;
while NameMatch==0 & BusNameIndex<=LengthBusName,
	NameMatch=strcmp(FindBusName,bus_name(BusNameIndex,1:12));
	BusNameIndex=BusNameIndex+1;
end
if NameMatch==1,
	set(sli_bus,'Value',BusNameIndex-1);
	%GUI_BusDataUpdate;
else
	dialog('Style','warning',...
		   'TextString','invalid bus name',...
		   'Name','WARNING','Resize','off');
end
