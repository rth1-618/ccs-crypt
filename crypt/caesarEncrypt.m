function out = caesarEncrypt(inText, shift)
% CAESARENCRYPT  shift only alphabetic characters, preserve others.
    if isempty(inText)
        out = '';
        return;
    end
    s = char(inText);
    out = s;
    for k = 1:numel(s)
        c = s(k);
        if c >= 'A' && c <= 'Z'
            out(k) = char(mod(double(c)-double('A') + shift, 26) + double('A'));
        elseif c >= 'a' && c <= 'z'
            out(k) = char(mod(double(c)-double('a') + shift, 26) + double('a'));
        else
            out(k) = c;
        end
    end
end
