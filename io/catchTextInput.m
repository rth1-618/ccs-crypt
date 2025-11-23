function catchTextInput(app, panelName)
% defensive text capture: returns early if UI not yet registered

    ui = app.UI.(panelName);

    % Now safe to read value
    val = ui.UserInput.Value;
    if iscell(val)
        app.currentText = strjoin(val, newline);
    else
        app.currentText = char(val);
    end
    
end
