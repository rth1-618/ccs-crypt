function plainBytes = desDecryptECB(cipherBytes, key7)
% DESDECRYPTECB Decrypt DES-ECB (zero padded).
if ischar(key7), key7 = uint8(key7); end
key7 = uint8(key7(:));
if numel(key7) ~= 7, error('DES key must be 7 bytes'); end

[key8, ~] = addParityBits(key7);
subkeys = desGenerateSubkeys(key8);

cipherBytes = uint8(cipherBytes(:));
if mod(numel(cipherBytes),8) ~= 0
    error('Cipher length must be multiple of 8');
end

nBlocks = numel(cipherBytes)/8;
plainPadded = zeros(nBlocks*8,1,'uint8');
for i=1:nBlocks
    block = cipherBytes((i-1)*8 + (1:8))';
    out = desBlock(block, subkeys, 'decrypt');
    plainPadded((i-1)*8 + (1:8)) = out(:);
end

% remove trailing zeros (note ambiguous if original ended in zeros)
plainBytes = unpadZero(plainPadded);
end
