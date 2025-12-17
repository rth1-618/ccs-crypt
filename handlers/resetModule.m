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
        case 'HMACPanel'
            app.HMACKeyEditField.Value='';
        case 'RSAPanel'
            app.pEditField.Value = 17;
            app.qEditField.Value = 19;
            app.pStatusLabel.Text = '';
            app.qStatusLabel.Text = '';
            app.nLabel.Text = " n = ___";
            app.eDropDown.Enable = 'off';
            app.eDropDown.Items = {};
            app.eDropDown.Value = {};
            app.GenerateKeysButton.Enable = 'off';
            app.UI.(panelName).Btn_Encrypt.Enable = 'off';
            app.UI.(panelName).Btn_Decrypt.Enable = 'off';

            validateRSAInputs(app);
        case 'DiffHellPanel'
            app.DH = struct('p',[],'g',[],'a',[],'b',[],'A',[],'B',[],'S_A',[],'S_B',[]);
            app.pDHEditField.Value = 0;
            app.gDHEditField.Value = 0;
            app.BobPrivateEditField.Value = 0;
            app.AlicePrivateEditField.Value = 0;
            app.AlicePublicLabel.Text = '';
            app.BobPublicLabel.Text = '';
            app.AliceSharedLabel.Text = '';
            app.BobSharedLabel.Text = '';
            app.BobsComputeSecretKeyButton.Enable = 'off';
            app.AlicesComputeSecretKeyButton.Enable = 'off';

            app.PublishBtoAliceButton.Enable = 'off';
            app.PublishAtoBobButton.Enable = 'off';

            app.UI.(panelName).Btn_Encrypt.Visible = 'off';
            app.UI.(panelName).Btn_Decrypt.Visible = 'off';
            app.UI.(panelName).UserInput.Visible = 'off';
            app.UI.(panelName).UserOutput.Visible = 'off';

        case 'EnvelopePanel'

    end

    ui.Status.Text = 'Reset complete';
end
