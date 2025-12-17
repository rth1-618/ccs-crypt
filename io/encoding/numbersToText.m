function txt = numbersToText(nums)
% Convert numeric vector back to text

    nums = uint8(nums);
    txt = char(nums(:)');
end
