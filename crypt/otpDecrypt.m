function plainText = otpDecrypt(cipherText, keyString)
% Reverse Ci = (Pi + Ki) mod 26 → Pi = (Ci - Ki) mod 26

    if isempty(cipherText) || isempty(keyString)
        plainText = '';
        return;
    end

    % convert keyString -> numeric array
    key = sscanf(keyString, '%d')';

    s = char(cipherText);
    n = length(s);

    if length(key) ~= n
        error('OTP key length does not match ciphertext length.');
    end

    out = s;

    for i = 1:n
        c = s(i);

        if c >= 'A' && c <= 'Z'
            C = double(c) - double('A');
            P = mod(C - key(i), 26);
            out(i) = char(P + double('A'));

        elseif c >= 'a' && c <= 'z'
            C = double(c) - double('a');
            P = mod(C - key(i), 26);
            out(i) = char(P + double('a'));

        else
            out(i) = c; % unchanged
        end
    end

    plainText = out;
end
