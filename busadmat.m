function Y=busadmat(bus_type,...
          bus_condc,bus_suscp,no_bus,...
		  tap_bus,z_bus,brch_r,brch_x,...
		  no_lines)
% Calculate the FULL bus admittance matrix
%	ad_mat=zeros(no_bus);
	ad_mat=sparse(no_bus,no_bus);
	for k=1:no_lines
		r=brch_r(k);
		x=brch_x(k);
		denu=r*r+x*x;
		g=r/denu;
		b=-x/denu;
		ad_mat(tap_bus(k),tap_bus(k))=ad_mat(tap_bus(k),tap_bus(k))+(g+j*b);
		ad_mat(z_bus(k),z_bus(k))=ad_mat(z_bus(k),z_bus(k))+(g+j*b);
		ad_mat(tap_bus(k),z_bus(k))=-(g+j*b);
		ad_mat(z_bus(k),tap_bus(k))=ad_mat(tap_bus(k),z_bus(k));
	end;

%	for k=1:no_bus
%		if bus_type(k)==0 
%			ad_mat(k,k)=ad_mat(k,k)+(bus_condc(k)+j*bus_suscp(k));
%		end;				
%	end;

	Y=ad_mat;
