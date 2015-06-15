% Store edited VST data in a new file
 %bus_data=[new_bus_nmbr;old_bus_nmbr;bus_name(1:no_bus,1:12)';bus_type(1:no_bus);...
  %         bus_p;bus_q;bus_condc;bus_suscp;bus_v;bus_angl];
 %branch_data=[tap_bus;z_bus;trans_type;brch_r;brch_x;cnrl_bus_nmbr;min_tp_shft;...
   %           max_tp_shft;step_size];

[CurrentFileName,CurrentPath]=uiputfile('*_VST.dat','Save Pre-processed Data As');
%

if CurrentFileName~=0
	savedata(NumBus,bus_data,NumBranch,branch_data,CurrentPath,CurrentFileName)
%
	%set(DataFileName,'String',CurrentFileName);
end
