function [g, x, y] = egcd(a, b)
% Extended GCD
% g = gcd(a,b), and ax + by = g

    if b == 0
        g = a;
        x = 1;
        y = 0;
    else
        [g, x1, y1] = egcd(b, mod(a,b));
        x = y1;
        y = x1 - floor(a/b)*y1;
    end
end
