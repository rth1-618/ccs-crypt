function [key8, bitMatrix] = addParityBits(key7)
% ADDPARITYBITS Insert parity bits to 7-byte key producing 8-byte DES key.
% key7 : 7-element uint8 vector OR 7-char string
% key8 : 8-element uint8 (DES key, odd parity per byte)
% bitMatrix : 8x8 matrix of 0/1 bits (row-wise representation of key8)

    if ischar(key7), key7 = uint8(key7); end
    key7 = uint8(key7(:)); % column 7x1

    if numel(key7) ~= 7
        error('addParityBits: require exactly 7 input bytes (56 bits).');
    end

    % Build 56-bit stream (MSB-first for each byte)
    bits = false(1,56);
    idx = 1;
    for i=1:7
        b = key7(i);
        for bitpos = 8:-1:1  % MSB to LSB
            bits(idx) = bitget(b, bitpos);
            idx = idx + 1;
            if idx>56, break; end
        end
    end
    bits = bits(1:56); % ensure length

    % Pack into 8 bytes: each byte takes 7 bits (msb..lsb) into bits 8..2; bit1 is parity
    key8 = zeros(8,1,'uint8');
    for i=1:8
        startBit = (i-1)*7 + 1;
        block = bits(startBit : startBit+6); % 7 bits
        % place in positions 8..2
        byteVal = uint8(0);
        for k=1:7
            if block(k)
                pos = 9 - k; % k=1 -> bit8, k=7 -> bit2
                byteVal = bitor(byteVal, bitshift(uint8(1), pos-1));
            end
        end
        % compute parity bit (LSB) = 1 if number of ones in byteVal is even (to make total odd)
        onesCount = sum(bitget(byteVal,1:8));
        % currently bit1 is 0; count includes bits 2..8
        if mod(onesCount,2) == 0
            parity = 1;
        else
            parity = 0;
        end
        byteVal = bitor(byteVal, uint8(parity)); % set LSB
        key8(i) = byteVal;
    end

    % bitMatrix 8x8 (rows are bytes MSB->LSB)
    bitMatrix = zeros(8,8);
    for i=1:8
        for b=1:8
            bitMatrix(i,b) = bitget(key8(i), 9-b); % bitget pos: 8..1 map to columns 1..8
        end
    end
    % disp('key8');
    % disp(key8);
    % disp('base64 key8');
    % disp(matlab.net.base64encode(key8));
end
