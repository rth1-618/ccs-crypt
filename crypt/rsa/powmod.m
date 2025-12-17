function r = powmod(base, exp, modn)
% POWMOD  Fast modular exponentiation
% r = base^exp mod modn
% Uses binary (square-and-multiply) method

    if modn == 1
        r = 0;
        return;
    end

    r = 1;
    base = mod(base, modn);

    while exp > 0
        if bitand(exp,1)
            r = mod(r * base, modn);
        end
        exp = floor(exp / 2);
        base = mod(base * base, modn);
    end
end
