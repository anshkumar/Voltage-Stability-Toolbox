display_length=min(k_states,5);

all_theta=no_gen+no_pv-1;
total_state=all_theta+2*no_pq;

ii=1;
%clear statename;
statename=[];
last_one='theta';
for i=1:k_states
   if i <= all_theta
      statename=str2mat(statename,['delta',num2str(ii+1)]);
      ii=ii+1;
   elseif (i>all_theta)&(i<=total_state)&(last_one=='theta')
      statename=str2mat(statename,['V',num2str(ii+1)]);
      last_one='V';
   elseif (i>all_theta)&(i<=total_state)&(last_one=='V'),
      statename=str2mat(statename,['delta',num2str(ii+1)]);
      last_one='theta';
      ii=ii+1;
   elseif i>total_state,
      statename=str2mat(statename,'');
   end
end

for i=1:k_states
   statename(i,:)=statename(i+1,:);
end

ii=1;
%clear paramname;
 paramname =[];
last_one='Q';
for i=1:k_params
   if i <= all_theta,
      paramname=str2mat(paramname,['P',num2str(ii+1)]);
      ii=ii+1;
   elseif (i>all_theta)&(i<=total_state)&(last_one=='Q'),
      paramname=str2mat(paramname,['P',num2str(ii+1)]);
      last_one='P';
   elseif (i>all_theta)&(i<=total_state)&(last_one=='P'),
      paramname=str2mat(paramname,['Q',num2str(ii+1)]);
      last_one='Q';
      ii=ii+1;
   elseif i>total_state,
      statename=str2mat(statename,'');
   end
end

for i=1:k_params
   paramname(i,:)=paramname(i+1,:);
end

% make initial values for param from input data
ii=no_gen+1;
last_one='Q';
for i=1:k_params
   if i<=no_gen-1,
      param(i)=bus_p(i+1);
   end

   if (i>no_gen-1) & (i<=no_gen+no_pv-1)
      param(i)=bus_p(ii);
      ii=ii+1;
   end

   if (i>no_gen+no_pv-1) & (i<=no_gen+no_pv-1+2*no_pq)
      if last_one=='Q'
         param(i)=bus_p(ii);
         last_one='P';
      else 
         param(i)=bus_q(ii);
         last_one='Q';
         ii=ii+1;
      end
   end
end

% make initial values for x from input data
ii=no_gen+1;
last_one='t';
for i=1:k_states
   if i<=no_gen-1
      x(i)=bus_angl(i+1)-bus_angl(1);
   end

   if (i>no_gen-1) & (i<=no_gen+no_pv-1)
      % x(i)=bus_bus_angl(ii);
      x(i)=bus_angl(ii);
      ii=ii+1;
   end

   if (i>no_gen+no_pv-1) & (i<=no_gen+no_pv-1+2*no_pq)
      if last_one=='t'
         x(i)=bus_v(ii);
         last_one='v';
      else 
         x(i)=bus_angl(ii);
         last_one='t';
         ii=ii+1;
      end
   end
end
