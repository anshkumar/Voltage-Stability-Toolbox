% This script updates GUI data after any one of the 
% following actions:

% Response to Generator edit text

CurrentGen=max([1,round(get(sli_gen,'Value'))]);

NewData=get(GenInertia,'String');
NewData=str2num(NewData); 
gen_inertia(CurrentGen)=NewData;

NewData=get(GenDamp,'String')
NewData=str2num(NewData) 
gen_damp(CurrentGen)=NewData
gen_damp_old=gen_damp

NewData=get(GenBranch,'String');
NewData=str2num(NewData); 
gen_branch(CurrentGen)=NewData;

NewData=get(ControlBusName,'String');
NewData=str2num(NewData); 
bus_R(CurrentGen)=NewData;

NewData=get(VoltageLimitMax,'String');
NewData=str2num(NewData); 
VRmax(CurrentGen)=NewData;

NewData=get(VoltageLimitMin,'String');
NewData=str2num(NewData); 
VRmin(CurrentGen)=NewData;

NewData=get(ExcitorCompKA,'String');
NewData=str2num(NewData); 
ExKA(CurrentGen)=NewData;

NewData=get(ExcitorCompTA,'String');
NewData=str2num(NewData); 
ExTA(CurrentGen)=NewData;

NewData=get(ExcitorStabKF,'String');
NewData=str2num(NewData); 
ExKF(CurrentGen)=NewData;

NewData=get(ExcitorStabTF,'String');
NewData=str2num(NewData); 
ExTF(CurrentGen)=NewData;

NewData=get(ExcitorDymKE,'String');
NewData=str2num(NewData); 
ExKE(CurrentGen)=NewData;

NewData=get(ExcitorDymTE,'String');
NewData=str2num(NewData); 
ExTE(CurrentGen)=NewData;

NewData=get(ExcitorSatAEX,'String');
NewData=str2num(NewData); 
ExAEX(CurrentGen)=NewData;

NewData=get(ExcitorSatBEX,'String');
NewData=str2num(NewData); 
ExBEX(CurrentGen)=NewData;

gendata;
