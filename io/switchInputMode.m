function switchInputMode(app, event, panelName)
% Switch between Text and Image input modes in a panel.
    ui = app.UI.(panelName);
    new = event.NewValue.Text;
    if contains(new,'Image')
        app.isInputImage = true;
        % enable image controls
        ui.UserInput.Editable = 'off';
        ui.Btn_LoadImage.Visible = 'on';
        ui.Btn_SaveImage.Visible = 'off'; % only shown after output image present
        ui.InputPath.Editable = 'off';
        ui.InputPath.Value = ''; % will be set when image loaded
        ui.UserOutput.Value = ''; 
    else
        app.isInputImage = false;
        ui.UserInput.Editable = 'on';
        if isfield(ui,'Btn_LoadImage'), ui.Btn_LoadImage.Visible = 'off'; end
        if isfield(ui,'Btn_SaveImage'), ui.Btn_SaveImage.Visible = 'off'; end
        ui.InputPath.Editable = 'on';
    end
    resetModule(app,[],panelName);
end
