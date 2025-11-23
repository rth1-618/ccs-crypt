function out = caesarDecrypt(inText, shift)
    out = caesarEncrypt(inText, -shift);
end
