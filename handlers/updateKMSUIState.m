function updateKMSUIState(app)
ui = app;   % direct access, no reusable UI

env = app.Envelope;

% ---- Defaults ----
app.InitKMSButton.Enable        = 'on';
app.EncryptButton.Enable        = 'off';
app.WrapDEKButton.Enable        = 'off';
app.SaveEnvelopeButton.Enable   = 'off';
app.LoadEnvelopeButton.Enable   = 'on';
app.UnwrapDEKButton.Enable      = 'off';
app.DecryptButton.Enable        = 'off';

    app.IVErrorLabel.Text='';

% ---- Rules ----
if ~isempty(env.kms)
    app.EncryptButton.Enable = 'on';
end

if ~isempty(env.ciphertext)
    app.WrapDEKButton.Enable = 'on';
end

if ~isempty(env.wrappedDEK)
    app.SaveEnvelopeButton.Enable = 'on';
end

if isfield(env,'envelope') && ~isempty(env.envelope)
    app.UnwrapDEKButton.Enable = 'on';
end

if ~isempty(env.DEK) && isfield(env,'envelope')
    app.DecryptButton.Enable = 'on';
end

if numel(app.Envelope.iv) ~= 24 || ~all(isstrprop(app.Envelope.iv,'xdigit'))
    app.EncryptButton.Enable = 'off';
    app.IVErrorLabel.Text='IV ERROR';
end

if isempty(strtrim(app.Envelope.plainTextInput))
    app.EncryptButton.Enable = 'off';
    app.IVErrorLabel.Text='ENTER INPUT';
end

end
