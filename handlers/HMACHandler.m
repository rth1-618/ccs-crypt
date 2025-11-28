function HMACHandler(app)
    ui = app.UI.(app.currentModule);

    msg = app.currentText;
    key = app.HMACKeyEditField.Value;

    if isempty(strtrim(msg))
        uialert(app.UIFigure,'Enter text first.','Error'); return;
    end
    if isempty(strtrim(key))
        uialert(app.UIFigure,'Enter HMAC key.','Error'); return;
    end

    try
        mac = hmacSHA256(key,msg);

        app.outputText = mac;
        ui.UserOutput.Value = mac;
        ui.Status.Text = 'HMAC generated';

    catch ME
        uialert(app.UIFigure, ['HMAC error: ' ME.message],'Error');
    end
end
