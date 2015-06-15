% GETDATA	VST_Main_GetData locates and loads a data base.

[new_bus_nmbr,old_bus_nmbr,bus_name,bus_type,bus_p,bus_q,...
    bus_condc,bus_suscp,NumBus,bus_v,bus_angl,...
    tap_bus,z_bus,trans_type,brch_r,brch_x,cnrl_bus_nmbr,...
    min_tp_shft,max_tp_shft,step_size,NumBranch,...
    CurrentFileName,CurrentPath]=getdata1;

if (~isempty(CurrentFileName)  & ~isempty(findstr(CurrentFileName,'VST')))
    bus_data=[new_bus_nmbr;old_bus_nmbr;double(bus_name(1:NumBus,1:12)');...
        bus_type(1:NumBus);bus_p;bus_q;bus_condc;bus_suscp;bus_v;bus_angl];



    branch_data=[tap_bus;z_bus;trans_type;brch_r;brch_x;...
        cnrl_bus_nmbr;min_tp_shft;max_tp_shft;step_size];

    % Default Generator Data
    % Compute NumGen
    NumGen=0;old_gen_nmbr=[];
    for j=1:NumBus
        if (bus_type(j)==3)|(bus_type(j)==2)
            NumGen=NumGen+1;
            old_gen_nmbr=[old_gen_nmbr,old_bus_nmbr];
        end
    end

    gen_inertia=ones(1,NumGen);
    gen_damp=zeros(1,NumGen);
    
    %Added Jan 25 to edit gendamp
    if exist('gen_damp_old')
       gen_damp=gen_damp_old;
    else
       gen_damp_old=zeros(1,NumGen);
    end
    

       
    bus_R=ones(1,NumGen);
    VRmax=[1.2]*ones(1,NumGen);
    VRmin=[.8]*ones(1,NumGen);
    ExKA=ones(1,NumGen);
    ExTA=zeros(1,NumGen);
    ExKF=ones(1,NumGen);
    ExTF=[0]*ones(1,NumGen);
    ExKE=ones(1,NumGen);
    ExTE=[0]*ones(1,NumGen);
    ExAEX=[0]*ones(1,NumGen);
    ExBEX=[0]*ones(1,NumGen);
    gen_branch=ones(1,NumGen);

    gen_data=[old_gen_nmbr,gen_inertia,gen_damp,bus_R,...
        VRmax,VRmin,ExKA,ExTA,ExKF,ExTF,ExKE,ExTE,ExAEX,ExBEX,gen_branch];
    DataFlag=1;
end
