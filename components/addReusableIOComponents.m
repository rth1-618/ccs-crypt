function addReusableIOComponents(app, panelName, allowImage)
% addReusableIOComponents  Create reused UI pieces inside panel
%   app: the app object
%   panelName: name of panel property (e.g., 'CaesarPanel')
%   allowImage: boolean — whether to include image mode controls

    P = app.(panelName);

    % ensure UI namespace exists
    if ~isfield(app.UI, panelName)
        app.UI.(panelName) = struct();
    end
    ui = app.UI.(panelName);

    % Input type radio (for modules that accept images)
    if allowImage
        ui.InputTypeGroup = uibuttongroup(P, 'Position',[20 340 300 40], ...
            'SelectionChangedFcn', @(bg,event)switchInputMode(app,event.NewValue.Text,panelName));
        ui.TextRadio = uiradiobutton(ui.InputTypeGroup, 'Text','Text Input', 'Position',[10 8 100 22], 'Value', true);
        ui.ImageRadio = uiradiobutton(ui.InputTypeGroup, 'Text','Image Input', 'Position',[120 8 120 22]);
    end

    % Text input label + area
    uilabel(P,'Text','Input:','Position',[20 300 80 22]);
    ui.UserInput = uitextarea(P, 'Position',[20 210 300 90]);
    % attach callback to capture text into app
    ui.UserInput.ValueChangedFcn = @(t,e)catchTextInput(app, panelName);

    % Input path / info (single-line) - shows image path when image mode
    ui.InputPath = uieditfield(P,'text','Position',[20 190 300 35], 'Editable','off','Visible','off','Placeholder','File Path');

    % Load/Save image buttons (hidden unless image mode)
    if allowImage
        % ui.InputPath.Visible = 'on';
        ui.Btn_LoadImage = uibutton(P, 'Text','Load Image', 'Position',[20 250 120 30], ...
            'ButtonPushedFcn', @(btn,event)loadImageFile(app, panelName), 'Visible','on');
        ui.Btn_SaveImage = uibutton(P, 'Text','Save Image', 'Position',[160 250 120 30], ...
            'ButtonPushedFcn', @(btn,event)saveImageFile(app, panelName), 'Visible','off');
    end

    % Encrypt / Decrypt / Reset buttons
    label = 'Encrypt'; % default

    if strcmp(panelName,'HMACPanel')
        label = 'Generate HMAC';
    end
    ui.Btn_Encrypt = uibutton(P, 'Text',label, 'Position',[20 130 100 35], ...
        'ButtonPushedFcn', @(btn,event)EncryptHandler(app));
    ui.Btn_Decrypt = uibutton(P, 'Text','Decrypt', 'Position',[140 130 100 35], ...
        'ButtonPushedFcn', @(btn,event)DecryptHandler(app));
    ui.Btn_Reset   = uibutton(P, 'Text','Reset', 'Position',[260 130 100 35], ...
        'ButtonPushedFcn', @(btn,event)resetModule(app,panelName));
    if strcmp(panelName,'HMACPanel')
        ui.Btn_Decrypt.Visible = 'off';
        ui.Btn_Reset.Position = [140 130 100 35];
    end

    % Output area (single textarea) — used for text outputs
    uilabel(P,'Text','Output:','Position',[20 100 80 22]);
    ui.UserOutput = uitextarea(P, 'Position',[20 10 300 90], 'Editable','off');

    % Add a small preview area under output (shared for text or image)
    ui.PreviewAxes = uiaxes(P, 'Position',[360 50 280 250], 'Visible','off');
   
    % Status label
    ui.Status = uilabel(P, 'Text','Ready', 'Position',[450 20 320 30], 'FontSize',16,'FontWeight','bold');

    % Save handles back
    app.UI.(panelName) = ui;
end
