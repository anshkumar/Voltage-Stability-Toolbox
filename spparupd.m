display_length=min(k_states,5);
CurrentState=max([1,round(get(sli_states,'Value'))]);

if exist('StateSlider')
    if get(StateSlider,'Value')==1
        % state option is chosen
        for i=1:display_length
            x(max(CurrentState-5,0)+i)=str2num(get(StateValue(i),'String'));
        end
    else
        % direction option is chosen
        for i=1:display_length,
            a(max(CurrentState-5,0)+i)=str2num(get(StateValue(i),'String'));
        end
    end
else
    % only parameter option
    for i=1:display_length
        x(max(CurrentState-5,0)+i)=str2num(get(StateValue(i),'String'));
    end
end
