% this M-file computes the reactive power
%injection at the generator buses for each singular point...
%for the Loparo's five bus system


%reactive power injection at gen1
gen1=14.4-(12)*XX_sing(3)*cos(XX_sing(4));
gen1_inject=[gen1_inject gen1];


%reactive power injection at gen2

gen2=14.4-(12)*XX_sing(3)*cos(XX_sing(1)-XX_sing(4));
gen2_inject=[gen2_inject gen2];

%reactive power injection at gen3
gen3=14.4-(12)*XX_sing(5)*cos(XX_sing(2)-XX_sing(6));
gen3_inject=[gen3_inject gen3];



