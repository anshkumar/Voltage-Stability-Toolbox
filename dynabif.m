% DYNABIF	Dynamic Bifurcation Analysis Program
%		DYNABIF Sets up GUI for dynamic bifurcation analysis.
%

if exist('dlgfig')
    set(dlgfig,'Visible','off');
end

% Make sure data is loaded.
if ~exist('DataFlag'),DataFlag=0;end
if DataFlag==0,getdata;end;
if DataFlag==0,return;end;
if (strcmp(computer,'SOL2' ))
  mexwild = '*.mexsol';
  lensub=7;
elseif (strcmp(computer, 'PCWIN'))
   mexwild = '*.mexw32';
    lensub=7;
end

[LFfilename,LFpathname]=uigetfile(mexwild,'choose system for analysis');
if LFfilename~=0,
    CurrentSystem=LFfilename(1:length(LFfilename)-lensub);
    if isempty(findstr(CurrentFileName,CurrentSystem))
        titleStr=[' Inconsistent Names '];
        textStr=['                                              '
                 ' Names of the data file and executable must   '
                 ' be consistent. Do you want to choose another '
                 ' executable now ?                             '
                ];
        dlgfig=mydlg(titleStr,textStr,'dynabif | rtnnow');
        return;
    end

    % Define a figure window and assign a handle to it.
    position=get(0,'DefaultFigurePosition');
    position=position-[70 70 0 0];
    dynamic_fig=figure(...
        'NumberTitle','off',...
        'Name','Voltage Stability Toolbox - Dynamic Bifurcation Analysis',...
        'Resize','off',...
        'Position',position,...
        'Color',[0.7 0.8 0.9],...
        'MenuBar','none');  % EDITED BY: Vedanshu

% ==============================
% Help menu
helpmenu=uimenu(dynamic_fig,...
    'Label','Help');

    hlp=uimenu(helpmenu,...
        'Label','Help',...
        'CallBack','helpfun(db_hlpTitle,hlpStr5)');

db_hlpTitle=['Voltage Stability Toolbox - Dynamic Bifurcation Analysis Help Window'];
                         
    path(path,LFpathname);
    eval(['load ',CurrentSystem,'.mat']);

    titlepanel;
         
    % Present editable data: states & params
    k_states=length(x);
    k_params=length(param);
    lfmklabl;

    % Default Search Direction
    p=zeros(size(param));

    lowerpanel;

    ParamSlider=uicontrol(gcf,...
        'Style','popupmenu',...
        'Position',[display_length*45-30,106,120,16],...
        'BackgroundColor','Y',...
        'String','Parameter Values|Search Direction',...
        'Callback','lfpardis');

    %*********************************
    % Load Flow Controls
    %*********************************
    % Tolerence
    LFAbsTol=.000001;
    LFRelTol=.0001;

    % *************************
    % NR and NRS Step Control	
    % *************************
    % NR and NRS Steps
    
    NR_steps=100;
    NRS_Steps=100;
    % *************************
    % pop-up algortithm selector
    % *************************
    LF_Alg_List=['hpfsrf';'lfcomp'];
    LF_Alg=LF_Alg_List(1,1:6);

    upperpanel1;

    alg_popup=uicontrol(gcf,...
        'Style','popupmenu',...
        'Position',[30,310,223,18],...
        'HorizontalAlignment','Center',...
        'String','Newton-Raphson-Seydel|Newton-Raphson',...
        'Callback','LF_Alg=LF_Alg_List(get(alg_popup,''Value''),1:6);');
end;
