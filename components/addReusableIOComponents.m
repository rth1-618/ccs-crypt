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
        ui.InputTypeGroup = uibuttongroup(P, 'Position',[20 350 300 40], ...
            'SelectionChangedFcn', @(bg,event)switchInputMode(app,event,panelName));
        ui.TextRadio = uiradiobutton(ui.InputTypeGroup, 'Text','Text Input', 'Position',[10 8 100 22], 'Value', true);
        ui.ImageRadio = uiradiobutton(ui.InputTypeGroup, 'Text','Image Input', 'Position',[120 8 120 22]);
    end

    % Text input label + area
    uilabel(P,'Text','Text Input:','Position',[20 300 80 22]);
    ui.UserInput = uitextarea(P, 'Position',[20 200 300 90]);
    % attach callback to capture text into app
    ui.UserInput.ValueChangedFcn = @(t,e)catchTextInput(app, panelName);

    % Input path / info (single-line) - shows image path when image mode
    ui.InputPath = uieditfield(P,'text','Position',[20 170 300 22], 'Editable','off','Visible','off');

    % Load/Save image buttons (hidden unless image mode)
    if allowImage
        ui.InputPath.Visible = 'on';
        ui.Btn_LoadImage = uibutton(P, 'Text','Load Image', 'Position',[340 300 120 30], ...
            'ButtonPushedFcn', @(btn,event)Btn_LoadImagePushed(app,event,panelName), 'Visible','off');
        ui.Btn_SaveImage = uibutton(P, 'Text','Save Image', 'Position',[340 240 120 30], ...
            'ButtonPushedFcn', @(btn,event)Btn_SaveImagePushed(app,event,panelName), 'Visible','off');
    end

    % Encrypt / Decrypt / Reset buttons
    ui.Btn_Encrypt = uibutton(P, 'Text','Encrypt', 'Position',[20 150 100 35], ...
        'ButtonPushedFcn', @(btn,event)EncryptHandler(app));
    ui.Btn_Decrypt = uibutton(P, 'Text','Decrypt', 'Position',[140 150 100 35], ...
        'ButtonPushedFcn', @(btn,event)DecryptHandler(app));
    ui.Btn_Reset   = uibutton(P, 'Text','Reset', 'Position',[260 150 100 35], ...
        'ButtonPushedFcn', @(btn,event)resetModule(app,panelName));

    % Output area (single textarea) — used for text outputs
    uilabel(P,'Text','Output:','Position',[20 110 80 22]);
    ui.UserOutput = uitextarea(P, 'Position',[20 10 300 100], 'Editable','off');

    % Add a small preview area under output (shared for text or image)
    ui.PreviewAxes = uiaxes(P, 'Position',[340 10 280 220], 'Visible','off');
    ui.PreviewText = uitextarea(P, 'Position',[340 10 280 220], 'Editable','off', 'Visible','off');

    % Key input (single line) — default hidden; modules can show it
    ui.Edit_Key = uieditfield(P,'text', 'Position',[340 200 200 25], 'Visible','off');

    % Status label
    ui.Status = uilabel(P, 'Text','Ready', 'Position',[460 240 160 22]);

    % Save handles back
    app.UI.(panelName) = ui;
end
