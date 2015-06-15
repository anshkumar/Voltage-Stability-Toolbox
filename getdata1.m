function [new_bus_nmbr,old_bus_nmbr,bus_name,bus_type,bus_p,bus_q,...
    bus_condc,bus_suscp,no_bus,bus_v,bus_angl,...
    tap_bus,z_bus,trans_type,brch_r,brch_x,cnrl_bus_nmbr,...
    min_tp_shft,max_tp_shft,step_size,no_lines,...
    filename,pathname]=getdata1
% GETDATA1	Read system VST-format dat file (*_VST.dat)
%

[filename, pathname] = uigetfile('*_VST.dat',...
    'Please Select Data File');

if (filename~=0 & ~isempty(findstr(filename,'VST')))
    fid=fopen([pathname,filename],'r');

    %read bus data section
    l_str=fgetl(fid);
    l_vec=sscanf(l_str,'%c',4);
    no_bus=sscanf(l_vec(1:4),'%d');
    l_str=fgetl(fid);
    end_of_sec=sscanf(l_str,'%c',1);
    count=1;
    while end_of_sec(1)~='-'
        l_vec=sscanf(l_str,'%c',82);
        new_bus_nmbr(count)=sscanf(l_vec(1:5),'%d');
        old_bus_nmbr(count)=sscanf(l_vec(7:11),'%d');
        bus_name(count,:)=sscanf(l_vec(13:24),'%c',12);
        bus_type(count)=sscanf(l_vec(26:26),'%d');
        bus_p(count)=sscanf(l_vec(28:36),'%f');
        bus_q(count)=sscanf(l_vec(38:46),'%f');
        bus_condc(count)=sscanf(l_vec(48:55),'%f');
        bus_suscp(count)=sscanf(l_vec(57:64),'%f');
        bus_v(count)=sscanf(l_vec(66:73),'%f');
        bus_angl(count)=sscanf(l_vec(75:82),'%f');

        l_str=fgetl(fid);
        end_of_sec=sscanf(l_str,'%c',1);
        count=count+1;
    end

    %read branch data section        
    l_str=fgetl(fid);
    l_vec=sscanf(l_str,'%c',4);
    no_lines=sscanf(l_vec(1:4),'%d');
    l_str=fgetl(fid);
    end_of_sec=sscanf(l_str,'%c',1);
    count=1;
    while end_of_sec(1)~='-'
        l_vec=sscanf(l_str,'%c',68);
        tap_bus(count)=sscanf(l_vec(1:5),'%d');
        z_bus(count)=sscanf(l_vec(7:11),'%d');
        trans_type(count)=sscanf(l_vec(13),'%d');
        brch_r(count)=sscanf(l_vec(15:24),'%f');
        brch_x(count)=sscanf(l_vec(26:35),'%f');
        cnrl_bus_nmbr(count)=sscanf(l_vec(37:41),'%d');
        min_tp_shft(count)=sscanf(l_vec(43:49),'%f');
        max_tp_shft(count)=sscanf(l_vec(51:57),'%f');
        step_size(count)=sscanf(l_vec(59:64),'%f');
                
        l_str=fgetl(fid);
        end_of_sec=sscanf(l_str,'%c',1);
        count=count+1;
    end

    fclose(fid);
end
