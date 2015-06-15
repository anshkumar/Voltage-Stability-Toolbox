display_length=min(k_states,5);

for i=1:display_length
    param(max(CurrentParam-5,0)+i)=str2num(get(ParamValue(i),'String'));
end

simul_st_p=param;
