function resetModule(app, panelName)
% Reset UI & app state for the given panel
    if ~isfield(app.UI, panelName), return; end
    ui = app.UI.(panelName);

    % internal state
    app.currentText = '';
    app.currentImage = [];
    app.outputText = '';
    app.outputImage = [];
    app.currentKey = '';


    % UI controls (guarded)
    if isfield(ui,'UserInput'), ui.UserInput.Value = ''; end
    if isfield(ui,'UserOutput'), ui.UserOutput.Value = ''; end
    if isfield(ui,'InputPath'), ui.InputPath.Value = ''; end
    if isfield(ui,'PreviewAxes') 
        ui.PreviewAxes.Visible = 'off'; 
        imshow([], 'Parent', ui.PreviewAxes);
    end

    if isfield(ui,'Btn_SaveImage'), ui.Btn_SaveImage.Visible = 'off'; end

    % in image mode InputPath should be non-editable
    if isfield(ui,'TextRadio') && ui.TextRadio.Value
        ui.UserInput.Editable = 'on';
        if isfield(ui,'Btn_LoadImage'), ui.Btn_LoadImage.Visible = 'off'; end
    end

    switch panelName
        case 'CaesarPanel'
            app.ShiftEditField.Value = 3;
        case 'XORPanel'
            app.XORKeyEditField.Value = '';
        case 'OTPPanel'
            app.currentKey = '';
            app.OTPKeyEditField.Value = '';
        case 'DESPanel'
            app.DESKeyEditField.Value='';
            app.DESKeyTextArea.Value='';
    end

    ui.Status.Text = 'Reset complete';
end
