classdef KMS
    % Mini KMS: versions + AES Key Wrap 
    methods(Static)
        function kms = init()
            kms.KEK = []; 
                 
            %kms.enabled  = [];           % true/false per KEK version
        end

        function [kms] = rotate(kms)
              kms.KEK = uint8(randi([0,255],[1,32]));            
        end

        %function kms = disable(kms, ver)
            

        function [wrappedDEK, kms] = wrap(kms, DEK)
            KEK = kms.KEK;
            wrappedDEK = KMS.aes_key_wrap(DEK, KEK);
            
        end

        function [DEK, kms] = unwrap(kms, wrappedDEK)
            KEK = kms.KEK;
            DEK = KMS.aes_key_unwrap(wrappedDEK, KEK);
        end
    end


    methods(Static, Access=private)
    
        % ---------- AES Key Wrap ----------
        function C = aes_key_wrap(P, KEK)
            P = uint8(P(:).'); KEK = uint8(KEK(:).');
            if mod(numel(P),8)~=0 || numel(P)<16
                error('AES-KW: P must be multiple of 8 and >=16 bytes.');
            end
            n = numel(P)/8;
            R = reshape(P,8,[]).';
            A = uint8(repmat(hex2dec('A6'),1,8)); % 64-bit IV

            for j=0:5
                for i=1:n
                    B = KMS.aes_encrypt_block([A R(i,:)], KEK);
                    T = uint64(n*j + i);
                    A = KMS.msb64_xor(B(1:8), T);
                    R(i,:) = B(9:16);
                end
            end
            C = [A reshape(R.',1,[])];
        end

        function P = aes_key_unwrap(C, KEK)
            C = uint8(C(:).'); KEK = uint8(KEK(:).');
            
            n = numel(C)/8 - 1;
            A = C(1:8);
            R = reshape(C(9:end),8,[]).';

            for j=5:-1:0
                for i=n:-1:1
                    T = uint64(n*j + i);
                    B = KMS.aes_decrypt_block([KMS.msb64_xor(A,T) R(i,:)], KEK);
                    A = B(1:8);
                    R(i,:) = B(9:16);
                end
            end
            IV = uint8(repmat(hex2dec('A6'),1,8));
            if ~isequal(A, IV), 
                error('AES-KW integrity check failed'); 
            end
            P = reshape(R.',1,[]);
        end

        % --- AES block adapters to David Hill's AES (hex-in/hex-out) ---
        function out = aes_encrypt_block(P, K)
            out_hex = Cipher(KMS.bytes_to_hex(K), KMS.bytes_to_hex(P));
            out     = KMS.hex_to_bytes(out_hex);
        end
        function out = aes_decrypt_block(C, K)
            out_hex = InvCipher(KMS.bytes_to_hex(K), KMS.bytes_to_hex(C));
            out     = KMS.hex_to_bytes(out_hex);
        end

        % ------------------- small helpers -------------------
        function out = msb64_xor(A, T)
            out = KMS.to_be64(bitxor(KMS.from_be64(A), T));
        end
        function u64 = from_be64(b)
            u64 = uint64(0);
            for i=1:8, u64 = bitor(bitshift(u64,8), uint64(b(i))); end
        end
        function b = to_be64(u64)
            b = zeros(1,8,'uint8');
            for i=0:7, b(8-i)=uint8(bitand(bitshift(u64,-(8*i)),255)); end
        end
        function hex = bytes_to_hex(u8)
            hex = reshape(dec2hex(u8).',1,[]);
        end
        function u8  = hex_to_bytes(hex)
            hex = lower(hex(:).'); u8 = uint8(sscanf(hex,'%2x').');
        end
    end
end
