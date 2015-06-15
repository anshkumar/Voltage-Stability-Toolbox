function [Yred,Y_saffet,no_gen,no_pv,no_pq]=eqmodel(bus_type,...
          bus_condc,bus_suscp,no_bus,...
		  tap_bus,z_bus,brch_r,brch_x,...
		  no_lines,C_Flag)
% EqModel assembles classical power system equilibrium equations

%Identify the number of all buses
	no_gen=0;
	no_pv=0;
	no_pq=0;
	no_ca=0;
	for count=1:no_bus
		if (bus_type(count)==3)
			no_gen=no_gen+1;
		end;
% 		if (bus_type(count)==2)
% 			no_gen=no_gen+1;
% 		end;
		if (bus_type(count)==2)
			no_pv=no_pv+1;
		end;
		if (bus_type(count)==1)
			no_pq=no_pq+1;
		end;
		if (bus_type(count)==0)
			no_ca=no_ca+1;
		end;
	end;

% Calculate the FULL admittance matrix
	Ybus=busadmat(bus_type,...
          bus_condc,bus_suscp,no_bus,...
		  tap_bus,z_bus,brch_r,brch_x,...
        no_lines);
     Y_saffet=Ybus; % 07/31/00, Y_bus matrix (non_sparse)
		  
% Calculate the REDUCED admittance matrix
    Yred=redbusad(Ybus,no_ca);
	
% Identify all the zero elements in reduced admitt. matrix
	[zi,zj]=find(Yred==0);
	
% Call mex C routine to build the symbolic model
	
	X=[no_gen no_pv no_pq];
	zn=size(zi);
	
%  Save some memory
	clear Ybus;
%	clear bus_type bus_condc bus_suscp no_bus;
%	clear tap_bus z_bus brch_r brch_x no_lines;
 
%[mb]=model_build(X,zi,zj,zn)

	if C_Flag==1
	  [mb]=model_c(X,zi,zj,zn)
	else
	  [mb]=model_m(X,zi,zj,zn)
	end
	clear mex
