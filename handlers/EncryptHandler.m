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

    updateStatus(app, "Encrypting...");

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
            case 'OTPPanel'
                % Generate a one-time pad key
                txt = app.currentText;
                if isempty(strtrim(txt))
                    uialert(app.UIFigure,'Enter text first.','Error'); return;
                end
            
                [cipher, keyStr] = otpEncrypt(txt);
            
                app.outputText = cipher;
                app.currentKey = keyStr;
            
                ui.UserOutput.Value = cipher;
                app.OTPKeyEditField.Value = keyStr;
            
                ui.Status.Text = 'Encrypted (OTP)';

            case 'DESPanel'
                ui = app.UI.(M);
                % Get user key (7 chars) or generate
                keyStr = '';
                if ~isempty(app.DESKeyEditField.Value)
                    keyStr = char(app.DESKeyEditField.Value);
                end
                if isempty(keyStr)
                    key7 = uint8(randi([32,126],7,1)); % printable random if you want
                    keyStr = char(key7');
                    app.DESKeyEditField.Value = keyStr;
                else
                    if numel(keyStr) ~= 7
                        uialert(app.UIFigure,'Key must be exactly 7 characters','Error'); return;
                    end
                    key7 = uint8(keyStr(:));
                end
            
                % Show key ASCII to user
                app.currentKey = keyStr;
                app = showKeyMatrix(key7,app);
            
                % Prepare input bytes depending on mode
                if app.isInputImage
                    [inBytes, meta] = imageToBytes(app.currentImage);
                    outBytes = desEncryptECB(inBytes, key7);
                    app.outputImage = bytesToImage(outBytes, meta);
                    ui.PreviewAxes.Visible = 'on';
                    imshow(app.outputImage, 'Parent', ui.PreviewAxes);
                    ui.Btn_SaveImage.Visible = 'on';
                    ui.Status.Text = 'Encrypted (DES image)';
                else
                    % text path: convert text->bytes then encrypt; display base64 ciphertext
                    inBytes = textToBytes(app.currentText);
                    outBytes = desEncryptECB(inBytes, key7);
                    % show base64 for display purposes
                    cipherB64 = matlab.net.base64encode(outBytes);
                    app.outputText = char(cipherB64);
                    ui.UserOutput.Value = app.outputText;
                    ui.Status.Text = 'Encrypted (DES text, base64 shown)';
                end

            case 'HMACPanel'
                HMACHandler(app);
                
            otherwise
                uialert(app.UIFigure,'Encrypt: module not implemented','Error');
        end
    catch ME
        uialert(app.UIFigure, ['Encrypt error: ' ME.message], 'Error');
    end
end
