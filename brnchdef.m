% This script updates GUI data after any one of the 
% following actions:

% Response to Branch edit text

CurrentBranch=max([1,round(get(sli_branch,'Value'))]);

NewData=get(BranchTapBus,'String');
NewData=str2num(NewData);
tap_bus(CurrentBranch)=NewData;

NewData=get(BranchZBus,'String');
NewData=str2num(NewData); 
z_bus(CurrentBranch)=NewData;

NewData=get(BranchType,'String');
NewData=str2num(NewData); 
trans_type(CurrentBranch)=NewData;

NewData=get(BranchResistance,'String');
NewData=str2num(NewData); 
brch_r(CurrentBranch)=NewData;

NewData=get(BranchReactance,'String');
NewData=str2num(NewData); 
brch_x(CurrentBranch)=NewData;

NewData=get(ControlledBus,'String');
NewData=str2num(NewData); 
cnrl_bus_nmbr(CurrentBranch)=NewData;

NewData=get(MinimumTap,'String');
NewData=str2num(NewData); 
min_tp_shft(CurrentBranch)=NewData;

NewData=get(MaximumTap,'String');
NewData=str2num(NewData); 
max_tp_shft(CurrentBranch)=NewData;

NewData=get(TapStep,'String');
NewData=str2num(NewData); 
step_size(CurrentBranch)=NewData;

branch_data=[tap_bus;z_bus;trans_type;brch_r;brch_x;cnrl_bus_nmbr;min_tp_shft;max_tp_shft;step_size];


brnchdat;
