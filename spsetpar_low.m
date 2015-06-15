CurrentPoint=max([1,round(get(sli_point,'Value'))]);

set(pointHandle,'String',num2str(CurrentPoint));

param=PP(:,CurrentPoint);
x=XX(:,CurrentPoint);

simul_st_p=param;
simul_st_x=x;

for i=1:display_length
    set(ParamValue(i),'String',num2str(param(max(CurrentParam-5,0)+i)));
    set(StateValue(i),'String',num2str(x(max(CurrentState-5,0)+i)));
end
