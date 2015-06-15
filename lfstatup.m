display_length=min(k_states,5);

for i=1:display_length
    x(max(CurrentState-5,0)+i)=str2num(get(StateValue(i),'String'));
end
