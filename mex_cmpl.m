%Creates Shell script file for compiling MEX file 
% 

[c_filename,pathname] = uigetfile('*.c','Select C source file');
if c_filename~=0
    watchon;

    in_filename=[pathname,c_filename]
    cmd_file='cmpl_cmd';
    filename=strtok(c_filename,'.');
    fid=fopen(cmd_file,'w');
    fprintf(fid,['mex -v ',in_filename,'\n']);  % EDITED BY: Vedanshu
    cmplcmd=sprintf('%s %s ','!mex -v -D__STDC__ ',in_filename);
%    fprintf(fid,['mv  ',filename,'.mexsol ',pathname,filename,'.mexsol\n']);
    fclose(fid);
    %! chmod +x cmpl_cmd;
    %! cmpl_cmd;
     cmplcmd;
     eval(cmplcmd);

    watchoff;
end;
