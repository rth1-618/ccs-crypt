function txt = decodeText_Base64(b64)
% DECODETEXT_BASE64 Convert base64 string back to plain text.

    if isempty(b64)
        txt = "";
        return;
    end

    % Decode Base64 string → bytes
    bytes = matlab.net.base64decode(b64);

    % Convert back to character text
    txt = char(bytes(:).');
end
