function macHex = hmacSHA256(key, msg)
% HMAC-SHA256  Pure MATLAB HMAC using sha256_bytes()
% key, msg: char or string
% macHex: 64-char lowercase hex string

    % Convert to uint8 row
    key = uint8(char(key(:)'));
    msg = uint8(char(msg(:)'));

    % ----- Normalize key -----
    if numel(key) > 64
        key = sha256_bytes(key);  % 32 bytes
    end
    if numel(key) < 64
        key = [key, uint8(zeros(1, 64-numel(key)))];
    end

    % ----- ipad / opad -----
    ipad = bitxor(key, uint8(0x36));
    opad = bitxor(key, uint8(0x5C));

    % ----- INNER HASH -----
    innerHash = sha256_bytes([ipad msg]);   % returns 32×1 uint8
    innerHash = innerHash(:)';             % convert to row

    % ----- OUTER HASH -----
    macBytes = sha256_bytes([opad innerHash]);
    macBytes = macBytes(:)';                % row

    % return hex
    macHex = lower(reshape(dec2hex(macBytes,2).',1,[]));
end
