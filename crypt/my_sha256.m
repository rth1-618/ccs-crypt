function hash_output = my_sha256(message)
    % MY_SHA256 Computes the SHA-256 hash of a message.
    %   hash_output = my_sha256(message) returns the SHA-256 hash as a uint8 array.
    %
    %   Input:
    %       message - A uint8 array containing the message bytes.
    %
    %   Output:
    %       hash_output - A 32-element uint8 array representing the hash.

    % Constants: First 32 bits of the fractional parts of the cube roots of the first 64 primes
    K = uint32([
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    ]);

    % Initial hash values: First 32 bits of the fractional parts of the square roots of the first 8 primes
    H = uint32([
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    ]);

    % Pre-processing: Pad the message
    msg_len = uint64(length(message)) * 8;  % Length in bits
    message = uint8(message);
    
    % Append '1' bit
    message = [message, uint8(128)];  % 128 is 10000000 in binary
    
    % Pad with zeros until length ≡ 448 mod 512
    while mod(length(message), 64) ~= 56
        message = [message, uint8(0)];
    end
    
    % Append original length as 64-bit big-endian
    len_bytes = typecast(msg_len, 'uint8');
    len_bytes = len_bytes(end:-1:1);  % Big-endian
    message = [message, len_bytes];
    
    % Process the message in 512-bit (64-byte) chunks
    for i = 1:64:length(message)
        chunk = message(i:i+63);
        
        % Break chunk into sixteen 32-bit big-endian words
        W = zeros(64, 1, 'uint32');
        for j = 1:16
            W(j) = bitshift(uint32(chunk((j-1)*4+1)), 24) + ...
                   bitshift(uint32(chunk((j-1)*4+2)), 16) + ...
                   bitshift(uint32(chunk((j-1)*4+3)), 8) + ...
                   uint32(chunk((j-1)*4+4));
        end
        
        % Extend the sixteen 32-bit words into sixty-four 32-bit words
        for j = 17:64
            s0 = bitror(W(j-15), 7) + bitror(W(j-15), 18) + bitshift(W(j-15), -3);
            s1 = bitror(W(j-2), 17) + bitror(W(j-2), 19) + bitshift(W(j-2), -10);
            W(j) = W(j-16) + s0 + W(j-7) + s1;
        end
        
        % Initialize working variables
        a = H(1); b = H(2); c = H(3); d = H(4);
        e = H(5); f = H(6); g = H(7); h = H(8);
        
        % Compression function main loop
        for j = 1:64
            S1 = bitror(e, 6) + bitror(e, 11) + bitror(e, 25);
            ch = bitxor(bitand(e, f), bitand(bitcmp(e), g));
            temp1 = h + S1 + ch + K(j) + W(j);
            S0 = bitror(a, 2) + bitror(a, 13) + bitror(a, 22);
            maj = bitxor(bitxor(bitand(a, b), bitand(a, c)), bitand(b, c));
            temp2 = S0 + maj;
            
            h = g;
            g = f;
            f = e;
            e = d + temp1;
            d = c;
            c = b;
            b = a;
            a = temp1 + temp2;
        end
        
        % Add the compressed chunk to the current hash value
        H(1) = H(1) + a;
        H(2) = H(2) + b;
        H(3) = H(3) + c;
        H(4) = H(4) + d;
        H(5) = H(5) + e;
        H(6) = H(6) + f;
        H(7) = H(7) + g;
        H(8) = H(8) + h;
    end
    
    % Produce the final hash value as a 256-bit number (big-endian)
    hash_output = zeros(1, 32, 'uint8');
    for i = 1:8
        temp = typecast(H(i), 'uint8');
        hash_output((i-1)*4+1:i*4) = temp(end:-1:1);  % Big-endian
    end
end

function r = bitror(x, n)
    % BITROR Rotate right by n bits
    r = bitshift(x, -n) + bitshift(x, 32 - n);
end