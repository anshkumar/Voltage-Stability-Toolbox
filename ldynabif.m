% Dynamic Bifurcation Analysis Program (dynabif.m)
% LDYNABIF  up GUI for dynamic bifurcation analysis.
% This M-file is designed to obtain the lower part of the nose curve
% It allows users to specify search direction, tolerance, number of steps etc..

% ****************************************************************************
if exist('dlgfig')
    set(dlgfig,'Visible','off');
end

% Check whether data is loaded or not
%************************************

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


% Check the correct .dll file
%********************************

if LFfilename~=0,
    CurrentSystem=LFfilename(1:length(LFfilename)-lensub);
    if isempty(findstr(CurrentFileName,CurrentSystem))
        titleStr=[' Inconsistent Names '];
        textStr=['                                              '
                 ' Names of the data file and executable must   '
                 ' be consistent. Do you want to choose another '
                 ' executable now ?                             '
                ];
        dlgfig=mydlg(titleStr,textStr,'dynabif | rtnnow')
        return;
    end
   
    % Define a figure window and assign a handle to it.
    % **************************************************
    
    position=get(0,'DefaultFigurePosition');
    position=position-[70 70 0 0];
    dynamic_fig=figure(...
        'NumberTitle','off',...
        'Name','Voltage Stability Toolbox - Dynamic Bifurcation Analysis',...
        'Resize','off',...
        'Position',position,...
        'Color',[0.7 0.8 0.9]);

%********************************************************
% Help menu
% *******************************************************

helpmenu=uimenu(dynamic_fig,...
    'Label','Help');

    hlp=uimenu(helpmenu,...
        'Label','Help',...
        'CallBack','helpfun(ldb_hlpTitle,hlpStr5)');

ldb_hlpTitle=['Voltage Stability Toolbox - Dynamic Bifurcation Analysis Help Window'];
            
    % Add the LFpathname to the current path
    % *****************************************
    
    path(path,LFpathname);
    
    % Load the CurrentSystem (IEEE#.mat) mat file
    %*********************************************
     
    eval(['load ',CurrentSystem,'.mat']);
    
    % Add the title to the dynamic bifurcation analysis window (i.e.,Current System:IEEE#)
    %************************************************************************************
    
    titlepanel;
         
    % Present editable data: states & params
    % ***************************************
    
    k_states=length(x);		% x's are the states(i.e.,angle and voltage magnitude) 
    k_params=length(param);	% param is the parameters(i.e., net injections at each bus)
    
    %Label the states (i.e., delta1, V2, etc...)
    %********************************************
    
    lfmklabl; %Put the initial data and states values from the input


    % Default Search Direction
    %***************************
    
    p=zeros(size(param));
    
    % Add the lower panel to the current simulation window
    % *****************************************************
    
    lowerpanel;

    ParamSlider=uicontrol(gcf,...
        'Style','popupmenu',...
        'Position',[display_length*45-30,106,120,16],...    % EDITED BY: Vedanshu
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
    % Choose either Newton-Raphson-Seydel or Newton-Raphson algorithm
    % ****************************************************************
    %lhpfsrf implements continuation mehod and lfcomp runs load flow once for the given parameter
    LF_Alg_List=['lhpfsrf';'lfcomp '];
    LF_Alg=LF_Alg_List(1,1:7);
    
    % set up the upper panel in the current sumilation window
    % *********************************************************
    upperpanel1;

    % Set up the algorithm display
    % ********************************
    
    alg_popup=uicontrol(gcf,...
        'Style','popupmenu',...
        'Position',[30,310,223,18],...
        'HorizontalAlignment','Center',...
        'String','Newton-Raphson-Seydel|Newton-Raphson',...
        'Callback','LF_Alg=LF_Alg_List(get(alg_popup,''Value''),1:7);');
end;
