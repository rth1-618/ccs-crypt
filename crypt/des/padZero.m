function out = padZero(inBytes, blockSize)
if nargin<2, blockSize = 8; end
n = numel(inBytes);
padLen = mod(-n, blockSize);
if padLen == 0, padLen = 0; end
out = uint8([inBytes(:); zeros(padLen,1,'uint8')]);
end

