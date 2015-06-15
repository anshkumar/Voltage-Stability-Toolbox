function [lowalpha,topalpha,lowdelta,topdelta,lowvoltage,topvoltage]=findstate(Stab,AA,XX)

maxstabsize=length(Stab);
changed=0;
indexsib=0;
transition=0; % Keeps track of the index where the transition from 1 to 0 occurs.

for i=1:maxstabsize
   if Stab(i)==0 
   	changed=1;
   	transition=i;
   end
   
   if changed==1 & Stab(i)==1 
   	indexsib=i;
   	changed=0;
   end
end

count=0;

lowalpha=zeros(1,round((maxstabsize-indexsib)/10));
indexlowalpha=zeros(1,round((maxstabsize-indexsib)/10));

for i=indexsib:10:maxstabsize
   count=count+1;
   lowalpha(count)=AA(i);
   indexlowalpha(count)=i;
end	

topalpha=zeros(1,length(lowalpha));
indextopalpha=zeros(1,length(lowalpha));

for i=1:length(lowalpha)
  difference=1;
   count=1;
   while(count<transition)
     if(difference>abs(lowalpha(i)-AA(count)))
       difference=abs(lowalpha(i)-AA(count));
       topalpha(i)=AA(count);
       indextopalpha(i)=count;
     end 
    count=count+1;
   end
end

lowdelta=XX(22,indexlowalpha);
 topdelta=XX(22,indextopalpha);
 indexlowalpha;
 indextopalpha;
 lowvoltage=XX(21,indexlowalpha);
 topvoltage=XX(21,indextopalpha);
 %lowalpha
 