display_length=min(k_states,5);
CurrentState=max([1,round(get(sli_states,'Value'))]);

for i=1:display_length
    set(StateLabel(i),'String',statename(max(CurrentState-5,0)+i,:));
    set(StateValue(i),'String',num2str(x(max(CurrentState-5,0)+i)));
end
