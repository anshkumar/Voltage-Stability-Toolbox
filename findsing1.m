function [averagevoltage,averagedelta]=findsing1(alpha,lowdelta,topdelta,lowvoltage,topvoltage,X,Y,Z)

  averagevoltage=zeros(1,length(alpha));
  indexalpha= zeros(1,length(alpha));
  indexlowdelta= zeros(1,length(alpha));
  indextopdelta= zeros(1,length(alpha));
  lowydelta= zeros(1,length(alpha));
  topydelta= zeros(1,length(alpha));
  topzvoltage=zeros(1,length(alpha));
  lowzvoltage=zeros(1,length(alpha));
  diffaprroxreal=zeros(length(alpha),2);
  
   for i=1:length(alpha)
    difference=0.05;
    count=1;
    while(X(1,count)<alpha(i)+0.01)
     if(difference>abs(alpha(i)-X(1,count)))
       difference=abs(alpha(i)-X(1,count));
       indexalpha(i)=count;
     end 
     count=count+1;
    end
    
    difference=0.05;
    count=1;
    while(Y(count,1)<lowdelta(i)+0.01)
     if(difference>abs(abs(lowdelta(i))-abs(Y(count,1))))
       difference>abs(abs(lowdelta(i))-abs(Y(count,1)));
       indexlowdelta(i)=count;
       lowydelta(i)=Y(count,1);
     end 
     count=count+1;
    end
    
    difference=0.05;
    count=1;
    while(Y(count,1)<topdelta(i)+0.01)
     if(difference>abs(abs(topdelta(i))-abs(Y(count,1))))
       difference>abs(abs(topdelta(i))-abs(Y(count,1)));
       indextopdelta(i)=count;
       topydelta(i)=Y(count,1);
     end 
     count=count+1;
    end 
    topzvoltage(i)=Z(indextopdelta(i),indexalpha(i));
    lowzvoltage(i)=Z(indexlowdelta(i),indexalpha(i));
    %diffapproxreal(i,1)=lowzvoltage(i)-lowvoltage(i);
    %diffapproxreal(i,2)=topvoltage(i)-topzvoltage(i);
    averagevoltage(i)=(lowzvoltage(i)+topzvoltage(i))/2 
    averagedelta(i)=(lowydelta(i)+topydelta(i))/2
    
    %/(diffapproxreal(i,1)+diffapproxreal(i,2))
    %averagevoltage(i)=(diffapproxreal(i,2)*lowzvoltage(i) ...
    %+diffapproxreal(i,1)* topzvoltage(i)) ...
    %/(diffapproxreal(i,1)+diffapproxreal(i,2))
   end
   
   