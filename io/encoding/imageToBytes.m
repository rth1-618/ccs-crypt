function [bytes, meta] = imageToBytes(img)
% IMAGETOBYTES   Flatten image to bytes and return meta for reconstruction.
    if isempty(img)
        bytes = uint8([]);
        meta = struct('size',[],'class','');
        return;
    end
    meta.size = size(img);
    meta.class = class(img);
    % Accept uint8 images most commonly
    if isa(img,'uint8')
        bytes = uint8(img(:));
        meta.encodedClass = 'uint8';
    elseif isa(img,'uint16')
        % pack uint16 into uint8 (little-endian)
        arr = img(:);
        bytes = typecast(uint16(arr),'uint8');
        bytes = uint8(bytes(:));
        meta.encodedClass = 'uint16';
    else
        % fallback: convert to uint8 using im2uint8 (may change values)
        img8 = im2uint8(img);
        bytes = uint8(img8(:));
        meta.encodedClass = 'uint8_im2u8';
    end
end
