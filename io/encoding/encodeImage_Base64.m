function [b64, meta] = encodeImage_Base64(img)
% ENCODEIMAGE_BASE64 Convert an image matrix to base64 string.
% Returns base64 string AND metadata required to rebuild the image.

    if isempty(img)
        b64 = "";
        meta = [];
        return;
    end

    % Convert image → bytes using your existing encoder
    [bytes, meta] = imageToBytes(img);

    % Base64 encode bytes
    b64 = matlab.net.base64encode(bytes);
end
