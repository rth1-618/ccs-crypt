%place a png file and rename it peppers in root folder
img = imread('peppers.png');
[inBytes, meta] = imageToBytes(img);
ctBytes = desEncryptECB(inBytes, uint8('ABCDEFG'));
encImg = bytesToImage(ctBytes, meta); % encrypted image (noise)
decBytes = desDecryptECB(ctBytes, uint8('ABCDEFG'));
origImg = bytesToImage(decBytes, meta);
% verify isequal(origImg, img) possibly true (if meta preserved)


% text example
plain = 'Hello DES!';
key7 = 'ABCDEFG';       % 7 chars
ct = desEncryptECB(uint8(plain), key7);
b64 = matlab.net.base64encode(ct);
pt = bytesToText(desDecryptECB(matlab.net.base64decode(b64), key7));
disp(pt);  % should be 'Hello DES!' (may remove trailing zeros)
