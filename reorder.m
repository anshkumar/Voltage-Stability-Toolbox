% Re-order all buses by using straight selection sorting method
        jj=0; 
        for ii=1:NumBus
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
        for ii=1:NumBus
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
        for ii=1:NumBus
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

        for ii=1:NumBus
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


	cmp=[(1:NumBus)' new_bus_nmbr(1:NumBus)'];

%Mapping the new bus number to branch data	
	for ii=1:NumBranch
		jj=1;
		while tap_bus(ii)~=cmp(jj,2),
			jj=jj+1;
		end;
		tap_bus(ii)=cmp(jj,1);
	end;

	for ii=1:NumBranch
		jj=1;
		while z_bus(ii)~=cmp(jj,2),
			jj=jj+1;
		end;
		z_bus(ii)=cmp(jj,1);
	end;

% reorder generators
    
    for ii=1:NumGen-1
	  jj=ii;
	  while old_bus_nmbr(ii)~=old_gen_nmbr(jj),
	    jj=jj+1;
      end;
	  if jj~=ii,
	    temp1=old_gen_nmbr(ii);
	    temp2=gen_inertia(ii);
	    temp3=gen_damp(ii);
	    temp4=bus_R(ii);
	    temp5=VRmax(ii);
	    temp6=VRmin(ii);
	    temp7=ExKA(ii);
	    temp8=ExTA(ii);
	    temp9=ExKF(ii);
	    temp10=ExTF(ii);
	    temp11=ExKE(ii);
	    temp12=ExTE(ii);
	    temp13=ExAEX(ii);
	    temp14=ExBEX(ii);
		temp15=gen_branch(ii);
			    
		old_gen_nmbr(ii)=old_gen_nmbr(jj);
	    gen_inertia(ii)=gen_inertia(jj);
	    gen_damp(ii)=gen_damp(jj);
	    bus_R(ii)=bus_R(jj);
	    VRmax(ii)=VRmax(jj);
	    VRmin(ii)=VRmin(jj);
	    ExKA(ii)=ExKA(jj);
	    ExTA(ii)=ExTA(jj);
	    ExKF(ii)=ExKF(jj);
	    ExTF(ii)=ExTF(jj);
	    ExKE(ii)=ExKE(jj);
	    ExTE(ii)=ExTE(jj);
	    ExAEX(ii)=ExAEX(jj);
	    ExBEX(ii)=ExBEX(jj);
		gen_branch(ii)=gen_branch(jj);
		
		old_gen_nmbr(jj)=temp1;
	    gen_inertia(jj)=temp2;
	    gen_damp(jj)=temp3;
	    bus_R(jj)=temp4;
	    VRmax(jj)=temp5;
	    VRmin(jj)=temp6;
	    ExKA(jj)=temp7;
	    ExTA(jj)=temp8;
	    ExKF(jj)=temp9;
	    ExTF(jj)=temp10;
	    ExKE(jj)=temp11;
	    ExTE(jj)=temp12;
	    ExAEX(jj)=temp13;
	    ExBEX(jj)=temp14;
		gen_branch(jj)=temp15;
	  end;
    end;
