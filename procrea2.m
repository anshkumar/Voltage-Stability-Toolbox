function s = procread(filename)
%PROCREAD Install a Maple procedure.
%       PROCREAD(FILENAME) reads the specified file, which should
%       contain the source text for a Maple procedure.  It deletes any
%       comments and newline characters, then sends the resulting string
%       to Maple.  The Extended Symbolic Toolbox is required.
%
%       Example.
%
%           Suppose the file "check.src" contains the following
%           source text for a Maple procedure.
%
%               check := proc(A)
%               #   check(A) computes A*inverse(A)
%                   local X;
%                   X := inverse(A):
%                   evalm(A &* X);
%               end;
%
%           Then the statement
%
%               procread('check.src')
%
%           installs the procedure.  It can be accessed with 
%
%               maple('check',magic(3))
%
%           or
%
%               maple('check',vpa(magic(3)))
%
%       See also MAPLE.

%       Copyright (c) 1993-95 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1995/03/01 21:38:55 $

% Open the file and read the text.

f = fopen(filename);
if f < 0
   error(['Could not open ' filename])
end
s = fread(f)';

% Delete comments and newlines.

%e = find(s==10);
%for j = fliplr(find(s=='#'))
%   k = min(e(e>j));
%   s(j:k) = [];
%end
kk=find(s==10);

e = find(s==10|s==13);
s(e) = ' '*ones(size(e));

L_kk=length(kk);
remainder=L_kk-2;
while remainder>2
        done=L_kk-remainder;
        tt=s(kk(done)+1:kk(done+min(2,remainder-2)));
        remainder=remainder-2; 
     % Send the string to Maple.
        tt = setstr(tt);
     %   pause
        tt = maple(tt);         
end;
% Send the string to Maple.

% s = setstr(s);
% s = maple(s);
