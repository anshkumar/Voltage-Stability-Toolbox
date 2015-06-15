function putdata(no_bus,bus_data,no_lines,branch_data)
    
% Store edited data in file
% bus_data=[new_bus_nmbr;old_bus_nmbr;bus_name(1:no_bus,1:12)';bus_type(1:no_bus);bus_p;bus_q;bus_condc;bus_suscp];
% branch_data=[tap_bus;z_bus;trans_type;brch_r;brch_x;cnrl_bus_nmbr;min_tp_shft;max_tp_shft;step_size];
[newfile,newpath]=uiputfile('_VST.dat','Save Pre-processed Data As');

if newfile~=0
	newfid=fopen([newpath,newfile],'wt');
	fprintf(newfid,'%4d\n',no_bus);
	fprintf(newfid,'%5d %5d %c%c%c%c%c%c%c%c%c%c%c%c %1d %9.4f %9.4f %8.4f %8.4f\n',bus_data);
	fprintf(newfid,'%s\n','-999');
	fprintf(newfid,'%4d\n',no_lines);
	fprintf(newfid,'%5d %5d %d %10.4f %10.4f %5d %7.4f %7.4f %6.4f\n',branch_data);
	fprintf(newfid,'%s\n','-999');
	fclose(newfid);
end;
