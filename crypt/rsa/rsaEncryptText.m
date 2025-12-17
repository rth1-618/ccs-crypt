function cipherNums = rsaEncryptText(plainText, e, n)
% RSA encryption per character

    nums = textToNumbers(plainText);
    cipherNums = zeros(size(nums));

    for i = 1:numel(nums)
        cipherNums(i) = powmod(nums(i), e, n);
    end
end
