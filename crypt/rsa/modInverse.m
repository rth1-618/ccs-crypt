function inv = modInverse(e, phi)
% MODINVERSE  Modular multiplicative inverse
% inv * e ≡ 1 (mod phi)

    [g, x, ~] = egcd(e, phi);
    if g ~= 1
        error('modInverse: inverse does not exist');
    end
    inv = mod(x, phi);
end
