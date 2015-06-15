function helpfun(titleStr,helpStr1,helpStr2,helpStr3,helpStr4,helpStr5)
 
numPages=nargin-1;
if nargin<6,
    helpStr5=' ';
end;
if nargin<5,
    helpStr4=' ';
end;
if nargin<4,
    helpStr3=' ';
end;
if nargin<3,
    helpStr2=' ';
end;

% First turn on the watch pointer in the old figure
oldFigNumber=watchon;

% If the Help Window has already been created, bring it to the front
[existFlag,figNumber]=figflag('Voltage Stability Toolbox (VST) - Help',1);
newHelpWindowFlag=~existFlag;

if newHelpWindowFlag,
    position=get(0,'DefaultFigurePosition');
    position=position-[170 170 0 0];
    figNumber=figure(...
        'Name','Voltage Stability Toolbox  - Help',...
        'NumberTitle','off',...
        'NextPlot','new',...
	     'Visible','off',...
	     'Position',position,...
	     'Colormap',[],...
        'Color',[0.7 0.8 0.9],...
        'MenuBar','none');  % When MenuBar is none, uimenus are the only items on the menu bar (that is, the built-in menus do not appear).
                        % EDITED BY: Vedanshu

    %===================================
    % Set up the Help Window
    top=0.93;
    left=0.05;
    right=0.75;
    bottom=0.05;
    labelHt=0.06;
    spacing=0.02;

    % Then the text label
    frmBorder=0.005;
    frmPos=[left top-labelHt (right-left) labelHt];
    labelPos=[left top-labelHt (right-left) labelHt]+frmBorder*[1 1 -2 -2];
    uicontrol(...
        'Style','frame',...
        'Units','normalized',...
        'Position',frmPos,...
		  'BackgroundColor','r');

    ttlHndl=uicontrol(...
		  'Style','text',...
        'Units','normalized',...
        'Position',labelPos,...
        'BackgroundColor',[1 1 1],...
        'ForegroundColor',[0 0 0],...
        'String',titleStr);

    % Then the editable text field (of which there are three)
    % Store the text field's handle two places: once in the figure
    % UserData and once in the button's UserData.
    
    frmBorder=0.005;
    frmPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    uicontrol(...
        'Style','frame',...
        'Units','normalized',...
        'Position',frmPos,...
		  'BackgroundColor',[0.5 0.5 0.5]);

    for count=1:5,
    	helpStr=eval(['helpStr',num2str(count)]);
    	txtPos=[left bottom (right-left) top-bottom-labelHt-spacing]...
            +frmBorder*[1 1 -2 -2];
    	txtHndlList(count)=uicontrol(...
    	    'Style','edit',...
    	    'Units','normalized',...
    	    'Max',20,...
    	    'String',helpStr,...
    	    'BackgroundColor',[1 1 1],...
          'Visible','off',...
          'HorizontalAlignment','Left',...
    	    'Position',txtPos);
    end;
    set(txtHndlList(1),'Visible','on');

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.93;
    bottom=0.05;
    yInitPos=0.80;
    left=0.80;
    btnWid=0.15;
    btnHt=0.10;
    % Spacing between the button and the next command's label
    spacing=0.05;

    %====================================
    % All required BUTTONS
    for count=1:5
	% The PAGE button
	labelStr=['Page ',num2str(count)];
	% The callback will turn off ALL text fields and then turn on
	% only the one referred to by the button.
	callbackStr=...
	   ['txtHndl=get(gco,''UserData'');'...
	    'hndlList=get(gcf,''UserData'');'...
	    'set(hndlList(2:6),''Visible'',''off'');'...
	    'set(txtHndl,''Visible'',''on'');'];
	btnHndlList(count)=uicontrol(...
    	    'Style','pushbutton',...
    	    'Units','normalized',...
    	    'Position',[left top-btnHt-(count-1)*(btnHt+spacing) btnWid btnHt], ...
    	    'String',labelStr,...
	       'UserData',txtHndlList(count),...
	       'Visible','off',...
    	    'Callback',callbackStr);
    end;

    %====================================
    % The CLOSE button
    callbackStr='f1=gcf; set(f1,''Visible'',''off'');'; % EDITED BY: Vedanshu
    uicontrol(...
        'Style','pushbutton',...
        'Units','normalized',...
        'Position',[left 0.05 btnWid 0.10],...
        'String','Close',...
        'Callback',callbackStr);

    hndlList=[ttlHndl txtHndlList btnHndlList];
        
    set(figNumber,'UserData',hndlList)
end;

% Now that we've determined the figure number, we can install the
% Desired strings.
hndlList=get(figNumber,'UserData');
ttlHndl=hndlList(1);
txtHndlList=hndlList(2:6);
btnHndlList=hndlList(7:11);
set(ttlHndl,'String',titleStr);
set(txtHndlList(2:3),'Visible','off');
set(txtHndlList(1),'Visible','on');
set(txtHndlList(1),'String',helpStr1);
set(txtHndlList(2),'String',helpStr2);
set(txtHndlList(3),'String',helpStr3);
set(txtHndlList(4),'String',helpStr4);
set(txtHndlList(5),'String',helpStr5);

if numPages==1,
    set(btnHndlList,'Visible','off');
elseif numPages==2,
    set(btnHndlList,'Visible','off');
    set(btnHndlList(1:2),'Visible','on');
elseif numPages==3,
    set(btnHndlList(1:3),'Visible','on');
elseif numPages==4,
    set(btnHndlList(1:4),'Visible','on');
elseif numPages==5,
    set(btnHndlList(1:5),'Visible','on');
end;

set(figNumber,'Visible','on');
% Turn off the watch pointer in the old figure
watchoff(oldFigNumber);
figure(figNumber);
