eval(['load ',CurrentSystem,'.mat']);

% make initial values for param from input data
ii=no_gen+1;
last_one='Q';
for i=1:k_params
 if i<=no_gen-1,
        param(i)=bus_p(i+1);
 end;
 if (i>no_gen-1) & (i<=no_gen+no_pv-1),
        param(i)=bus_p(ii);
        ii=ii+1
 end;
 if (i>no_gen+no_pv-1) & (i<=no_gen+no_pv-1+2*no_pq),
        if last_one=='Q',
                param(i)=bus_p(ii);
                last_one='P';
        else 
                param(i)=bus_q(ii);
                last_one='Q';
                ii=ii+1;
        end;
 end;
end;

p=zeros(k_params,1);

lfsetsta;
lfsetpar;
v=zeros(length(x),1);
