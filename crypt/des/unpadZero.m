function out = unpadZero(inBytes)
% Remove trailing zeros — WARNING: if original ended with zeros this is ambiguous.
% This function removes trailing 0 bytes.
out = inBytes(:);
% remove trailing zeros
k = numel(out);
while k>0 && out(k)==0
    k = k-1;
end
out = out(1:k);
end