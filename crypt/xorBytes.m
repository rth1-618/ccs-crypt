function out = xorBytes(bytes, keyBytes)
% XORBYTES   Simple XOR stream: bytes and keyBytes are uint8 vectors.
    if isempty(bytes)
        out = uint8([]);
        return;
    end
    key = uint8(keyBytes(:));
    if isempty(key)
        error('xorBytes: empty key');
    end
    keyRep = repmat(key, ceil(numel(bytes)/numel(key)), 1);
    
    keyRep = keyRep(1:numel(bytes));
    out = bitxor(uint8(bytes(:)), uint8(keyRep));
end
