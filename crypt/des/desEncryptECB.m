function cipherBytes = desEncryptECB(plainBytes, key7)
% DESENCRYPTECB Encrypt a uint8 vector using DES-ECB with zero padding.
% plainBytes : uint8 column vector or row
% key7 : 7-char string or 7x1 uint8. If empty, a random key7 is generated and returned in second output.
% Returns cipherBytes (uint8 vector) same length as padded input.

if ischar(key7), key7 = uint8(key7); end
if isempty(key7)
    key7 = uint8(randi([0 255],7,1));
end
key7 = uint8(key7(:));
if numel(key7) ~= 7, error('DES key must be 7 bytes'); end

% form parity key
[key8, ~] = addParityBits(key7);

% generate subkeys
subkeys = desGenerateSubkeys(key8);

% pad input
plainBytes = uint8(plainBytes(:));
padded = padZero(plainBytes,8);

% process per-block
nBlocks = numel(padded)/8;
cipherBytes = zeros(nBlocks*8,1,'uint8');
for i=1:nBlocks
    block = padded((i-1)*8 + (1:8))';
    out = desBlock(block, subkeys, 'encrypt');
    cipherBytes((i-1)*8 + (1:8)) = out(:);
end
end
