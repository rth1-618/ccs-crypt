function txt = bytesToText(bytes)
% BYTESTOTEXT   Convert uint8 vector to char row.
    if isempty(bytes)
        txt = '';
        return;
    end
    txt = char(bytes(:).'); % make a row char vector
end
