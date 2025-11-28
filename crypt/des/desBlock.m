function outBlock = desBlock(inBlock, subkeys, mode)
% DESBLOCK process one 8-byte block using subkeys; mode='encrypt' or 'decrypt'
% inBlock : 1x8 uint8
% outBlock : 1x8 uint8

if nargin<3, mode='encrypt'; end
T = desTables();

% convert to 64-bit vector
bits = false(1,64);
idx=1;
for i=1:8
    b = inBlock(i);
    for pos=8:-1:1
        bits(idx) = bitget(b,pos);
        idx=idx+1;
    end
end

% initial permutation
bits = bits(T.IP);

L = bits(1:32);
R = bits(33:64);

% For encrypt use subkeys 1..16; for decrypt use reversed order
if strcmpi(mode,'encrypt')
    keys = subkeys;
else
    keys = flipud(subkeys);
end

for r=1:16
    % Expansion E: expand R (32) to 48
    ER = R(T.E);
    % XOR with subkey
    SR = xor(ER, keys(r,:));
    % S-box substitution -> 32 bits
    out32 = false(1,32);
    pos = 1;
    for sIdx = 1:8
        block6 = SR((sIdx-1)*6 + (1:6));
        % compute row and col (bits: b1 b2 b3 b4 b5 b6)
        row = block6(1)*2 + block6(6)*1; % b1b6
        col = block6(2)*8 + block6(3)*4 + block6(4)*2 + block6(5)*1;
        val = T.S{sIdx}(row+1, col+1); % matlab index
        % convert val (0..15) to 4 bits MSB first
        for b=4:-1:1
            out32(pos) = bitget(val,b);
            pos = pos + 1;
        end
    end
    % permutation P
    Pout = out32(T.P);
    % feistel
    newR = xor(L, Pout);
    L = R;
    R = newR;
end

% preoutput concat R,L (note swap)
pre = [R L];

% final permutation FP
cipherBits = pre(T.FP);

% convert bits -> 8 bytes
outBlock = zeros(1,8,'uint8');
idx = 1;
for i=1:8
    val = uint8(0);
    for pos=8:-1:1
        if cipherBits(idx)
            val = bitor(val, bitshift(uint8(1), pos-1));
        end
        idx = idx+1;
    end
    outBlock(i) = val;
end
end
