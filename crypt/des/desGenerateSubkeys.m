function subkeys = desGenerateSubkeys(key8)
% DESGENERATESUBKEYS produce 16 subkeys (48-bit) for DES from 8-byte key
% key8 : 8x1 uint8 vector (including parity bits)
% subkeys : 16 x 48 logical matrix (or numeric 0/1)

T = desTables();

% Convert key8 -> 64-bit vector (MSB-first)
kbits = false(1,64);
idx=1;
for i=1:8
    b = key8(i);
    for pos = 8:-1:1
        kbits(idx) = bitget(b,pos);
        idx = idx+1;
    end
end

% Apply PC-1 (select 56 bits)
K56 = kbits(T.PC1);  % 56 logicals
C = K56(1:28);
D = K56(29:56);

subkeys = false(16,48);
for round=1:16
    % left shifts
    shift = T.SHIFTS(round);
    C = circshift(C, -shift);
    D = circshift(D, -shift);
    CD = [C D];
    % apply PC-2 to get 48 bits
    sub = CD(T.PC2);
    subkeys(round,:) = sub;
end
end
