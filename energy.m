% function to do the evaluation of energy function

function E=energy(i,no_pv,no_gen,no_pq,PPr,angle,voltage)

load c:\YB YB % Ybus

YB=full(imag(YB));% assuming a lossless sys. take out when a real lossless sys is used
u=no_pv+no_gen;
v=no_pq+u;

Pgen=dot(PPr(1:u),angle(1:u)); % gen and PV buses
Pload=dot(PPr((u+1):v),angle((u+1):v)); % load buses


sum1=0; % initialize
   for j=1:v,
      sum1=sum1+0.5*YB(j,j)*voltage(j); % evaluating the term BV^2
   end
   
sum2=0;  
for j=1:(v-1),
   for k=j+1:(v),      
      sum2=sum2+(voltage(j)*voltage(k)*YB(j,k)*cos(angle(j)-angle(k))); % evaluating the double summation 
   end
end

E=Pgen-Pload+sum1+sum2;