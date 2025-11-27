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
            otherwise
                uialert(app.UIFigure,'Decrypt: module not implemented','Error');
        end
    catch ME
        uialert(app.UIFigure, ['Decrypt error: ' ME.message], 'Error');
    end
end
