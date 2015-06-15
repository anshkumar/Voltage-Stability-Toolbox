
% This script updates GUI data after any one of the 
% following actions:

% New generator selection
NewGenNo=max([1,round(get(sli_gen,'Value'))]); 
set(gen_cur,'String',num2str(NewGenNo));

set(GenInertia,'String',num2str(gen_inertia(NewGenNo)));
set(GenDamp,'String',num2str(gen_damp(NewGenNo)));
set(GenBranch,'String',num2str(gen_branch(NewGenNo)));
set(ControlBusName,'String',num2str(bus_R(NewGenNo)));
set(VoltageLimitMax,'String',num2str(VRmax(NewGenNo)));
set(VoltageLimitMin,'String',num2str(VRmin(NewGenNo)));
set(ExcitorCompKA,'String',num2str(ExKA(NewGenNo)));
set(ExcitorCompTA,'String',num2str(ExTA(NewGenNo)));
set(ExcitorStabKF,'String',num2str(ExKF(NewGenNo)));
set(ExcitorStabTF,'String',num2str(ExTF(NewGenNo)));
set(ExcitorDymKE,'String',num2str(ExKE(NewGenNo)));
set(ExcitorDymTE,'String',num2str(ExTE(NewGenNo)));
set(ExcitorSatAEX,'String',num2str(ExAEX(NewGenNo)));
set(ExcitorSatBEX,'String',num2str(ExBEX(NewGenNo)));

