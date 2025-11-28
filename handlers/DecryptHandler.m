function DecryptHandler(app)
    M = app.currentModule;
    ui = app.UI.(M);

    % Validate inputs
    if app.isInputImage
        if isempty(app.currentImage) && isempty(app.outputImage)
            uialert(app.UIFigure,'Load an image first.','Error'); return;
        end
    else
        if isempty(strtrim(app.currentText))
            uialert(app.UIFigure,'Enter text first.','Error'); return;
        end
    end

    ui.Status.Text = 'Decrypting...';
    try
        switch M
            case 'CaesarPanel'
                shift = app.ShiftEditField.Value;
                app.outputText = caesarDecrypt(app.currentText, shift);
                app.outputImage = [];
                ui.UserOutput.Value = app.outputText;
                % ui.PreviewAxes.Visible = 'off';
                % ui.PreviewText.Visible = 'on';
                % ui.PreviewText.Value = splitlines(app.outputText);
                ui.Status.Text = 'Decrypted (Caesar)';

            case 'XORPanel'
                key = app.currentKey;
                if isempty(key)
                    uialert(app.UIFigure,'Enter a key in the Key field.','Error'); return;
                end
                if app.isInputImage
                    [inBytes, meta] = imageToBytes(app.currentImage);
                    outBytes = xorBytes(inBytes, uint8(key)); % XOR symmetric
                    app.outputImage = bytesToImage(outBytes, meta);
                    app.outputText = '';
                    % ui.PreviewText.Visible = 'off';
                    ui.PreviewAxes.Visible = 'on';
                    imshow(app.outputImage, 'Parent', ui.PreviewAxes);
                    ui.Btn_SaveImage.Visible = 'on';
                    ui.Status.Text = 'Decrypted (XOR image)';
                else
                    inBytes = textToBytes(app.currentText);
                    outBytes = xorBytes(inBytes, uint8(key));
                    app.outputText = bytesToText(outBytes);
                    app.outputImage = [];
                    ui.UserOutput.Value = app.outputText;
                    ui.PreviewAxes.Visible = 'off';
                    % ui.PreviewText.Visible = 'off';
                    % ui.PreviewText.Value = splitlines(app.outputText);
                    ui.Status.Text = 'Decrypted (XOR text)';
                end
            case 'OTPPanel'
                cipher = app.currentText;
                keyStr = app.currentKey;
            
                if isempty(cipher)
                    uialert(app.UIFigure,'Enter ciphertext first.','Error'); return;
                end
                if isempty(keyStr)
                    uialert(app.UIFigure,'No OTP key stored. Encrypt first.','Error'); return;
                end
            
                try
                    plain = otpDecrypt(cipher, keyStr);
                catch ME
                    uialert(app.UIFigure, ME.message, 'Error');
                    return;
                end
            
                app.outputText = plain;
                ui.UserOutput.Value = plain;
                ui.Status.Text = 'Decrypted (OTP)';

            case 'DESPanel'
                ui = app.UI.(M);
                % key must be present in app.currentKey or in DESKeyEditField
                keyStr = app.currentKey;
                if ~isempty(app.DESKeyEditField.Value)
                    keyStr = char(app.DESKeyEditField.Value);
                end
                % if isempty(keyStr)
                %     keyStr = char(app.DESKeyEditField.Value);
                % end
                if isempty(keyStr) || numel(keyStr) ~= 7
                    uialert(app.UIFigure,'Provide 7-char key or encrypt to generate it','Error'); return;
                end
                key7 = uint8(keyStr(:));
                app = showKeyMatrix(key7,app);
            
                if app.isInputImage
                    [inBytes, meta] = imageToBytes(app.currentImage);
                    outBytes = desDecryptECB(inBytes, key7);
                    app.outputImage = bytesToImage(outBytes, meta); % meta must be known — store when loading
                    ui.PreviewAxes.Visible = 'on';
                    imshow(app.outputImage, 'Parent', ui.PreviewAxes);
                    ui.Btn_SaveImage.Visible = 'on';
                    ui.Status.Text = 'Decrypted (DES image)';
                else
                    % text: input is base64 display; convert base64 -> bytes then decrypt -> text
                    if isempty(app.currentText)
                        uialert(app.UIFigure,'Paste base64 ciphertext into input','Error'); return;
                    end
                    try
                        cipherBytes = matlab.net.base64decode(char(app.currentText));
                        outBytes = desDecryptECB(cipherBytes, key7);
                        app.outputText = bytesToText(outBytes);
                        ui.UserOutput.Value = app.outputText;
                        ui.Status.Text = 'Decrypted (DES text)';
                    catch ME
                        uialert(app.UIFigure, ['DES decrypt error: ' ME.message], 'Error');
                    end
                end

            otherwise
                uialert(app.UIFigure,'Decrypt: module not implemented','Error');
        end
    catch ME
        uialert(app.UIFigure, ['Decrypt error: ' ME.message], 'Error');
    end
end
