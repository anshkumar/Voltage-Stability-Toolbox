% updates load flow control parameters

LFAbsTol=str2num(get(AbsTolControl,'String'));
LFRelTol=str2num(get(RelTolControl,'String'));
ReportCycle=str2num(get(ReportControl,'String'));
MaxIterations=str2num(get(MaxIterationControl,'String'));
NR_steps=str2num(get(NR_stepControl,'String'));
NRS_Steps=str2num(get(NRS_stepControl,'String'));
