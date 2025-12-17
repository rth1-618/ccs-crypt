function plainText = rsaDecryptText(cipherNums, d, n)

    nums = zeros(size(cipherNums));
    for i = 1:numel(cipherNums)
        nums(i) = powmod(cipherNums(i), d, n);
    end

    plainText = numbersToText(nums);
end
