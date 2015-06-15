function Yred=redbusad(Y,M)
% Yred=RedBusAd(Y,M) returns the reduced bus admittance matrix, for
% a network with full admittance matrix Y and in which the last M
% buses are to be eliminated. If Y is given as a sparse matrix,
% the Yred is returned as sparse. If Y is full, then Yred is full.
if M==0
	Yred=Y;
else
N=size(Y,1);
Y11=Y(1:N-M,1:N-M);Y12=Y(1:N-M,N-M+1:N);
Y21=Y(N-M+1:N,1:N-M);Y22=Y(N-M+1:N,N-M+1:N);
B=[Y22
   Y12];
U=orth(full(B));Q=U'*B;
Bstar=Q\U';
AA=Y11-Y12*Bstar*[Y21;Y11];
Yred=(eye(N-M)-Y12*Bstar(1:M,M+1:N))\AA;
if issparse(Y) == 1;
   Yred=sparse(Yred);
end
end

