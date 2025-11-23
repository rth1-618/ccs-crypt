function bytes = textToBytes(txt)
% TEXTTOBYTES   Convert text (char or string) to uint8 column vector.
    if isempty(txt)
        bytes = uint8([]);
        return;
    end
    if isstring(txt)
        txt = char(txt);
    end
    % Accept either cell array (lines) or char
    if iscell(txt)
        txt = strjoin(txt, newline);
    end
    bytes = uint8(char(txt(:)));
end
