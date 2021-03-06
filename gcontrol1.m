    static_fig=gcf;
 
    Text_frame_hgt=20;

% Create State Number Text label
    uicontrol(static_fig,...
        'Style','frame',...
        'BackgroundColor','b',...
        'Position',[400,30,135,350]);

    uicontrol(static_fig,...
           'Style','text',...
           'String','StateVariable:',...
           'BackgroundColor',[0.701961 0.701961 0.701961],...
           'Position',[405,333,125,Text_frame_hgt]);

% Create State Number Text 
  Null_Space_HANDLES(1)=uicontrol(static_fig,...
           'Style','text',...
           'String',statename(1,:),...
           'BackgroundColor',[0.701961 0.701961 0.701961],...
           'Position',[405,311,125,Text_frame_hgt]);

% Create Null Space Spanning Vector slider
  Null_Space_HANDLES(2)=uicontrol(static_fig,...
           'Style','slider',...
           'Min',1,'Max',k_states,'Value',1,...
           'Backgroundcolor',[0.701961 0.701961 0.701961],...
           'Callback',['i_max=round(get(Null_Space_HANDLES(2),''Value''));',...
 'set(Null_Space_HANDLES(1),''String'', statename(i_max,:));',...
 'set(Null_Space_HANDLES(3),''String'', abs(vpoc(i_max,:)));'],...
           'Position',[405,289,125,20]);

% Create Null Space label
  Null_Space_HANDLES(3) = uicontrol(static_fig,...
           'Style','text',...
           'String',abs(vpoc),...
           'BackgroundColor',[0.701961 0.701961 0.701961],...
           'Position',[405,267,125,Text_frame_hgt]);

  uicontrol(static_fig,...
           'Style','text',...
           'String','NullSpaceVector:',...
           'BackgroundColor',[0.701961 0.701961 0.701961],...
           'Position',[405,245,125,Text_frame_hgt]);

  
% Create Parameter Text label
  uicontrol(static_fig,...
           'Style','text',...
           'String','Parameter:',...
           'BackgroundColor',[0.701961 0.701961 0.701961],...
           'Position',[405,133,125,Text_frame_hgt]);

% Create State Number Text 
  RemedialAction_HANDLES(1) = uicontrol(static_fig,...
           'Style','text',...
           'String',paramname(1,:),...
           'BackgroundColor',[0.701961 0.701961 0.701961],...
           'Position',[405,111,125,20]);

  RemedialAction_HANDLES(2) = uicontrol(static_fig,...
           'Style','slider',...
           'Min',1,'Max',k_params,'Value',1,...
           'Backgroundcolor',[0.701961 0.701961 0.701961],...
           'Callback',['i_max1=round(get(RemedialAction_HANDLES(2),''Value''));',...
'set(RemedialAction_HANDLES(1),''String'', paramname(i_max1,:));',...
'set(RemedialAction_HANDLES(3),''String'', wpoc(i_max1,:));'],...
           'Position',[405,89,125,20]);

% Create Remedial Action Pop-Up 
  RemedialAction_HANDLES(3) = uicontrol(static_fig,...
           'Style','text',...
           'String',wpoc,...
           'BackgroundColor',[0.701961 0.701961 0.701961],...
           'Position',[405,67,125,Text_frame_hgt]);

   uicontrol(static_fig,...
           'Style','text',...
           'String','Remedial Action:',...
           'BackgroundColor',[0.701961 0.701961 0.701961],...
           'Position',[405,45,125,Text_frame_hgt]);  
           
  Bif_Data_Flag=1;
