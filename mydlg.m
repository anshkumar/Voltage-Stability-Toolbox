function dlgfig=mydlg(titleStr,textStr,btncalls)

position=get(0,'DefaultFigurePosition');
position=position-[0 0 200 260];

%dlgfig=dialog(...
%    'Name',titleStr,...
%    'TextString',textStr,...
%    'ButtonStrings','Yes | No',...
%    'ButtonCalls',btncalls,...
%    'Position',position);

 dlgfig=questdlg(textStr,titleStr,'Yes');

 [yes1,no1]=strtok(btncalls,'|');
     lyes=length(yes1);
     lno=length(no1);
       yes2=yes1(1:lyes-1);
        no2=no1(2:lno);
  
 if(strcmp(dlgfig,'Yes'))
     clear dlgfig;
     eval(yes2);
  else
     eval(no2);
    end

