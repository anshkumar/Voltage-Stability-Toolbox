% the script IMPTIEEE locates and opens a file containing power
% system data in IEEE Common Data Format. This data is converted to
% standard VST format and named, located and saved in accordance with
% user instructions.

%
[filename, pathname] = uigetfile('IEEE*.dat', 'Please Select Data File');
if filename~=0,
fid=fopen([pathname,filename],'r');
if ~isempty(findstr(filename,'IEEE')),
        dum=fgetl(fid);
        l_vec=sscanf(dum,'%c',73);
        BaseMVA=sscanf(l_vec(32:37),'%f');
        dum=fgetl(fid);
        l_str=fgetl(fid);
        end_of_sec=sscanf(l_str,'%c',1);
        count=1;
        bus_name='';    % EDITED BY: Vedanshu
        while end_of_sec(1)~='-',
                l_vec=sscanf(l_str,'%c',132);
                bus_number(count)=sscanf(l_vec(1:4),'%d');
                bus_name=str2mat(bus_name,sscanf(l_vec(6:17),'%c',12));  
                bus_type(count)=sscanf(l_vec(25:26),'%d');
                bus_v(count)=sscanf(l_vec(28:32),'%f');
                bus_angl(count)=sscanf(l_vec(34:39),'%f')*(1.745329e-002);
                bus_temp=sscanf(l_vec(60:67),'%f');
                bus_p(count)=(bus_temp-sscanf(l_vec(41:49),'%f'))/BaseMVA;
                bus_temp=sscanf(l_vec(68:75),'%f');
                bus_q(count)=(bus_temp-sscanf(l_vec(50:59),'%f'))/BaseMVA;
                bus_condc(count)=sscanf(l_vec(107:114),'%f');
                bus_suscp(count)=sscanf(l_vec(115:122),'%f');
                l_str=fgetl(fid);
                end_of_sec=sscanf(l_str,'%c',1);
                count=count+1;
       end;
        
        no_bus=count-1;


        for count=1:no_bus
                bus_name(count,:)=bus_name(count+1,:);
        end;

        dum=fgetl(fid);
        l_str=fgetl(fid);
        end_of_sec=sscanf(l_str,'%c',1);
        count=1;
        while end_of_sec(1)~='-',
                l_vec=sscanf(l_str,'%c',132);
                tap_bus(count)=sscanf(l_vec(1:4),'%d');
                z_bus(count)=sscanf(l_vec(6:9),'%d');
                trans_type(count)=sscanf(l_vec(19),'%d');
                if (trans_type(count)~=0)&(trans_type~=1),
                        disp('ERROR! Type3 and Type4 transformer are not implemented');
                        quit;
                end;
                brch_r(count)=sscanf(l_vec(20:29),'%f');
                brch_x(count)=sscanf(l_vec(30:40),'%f');
                cnrl_bus_nmbr(count)=sscanf(l_vec(69:72),'%d');
                min_tp_shft(count)=sscanf(l_vec(91:97),'%f');
                max_tp_shft(count)=sscanf(l_vec(98:104),'%f');
                step_size(count)=sscanf(l_vec(106:111),'%f       ');
                
                l_str=fgetl(fid);
                end_of_sec=sscanf(l_str,'%c',1);
                count=count+1;
        end;
        no_lines=count-1;
        fclose(fid);                    %end of reading this data file
        
% Identify hiden PQ buses
        for count=1:no_bus
                if (bus_type(count)==0)&((bus_p(count)~=0)|(bus_q(count)~=0))
                        bus_type(count)=1;
                end;
        end;

% Handle parallel lines

                
% Re-order all buses     by using straight selection sorting method
        jj=0; 
        for ii=1:no_bus
           if (bus_type(ii)==3)
              jj=jj+1;
              temp_type(jj)=3;
              temp_number(jj)=bus_number(ii);
              temp_name(jj:jj,1:12)=bus_name(ii:ii,1:12);
              temp_p(jj)=bus_p(ii);
              temp_q(jj)=bus_q(ii);
              temp_condc(jj)=bus_condc(ii);
              temp_suscp(jj)=bus_suscp(ii);
              temp_v(jj)=bus_v(ii);
              temp_angl(jj)=bus_angl(ii);
           end
        end
        for ii=1:no_bus
           if (bus_type(ii)==2)
              jj=jj+1;
              temp_type(jj)=2;
              temp_number(jj)=bus_number(ii);
              temp_name(jj:jj,1:12)=bus_name(ii:ii,1:12);
              temp_p(jj)=bus_p(ii);
              temp_q(jj)=bus_q(ii);
              temp_condc(jj)=bus_condc(ii);
              temp_suscp(jj)=bus_suscp(ii);
              temp_v(jj)=bus_v(ii);
              temp_angl(jj)=bus_angl(ii);
           end
        end
        for ii=1:no_bus
           if (bus_type(ii)~=3 & bus_type(ii)~=2)
              jj=jj+1;
              temp_type(jj)=1;
              temp_number(jj)=bus_number(ii);
              temp_name(jj:jj,1:12)=bus_name(ii:ii,1:12);
              temp_p(jj)=bus_p(ii);
              temp_q(jj)=bus_q(ii);
              temp_condc(jj)=bus_condc(ii);
              temp_suscp(jj)=bus_suscp(ii);
              temp_v(jj)=bus_v(ii);
              temp_angl(jj)=bus_angl(ii);
           end
        end


        for ii=1:no_bus
              bus_type(ii)=temp_type(ii);
              bus_number(ii)=temp_number(ii);
              bus_name(ii:ii,1:12)=temp_name(ii:ii,1:12);
              bus_p(ii)=temp_p(ii);
              bus_q(ii)=temp_q(ii);
              bus_condc(ii)=temp_condc(ii);
              bus_suscp(ii)=temp_suscp(ii);
              bus_v(ii)=temp_v(ii);
              bus_angl(ii)=temp_angl(ii);
        end


        cmp=[(1:no_bus)' bus_number(1:no_bus)'];

%Mapping the new bus number to branch data      
        for ii=1:no_lines
                jj=1;
                while tap_bus(ii)~=cmp(jj,2),
                        jj=jj+1;
                end;
                tap_bus(ii)=cmp(jj,1);
        end;

        for ii=1:no_lines
                jj=1;
                while z_bus(ii)~=cmp(jj,2),
                        jj=jj+1;
                end;
                z_bus(ii)=cmp(jj,1);
        end;
end; %end of IEEE case

%Store rearranged data in file
bus_data=[cmp';double(bus_name(1:no_bus,1:12)');bus_type(1:no_bus);bus_p;bus_q;bus_condc;bus_suscp;bus_v;bus_angl];
branch_data=[tap_bus;z_bus;trans_type;brch_r;brch_x;cnrl_bus_nmbr;min_tp_shft;max_tp_shft;step_size];
[newfile,newpath]=uiputfile('*_VST.dat','Save Pre-processed Data As');
newfid=fopen([newpath,newfile],'w');
fprintf(newfid,'%4d\r\n',no_bus);
%fprintf(newfid,'%c%c%c%c%c%c%c%c%c%c%c%c\r\n',bus_name(1:no_bus,1:12)');
fprintf(newfid,'%5d %5d %c%c%c%c%c%c%c%c%c%c%c%c %1d %9.4f %9.4f %8.4f %8.4f %8.4f %8.4f\r\n',bus_data);
fprintf(newfid,'%s\r\n','-999');
fprintf(newfid,'%4d\r\n',no_lines);
fprintf(newfid,'%5d %5d %d %10.6f %10.6f %5d %7.4f %7.4f %6.4f\r\n',branch_data);
fprintf(newfid,'%s\r\n','-999');
fclose(newfid);

end;
