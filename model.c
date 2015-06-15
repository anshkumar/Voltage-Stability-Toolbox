/* Number of Generators:1,  They are bus #1 to bus #1*/
/* Number of PV loads:2,  They are bus #2 to bus #3*/
/* Number of PQ loads:2,  They are bus #4 to bus #5*/
/*The classic steady state model: */

f1[1]=((((e[1]*(e[1]*g[1][1]))+(((b[1][2]*e[1])*(e[2]*sin((th[1]-th[2]))))+((cos((th[1]-th[2]))*e[2])*(e[1]*g[1][2]))))+(((b[1][5]*e[1])*(e[5]*sin((th[1]-th[5]))))+((cos((th[1]-th[5]))*e[5])*(e[1]*g[1][5]))))-p[1]);

             /*The derivative with respect to th[1]  */
j[1][1]=((((b[1][2]*e[1])*(e[2]*cos((th[1]-th[2]))))+((((-1)*sin((th[1]-th[2])))*e[2])*(e[1]*g[1][2])))+(((b[1][5]*e[1])*(e[5]*cos((th[1]-th[5]))))+((((-1)*sin((th[1]-th[5])))*e[5])*(e[1]*g[1][5]))));

             /*The derivative with respect to th[2]  */
j[1][2]=(((b[1][2]*e[1])*(e[2]*(cos((th[1]-th[2]))*(-1))))+((((-1)*(sin((th[1]-th[2]))*(-1)))*e[2])*(e[1]*g[1][2])));

             /*The derivative with respect to th[3]  */
j[1][3]=0;

             /*The derivative with respect to e[4]  */
j[1][4]=0;

             /*The derivative with respect to th[4]  */
j[1][5]=0;

             /*The derivative with respect to e[5]  */
j[1][6]=(((b[1][5]*e[1])*sin((th[1]-th[5])))+(cos((th[1]-th[5]))*(e[1]*g[1][5])));

             /*The derivative with respect to th[5]  */
j[1][7]=(((b[1][5]*e[1])*(e[5]*(cos((th[1]-th[5]))*(-1))))+((((-1)*(sin((th[1]-th[5]))*(-1)))*e[5])*(e[1]*g[1][5])));

f1[2]=((((((b[2][1]*e[2])*(e[1]*sin((th[2]-th[1]))))+((cos((th[2]-th[1]))*e[1])*(e[2]*g[2][1])))+(e[2]*(e[2]*g[2][2])))+(((b[2][3]*e[2])*(e[3]*sin((th[2]-th[3]))))+((cos((th[2]-th[3]))*e[3])*(e[2]*g[2][3]))))-p[2]);

             /*The derivative with respect to th[1]  */
j[2][1]=(((b[2][1]*e[2])*(e[1]*(cos((th[2]-th[1]))*(-1))))+((((-1)*(sin((th[2]-th[1]))*(-1)))*e[1])*(e[2]*g[2][1])));

             /*The derivative with respect to th[2]  */
j[2][2]=((((b[2][1]*e[2])*(e[1]*cos((th[2]-th[1]))))+((((-1)*sin((th[2]-th[1])))*e[1])*(e[2]*g[2][1])))+(((b[2][3]*e[2])*(e[3]*cos((th[2]-th[3]))))+((((-1)*sin((th[2]-th[3])))*e[3])*(e[2]*g[2][3]))));

             /*The derivative with respect to th[3]  */
j[2][3]=(((b[2][3]*e[2])*(e[3]*(cos((th[2]-th[3]))*(-1))))+((((-1)*(sin((th[2]-th[3]))*(-1)))*e[3])*(e[2]*g[2][3])));

             /*The derivative with respect to e[4]  */
j[2][4]=0;

             /*The derivative with respect to th[4]  */
j[2][5]=0;

             /*The derivative with respect to e[5]  */
j[2][6]=0;

             /*The derivative with respect to th[5]  */
j[2][7]=0;

f1[3]=((((((b[3][2]*e[3])*(e[2]*sin((th[3]-th[2]))))+((cos((th[3]-th[2]))*e[2])*(e[3]*g[3][2])))+(e[3]*(e[3]*g[3][3])))+(((b[3][4]*e[3])*(e[4]*sin((th[3]-th[4]))))+((cos((th[3]-th[4]))*e[4])*(e[3]*g[3][4]))))-p[3]);

             /*The derivative with respect to th[1]  */
j[3][1]=0;

             /*The derivative with respect to th[2]  */
j[3][2]=(((b[3][2]*e[3])*(e[2]*(cos((th[3]-th[2]))*(-1))))+((((-1)*(sin((th[3]-th[2]))*(-1)))*e[2])*(e[3]*g[3][2])));

             /*The derivative with respect to th[3]  */
j[3][3]=((((b[3][2]*e[3])*(e[2]*cos((th[3]-th[2]))))+((((-1)*sin((th[3]-th[2])))*e[2])*(e[3]*g[3][2])))+(((b[3][4]*e[3])*(e[4]*cos((th[3]-th[4]))))+((((-1)*sin((th[3]-th[4])))*e[4])*(e[3]*g[3][4]))));

             /*The derivative with respect to e[4]  */
j[3][4]=(((b[3][4]*e[3])*sin((th[3]-th[4])))+(cos((th[3]-th[4]))*(e[3]*g[3][4])));

             /*The derivative with respect to th[4]  */
j[3][5]=(((b[3][4]*e[3])*(e[4]*(cos((th[3]-th[4]))*(-1))))+((((-1)*(sin((th[3]-th[4]))*(-1)))*e[4])*(e[3]*g[3][4])));

             /*The derivative with respect to e[5]  */
j[3][6]=0;

             /*The derivative with respect to th[5]  */
j[3][7]=0;

f1[4]=(((((b[4][3]*e[4])*(e[3]*sin((th[4]-th[3]))))+((cos((th[4]-th[3]))*e[3])*(e[4]*g[4][3])))+(e[4]*(e[4]*g[4][4])))-p[4]);

             /*The derivative with respect to th[1]  */
j[4][1]=0;

             /*The derivative with respect to th[2]  */
j[4][2]=0;

             /*The derivative with respect to th[3]  */
j[4][3]=(((b[4][3]*e[4])*(e[3]*(cos((th[4]-th[3]))*(-1))))+((((-1)*(sin((th[4]-th[3]))*(-1)))*e[3])*(e[4]*g[4][3])));

             /*The derivative with respect to e[4]  */
j[4][4]=(((b[4][3]*(e[3]*sin((th[4]-th[3]))))+((cos((th[4]-th[3]))*e[3])*g[4][3]))+((e[4]*g[4][4])+(e[4]*g[4][4])));

             /*The derivative with respect to th[4]  */
j[4][5]=(((b[4][3]*e[4])*(e[3]*cos((th[4]-th[3]))))+((((-1)*sin((th[4]-th[3])))*e[3])*(e[4]*g[4][3])));

             /*The derivative with respect to e[5]  */
j[4][6]=0;

             /*The derivative with respect to th[5]  */
j[4][7]=0;

f2[1]=(((((g[4][3]*e[4])*(e[3]*sin((th[4]-th[3]))))-((cos((th[4]-th[3]))*e[3])*(e[4]*b[4][3])))+(0-(e[4]*(e[4]*b[4][4]))))-q[4]);

             /*The derivative with respect to th[1]  */
j[6][1]=((0-(0*(e[4]*b[4][3])))+(0-((0*(e[4]*b[4][4]))+(e[4]*((0*b[4][4])+(e[4]*0))))));

             /*The derivative with respect to th[2]  */
j[6][2]=((0-(0*(e[4]*b[4][3])))+(0-((0*(e[4]*b[4][4]))+(e[4]*((0*b[4][4])+(e[4]*0))))));

             /*The derivative with respect to th[3]  */
j[6][3]=((((g[4][3]*e[4])*(e[3]*(cos((th[4]-th[3]))*(-1))))-((((-1)*(sin((th[4]-th[3]))*(-1)))*e[3])*(e[4]*b[4][3])))+(0-((0*(e[4]*b[4][4]))+(e[4]*((0*b[4][4])+(e[4]*0))))));

             /*The derivative with respect to e[4]  */
j[6][4]=(((g[4][3]*(e[3]*sin((th[4]-th[3]))))-((cos((th[4]-th[3]))*e[3])*b[4][3]))+(0-((1*(e[4]*b[4][4]))+(e[4]*((1*b[4][4])+(e[4]*0))))));

             /*The derivative with respect to th[4]  */
j[6][5]=((((g[4][3]*e[4])*(e[3]*cos((th[4]-th[3]))))-((((-1)*sin((th[4]-th[3])))*e[3])*(e[4]*b[4][3])))+(0-((0*(e[4]*b[4][4]))+(e[4]*((0*b[4][4])+(e[4]*0))))));

             /*The derivative with respect to e[5]  */
j[6][6]=((0-(0*(e[4]*b[4][3])))+(0-((0*(e[4]*b[4][4]))+(e[4]*((0*b[4][4])+(e[4]*0))))));

             /*The derivative with respect to th[5]  */
j[6][7]=((0-(0*(e[4]*b[4][3])))+(0-((0*(e[4]*b[4][4]))+(e[4]*((0*b[4][4])+(e[4]*0))))));

f1[5]=(((((b[5][1]*e[5])*(e[1]*sin((th[5]-th[1]))))+((cos((th[5]-th[1]))*e[1])*(e[5]*g[5][1])))+(e[5]*(e[5]*g[5][5])))-p[5]);

             /*The derivative with respect to th[1]  */
j[5][1]=(((b[5][1]*e[5])*(e[1]*(cos((th[5]-th[1]))*(-1))))+((((-1)*(sin((th[5]-th[1]))*(-1)))*e[1])*(e[5]*g[5][1])));

             /*The derivative with respect to th[2]  */
j[5][2]=0;

             /*The derivative with respect to th[3]  */
j[5][3]=0;

             /*The derivative with respect to e[4]  */
j[5][4]=0;

             /*The derivative with respect to th[4]  */
j[5][5]=0;

             /*The derivative with respect to e[5]  */
j[5][6]=(((b[5][1]*(e[1]*sin((th[5]-th[1]))))+((cos((th[5]-th[1]))*e[1])*g[5][1]))+((e[5]*g[5][5])+(e[5]*g[5][5])));

             /*The derivative with respect to th[5]  */
j[5][7]=(((b[5][1]*e[5])*(e[1]*cos((th[5]-th[1]))))+((((-1)*sin((th[5]-th[1])))*e[1])*(e[5]*g[5][1])));

f2[2]=(((((g[5][1]*e[5])*(e[1]*sin((th[5]-th[1]))))-((cos((th[5]-th[1]))*e[1])*(e[5]*b[5][1])))+(0-(e[5]*(e[5]*b[5][5]))))-q[5]);

             /*The derivative with respect to th[1]  */
j[7][1]=((((g[5][1]*e[5])*(e[1]*(cos((th[5]-th[1]))*(-1))))-((((-1)*(sin((th[5]-th[1]))*(-1)))*e[1])*(e[5]*b[5][1])))+(0-((0*(e[5]*b[5][5]))+(e[5]*((0*b[5][5])+(e[5]*0))))));

             /*The derivative with respect to th[2]  */
j[7][2]=((0-(0*(e[5]*b[5][1])))+(0-((0*(e[5]*b[5][5]))+(e[5]*((0*b[5][5])+(e[5]*0))))));

             /*The derivative with respect to th[3]  */
j[7][3]=((0-(0*(e[5]*b[5][1])))+(0-((0*(e[5]*b[5][5]))+(e[5]*((0*b[5][5])+(e[5]*0))))));

             /*The derivative with respect to e[4]  */
j[7][4]=((0-(0*(e[5]*b[5][1])))+(0-((0*(e[5]*b[5][5]))+(e[5]*((0*b[5][5])+(e[5]*0))))));

             /*The derivative with respect to th[4]  */
j[7][5]=((0-(0*(e[5]*b[5][1])))+(0-((0*(e[5]*b[5][5]))+(e[5]*((0*b[5][5])+(e[5]*0))))));

             /*The derivative with respect to e[5]  */
j[7][6]=(((g[5][1]*(e[1]*sin((th[5]-th[1]))))-((cos((th[5]-th[1]))*e[1])*b[5][1]))+(0-((1*(e[5]*b[5][5]))+(e[5]*((1*b[5][5])+(e[5]*0))))));

             /*The derivative with respect to th[5]  */
j[7][7]=((((g[5][1]*e[5])*(e[1]*cos((th[5]-th[1]))))-((((-1)*sin((th[5]-th[1])))*e[1])*(e[5]*b[5][1])))+(0-((0*(e[5]*b[5][5]))+(e[5]*((0*b[5][5])+(e[5]*0))))));

