function digest = sha256_bytes(msg)
% SHA256_BYTES  Correct, compact, portable SHA-256 implementation
% Input: char, string or uint8 (will be converted to uint8 row)
% Output: 32x1 uint8 digest (big-endian)

    % --- normalize input to uint8 row ---
    if isstring(msg), msg = char(msg); end
    if ~isa(msg,'uint8'), msg = uint8(msg); end
    msg = msg(:)';  % row

    % --- initial hash values (big-endian uint32) ---
    H = uint32([ ...
        hex2dec('6a09e667') hex2dec('bb67ae85') hex2dec('3c6ef372') hex2dec('a54ff53a') ...
        hex2dec('510e527f') hex2dec('9b05688c') hex2dec('1f83d9ab') hex2dec('5be0cd19') ]);

    % --- constants K (uint32) ---
    K = uint32([ ...
        1116352408 1899447441 3049323471 3921009573  961987163 1508970993 2453635748 2870763221 ...
        3624381080 310598401  607225278 1426881987 1925078388 2162078206 2614888103 3248222580 ...
        3835390401 4022224774 264347078  604807628   770255983 1249150122 1555081692 1996064986 ...
        2554220882 2821834349 2952996808 3210313671 3336571891 3584528711 113926993  338241895 ...
        666307205  773529912  1294757372 1396182291 1695183700 1986661051 2177026350 2456956037 ...
        2730485921 2820302411 3259730800 3345764771 3516065817 3600352804 4094571909 275423344 ...
        430227734  506948616  659060556  883997877   958139571 1322822218 1537002063 1747873779 ...
        1955562222 2024104815 2227730452 2361852424 2428436474 2756734187 3204031479 3329325298 ]);

    % --- Preprocessing (padding) ---
    L = uint64(numel(msg) * 8);           % length in bits (uint64)
    msg = [msg uint8(128)];               % append 0x80

    % append 0x00 until length in bytes ≡ 56 (mod 64)
    while mod(numel(msg),64) ~= 56
        msg(end+1) = uint8(0); %#ok<AGROW>
    end

    % append length as 64-bit big-endian
    % swapbytes on uint64 then typecast yields big-endian bytes
    lenBE = typecast(swapbytes(L),'uint8'); % 1x8 uint8 already big-endian
    msg = [msg lenBE];

    % number of 512-bit blocks
    N = numel(msg)/64;

    % process blocks
    Hwork = H;
    for blk = 1:N
        chunk = msg((blk-1)*64 + (1:64)); % 1x64 uint8

        % build message schedule W (64 uint32)
        W = zeros(64,1,'uint32');
        % convert chunk into 16 uint32 words (big-endian)
        W(1:16) = swapbytes(typecast(chunk,'uint32'));  % ensures big-endian words

        for t = 17:64
            s0 = bitxor(bitxor(rotr(W(t-15),7), rotr(W(t-15),18)), bitshift(W(t-15),-3));
            s1 = bitxor(bitxor(rotr(W(t-2),17), rotr(W(t-2),19)), bitshift(W(t-2),-10));
            % use uint64 to accumulate then mask to 32 bits
            W(t) = uint32(bitand(uint64(W(t-16)) + uint64(s0) + uint64(W(t-7)) + uint64(s1), uint64(2^32-1)));
        end

        % initialize working vars
        a = Hwork(1); b = Hwork(2); c = Hwork(3); d = Hwork(4);
        e = Hwork(5); f = Hwork(6); g = Hwork(7); h = Hwork(8);

        for t = 1:64
            S1  = bitxor(bitxor(rotr(e,6), rotr(e,11)), rotr(e,25));
            ch  = bitxor(bitand(e,f), bitand(bitcmp(e),g));
            temp1 = uint32(bitand(uint64(h) + uint64(S1) + uint64(ch) + uint64(K(t)) + uint64(W(t)), uint64(2^32-1)));

            S0 = bitxor(bitxor(rotr(a,2), rotr(a,13)), rotr(a,22));
            maj = bitxor(bitxor(bitand(a,b), bitand(a,c)), bitand(b,c));
            temp2 = uint32(bitand(uint64(S0) + uint64(maj), uint64(2^32-1)));

            h = g;
            g = f;
            f = e;
            e = uint32(bitand(uint64(d) + uint64(temp1), uint64(2^32-1)));
            d = c;
            c = b;
            b = a;
            a = uint32(bitand(uint64(temp1) + uint64(temp2), uint64(2^32-1)));
        end

        % update working hash
        Hwork = uint32(bitand(uint64(Hwork) + uint64([a b c d e f g h]), uint64(2^32-1)));
    end

    % convert Hwork (8x uint32) to 32xuint8 big-endian bytes
    digest = zeros(32,1,'uint8');
    for i = 1:8
        digest((i-1)*4 + (1:4)) = typecast(swapbytes(Hwork(i)),'uint8');
    end
end

function y = rotr(x,n)
% rotate right for uint32 inputs
    x = uint32(x);
    y = bitor(bitshift(x, -n), bitshift(x, 32-n));
end
