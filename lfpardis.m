display_length=min(k_params,5);
CurrentParam=max([1,round(get(sli_params,'Value'))]);

if exist('ParamSlider')
    if get(ParamSlider,'Value')==1
        % parameter option is chosen
        for i=1:display_length
            set(ParamValue(i),'String',num2str(param(max(CurrentParam-5,0)+i)));
        end
    else
        % direction option is chosen
        for i=1:display_length
            set(ParamValue(i),'String',num2str(p(max(CurrentParam-5,0)+i)));
        end
    end
else
    % only parameter option
    for i=1:display_length
        set(ParamValue(i),'String',num2str(param(max(CurrentParam-5,0)+i)));
    end
end
