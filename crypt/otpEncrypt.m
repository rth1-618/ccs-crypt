function [cipherText, keyString] = otpEncrypt(plainText)
% OTP classical: Ci = (Pi + Ki) mod 26
% Only letters shift; others untouched.
% Key is random integers [0..25], one per letter in plaintext.

    if isempty(plainText)
        cipherText = '';
        keyString = '';
        return;
    end

    s = char(plainText);
    n = length(s);

    % Generate key values
    seed = RandStream('mt19937ar','Seed','shuffle');
    key = randi(seed,[0 25], 1, n);

    out = s;

    for i = 1:n
        c = s(i);

        if c >= 'A' && c <= 'Z'
            P = double(c) - double('A');
            C = mod(P + key(i), 26);
            out(i) = char(C + double('A'));

        elseif c >= 'a' && c <= 'z'
            P = double(c) - double('a');
            C = mod(P + key(i), 26);
            out(i) = char(C + double('a'));

        else
            % non-alphabet → do not use key; XOR-like OTPs use pads for every char
            % classical OTP skips non-letters → force key(i) = 0
            key(i) = 0;
            out(i) = c;
        end
    end

    cipherText = out;

    % Convert numeric key to a space-separated string (easy to reuse)
    keyString = strtrim(sprintf('%d ', key));
end
