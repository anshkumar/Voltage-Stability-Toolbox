% LOADFLOW	Load Flow Calculation Program
% 		LOADFLOW Sets up GUI for load flow analysis.
%

clear ParamSlider;

if exist('dlgfig')
    set(dlgfig,'Visible','off');
end

% Make sure data is loaded.
if ~exist('DataFlag'),DataFlag=0;end
if DataFlag==0,getdata;end
if DataFlag==0,return;end

if (strcmp(computer,'SOL2' ))
  mexwild = '*.mexsol';
  lensub=7;
elseif (strcmp(computer, 'PCWIN'))
   mexwild = '*.mexw32';    % EDITED BY: Vedanshu
    lensub=7;               % EDITED BY: Vedanshu
end

[LFfilename,LFpathname]=uigetfile(mexwild,'Choose system for analysis');

if LFfilename~=0,
    CurrentSystem=LFfilename(1:length(LFfilename)-lensub);
    if isempty(findstr(CurrentFileName,CurrentSystem))
        titleStr=[' Inconsistent Names '];
        textStr=['                                              '
                 ' Names of the data file and executable must   '
                 ' be consistent. Do you want to choose another '
                 ' executable now ?                             '
                ];
        dlgfig=mydlg(titleStr,textStr,'loadflow | rtnnow');
        return;
    end

    % Define a figure window and assign a handle to it.
    position=get(0,'DefaultFigurePosition');
    position=position-[70 70 0 0];

    loadflow_fig=figure(...
        'NumberTitle','off',...
        'Name','Voltage Stability Toolbox - Load Flow Analysis (Standard NR)',...
        'Resize','off',...
        'Position',position,...
        'Color',[0.7 0.8 0.9],...
        'MenuBar','none');  % EDITED BY: Vedanshu

% ==============================
% Help menu
helpmenu=uimenu(loadflow_fig,...
    'Label','Help');

    hlp=uimenu(helpmenu,...
        'Label','Help',...
        'CallBack','helpfun(lf_hlpTitle,hlpStr2)');
   lf_hlpTitle=['Voltage Stability Toolbox - Load Flow Analysis Help Window'];
   
   
    path(path,LFpathname);
    eval(['load ',CurrentSystem,'.mat']);

    titlepanel;

    % Present editable data: states & params
    k_states=length(x);
    k_params=length(param);
    lfmklabl;

    clear ParamSlider;

    lowerpanel;

    uicontrol(loadflow_fig,...
        'Style','text',...
        'Position',[display_length*45-30,106,150,16],...
        'String','Parameter Values',...
        'BackgroundColor','y');
  
    %*********************************
    % Load Flow Controls
    %*********************************
    % Tolerence
    LFAbsTol=.000001;
    LFRelTol=.0001;

    % *************************
    % pop-up algortithm selector
    % *************************
    LF_Alg_List=['lfcomp'];
    LF_Alg=LF_Alg_List(1,1:6);    

    upperpanel;

    alg_popup=uicontrol(loadflow_fig,...
        'Style','text',...
        'Position',[30,270,223,18],...
        'HorizontalAlignment','Center',...
        'String','Newton-Raphson');
end
