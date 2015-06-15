
% This script updates GUI data after any one of the 
% following actions:

% New branch selection
NewBranchNo=max([1,round(get(sli_branch,'Value'))]); 
set(branch_cur,'String',num2str(NewBranchNo));

set(BranchTapBus,'String',num2str(tap_bus(NewBranchNo)));
set(BranchZBus,'String',num2str(z_bus(NewBranchNo)));
set(BranchType,'String',num2str(trans_type(NewBranchNo)));
set(BranchResistance,'String',num2str(brch_r(NewBranchNo)));
set(BranchReactance,'String',num2str(brch_x(NewBranchNo)));
set(ControlledBus,'String',num2str(cnrl_bus_nmbr(NewBranchNo)));
set(MinimumTap,'String',num2str(min_tp_shft(NewBranchNo)));
set(MaximumTap,'String',num2str(max_tp_shft(NewBranchNo)));
set(TapStep,'String',num2str(step_size(NewBranchNo)));
