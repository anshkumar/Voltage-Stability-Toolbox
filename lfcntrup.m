% updates load flow control parameters

LFAbsTol=str2num(get(AbsTolControl,'String'));
LFRelTol=str2num(get(RelTolControl,'String'));
ReportCycle=str2num(get(ReportControl,'String'));
MaxIterations=str2num(get(MaxIterationControl,'String'));

