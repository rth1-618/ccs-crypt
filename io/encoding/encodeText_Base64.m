function b64 = encodeText_Base64(txt)
% ENCODETEXT_BASE64 Convert a text string to base64 string.

    if isempty(txt)
        b64 = "";
        return;
    end

    % Convert text → bytes
    bytes = uint8(txt);

    % Encode bytes → Base64 string
    b64 = matlab.net.base64encode(bytes);
end
