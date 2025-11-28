function img = decodeImage_Base64(b64, meta)
% DECODEIMAGE_BASE64 Decode base64 string back into an image.

    if isempty(b64) || isempty(meta)
        img = [];
        return;
    end

    % Base64 → bytes
    bytes = matlab.net.base64decode(b64);

    % bytes → image (uses your existing decoder)
    img = bytesToImage(bytes, meta);
end
