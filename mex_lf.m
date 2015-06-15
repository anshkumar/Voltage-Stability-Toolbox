% MEX_LF is the callback script for Model_Build_Load Flow Model. It
% sets up the file name and location for the C source code for the
% load flow model and then creates it. The source code compiles as
% MATLAB MEX file that has the calling syntax
%              [f,J]=name(data,x,param)
% It also builds a data file for the model that contains (initial) 
% values for data,x,param.

if exist('dlgfig')
    set(dlgfig,'Visible','off');
end

% Make sure data have been loaded
if ~exist('DataFlag'),DataFlag=0;end
if DataFlag==0,getdata;end;
if DataFlag==0,return;end;

% identify target path and file names
[filename,pathname]=uiputfile('*.c','Define model name and location');

if filename~=0,
    CurrentSystem=filename(1:length(filename)-2);
    if findstr(CurrentFileName,CurrentSystem)==[]
        titleStr=[' Inconsistent Names '];
        textStr=['                                              '
                 ' Names of the data file and executable must   '
                 ' be consistent. Do you want to choose another '
                 ' executable now ?                             '
                ];
        dlgfig=mydlg(titleStr,textStr,'mex_lf | rtnnow');
        return;
    end

    watchon;

    % build the maple network model
    C_Flag=0;
    t=clock;
    [Yred,no_gen,no_pv,no_pq]=eqmodel(bus_type,bus_condc,...
         bus_suscp,NumBus,tap_bus,z_bus,brch_r,brch_x,NumBranch,C_Flag);

    'model.src'
    etime(clock,t)

    % create the C code for load flow mex file
    mexfuncname=mex_lf_c(pathname,filename,Yred);

    % create the data file
    % create data
    % b=imag(Yred);g=real(Yred);
    [zrow,zcol,Ys]=find(Yred);

    %data=ones(no_gen+no_pv,1);  % these are default values for voltages
    data=bus_v(1:no_gen+no_pv)';
    data=[data;imag(Ys)];       % add b
    data=[data;real(Ys)];       % add g

    % create x
    x=zeros(no_gen+no_pv-1,1); % default zeros for angles & ones for voltages
    for k=1:no_pq
        x=[x;1;0];
    end

    % create param
     param=zeros(no_gen+no_pv-1+2*no_pq,1);
    % make initial values for param from input data
    ii=no_gen+1;
    last_one='Q';
    k_params=no_gen+no_pv-1+2*no_pq;
    for i=1:k_params
        if i<=no_gen-1
            param(i)=bus_p(i+1);
        end

        if (i>no_gen-1) & (i<=no_gen+no_pv-1)
            param(i)=bus_p(ii);
            ii=ii+1;
        end

        if (i>no_gen+no_pv-1) & (i<=no_gen+no_pv-1+2*no_pq)
            if last_one=='Q'
                param(i)=bus_p(ii);
                last_one='P';
            else 
                param(i)=bus_q(ii);
                last_one='Q';
                ii=ii+1;
            end
        end
    end

    param=param';

    eval(['save ',pathname,mexfuncname,...
        ' data x param no_gen no_pv no_pq gen_inertia gen_damp;'])

    % delete the network model file
    % delete 'model.src'

    watchoff;
end
