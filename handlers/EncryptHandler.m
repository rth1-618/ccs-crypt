function EncryptHandler(app)
% Dispatch encryption depending on active module and input mode.
    M = app.currentModule;
    ui = app.UI.(M);

    % Validate inputs
    if app.isInputImage
        if isempty(app.currentImage)
            uialert(app.UIFigure,'Load an image first.','Error'); return;
        end
    else
        if isempty(strtrim(app.currentText))
            uialert(app.UIFigure,'Enter text first.','Error'); return;
        end
    end

    try
        switch M
            case 'CaesarPanel'
                shift = app.ShiftEditField.Value;
                app.outputText = caesarEncrypt(app.currentText, shift);
                app.outputImage = [];
                % show output
                ui.UserOutput.Value = app.outputText;
                % ui.PreviewAxes.Visible = 'off';
                % ui.PreviewText.Visible = 'off';
                % ui.PreviewText.Value = splitlines(app.outputText);
                ui.Status.Text = 'Encrypted (Caesar)';

            case 'XORPanel'
                % need key
                key = app.currentKey;
                if isempty(key)
                    uialert(app.UIFigure,'Enter a key in the Key field.','Error'); return;
                end
                if app.isInputImage
                    % image -> bytes -> xor -> bytes -> image
                    [inBytes, meta] = imageToBytes(app.currentImage);
                    outBytes = xorBytes(inBytes, uint8(key));
                    app.outputImage = bytesToImage(outBytes, meta);
                    app.outputText = '';
                    % show image preview and enable save
                    % ui.PreviewText.Visible = 'off';
                    ui.PreviewAxes.Visible = 'on';
                    imshow(app.outputImage, 'Parent', ui.PreviewAxes);
                    ui.Btn_SaveImage.Visible = 'on';
                    ui.Status.Text = 'Encrypted (XOR image)';
                else
                    % text path: text->bytes->xor->bytes->text
                    inBytes = textToBytes(app.currentText);
                    outBytes = xorBytes(inBytes, uint8(key));
                    app.outputText = bytesToText(outBytes);
                    app.outputImage = [];
                    ui.UserOutput.Value = app.outputText;
                    ui.PreviewAxes.Visible = 'off';
                    % ui.PreviewText.Visible = 'on';
                    % ui.PreviewText.Value = splitlines(app.outputText);
                    ui.Status.Text = 'Encrypted (XOR text)';
                end
            otherwise
                uialert(app.UIFigure,'Encrypt: module not implemented','Error');
        end
    catch ME
        uialert(app.UIFigure, ['Encrypt error: ' ME.message], 'Error');
    end
end
