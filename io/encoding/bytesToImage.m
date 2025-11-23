function img = bytesToImage(bytes, meta)
% BYTESTOIMAGE   Rebuild image from bytes using meta.
    if isempty(bytes) || isempty(meta) || isempty(meta.size)
        img = [];
        return;
    end

    switch meta.encodedClass
        case 'uint8'
            raw = reshape(uint8(bytes), meta.size);
            img = cast(raw, meta.class);
        case 'uint16'
            % bytes are little-endian uint16 representation
            u8 = uint8(bytes(:));
            u16 = typecast(u8,'uint16');
            raw = reshape(u16, meta.size);
            img = cast(raw, meta.class);
        case 'uint8_im2u8'
            raw = reshape(uint8(bytes), meta.size);
            img = raw; % best we can do
        otherwise
            error('bytesToImage: unknown meta.encodedClass');
    end
end
