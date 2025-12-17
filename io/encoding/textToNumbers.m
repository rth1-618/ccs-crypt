function nums = textToNumbers(txt)
% Convert text to numeric vector (ASCII)

    bytes = uint8(txt);
    nums = double(bytes);
end
