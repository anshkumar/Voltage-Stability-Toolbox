display_length=min(k_states,5);
CurrentState=max([1,round(get(sli_states,'Value'))]);

if exist('StateSlider')
    if get(StateSlider,'Value')==1
        % state  option is chosen
        for i=1:display_length   
            set(StateValue(i),'String',num2str(x(max(CurrentState-5,0)+i)));
        end
    else
        % direction option is chosen
        for i=1:display_length
            set(StateValue(i),'String',num2str(a(max(CurrentState-5,0)+i)));
        end
    end
else
    % only States option
    for i=1:display_length
        set(StateValue(i),'String',num2str(x(max(CurrentState-5,0)+i)));
    end
end
