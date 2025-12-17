function [A,B,SA,SB] = diffieHellman(p,g,a,b)
% DIFFIEHELLMAN   Educational DH using modular exponentiation

    A   = powmod(g, a, p);
    B   = powmod(g, b, p);

    SA = powmod(B, a, p);
    SB = powmod(A, b, p);
end
