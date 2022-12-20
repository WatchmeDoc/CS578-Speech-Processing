function a = my_levinson(corr_sig, p)
%
% INPUT:
%   corr_sig: autocorrelation of the frame
%   p: the order of LPC
% OUTPUT:
%   a: LPC coefficients in form [1, -a]
    I = zeros(p+1, p+1);
    E = zeros(p+1, 1);
    E(1) = corr_sig(1);
    k = zeros(p+1, 1);
    for m=1:p
        i = m + 1;
        res = 0;
        for n=1:m-1
            j = n + 1;
            res = res + I(i - 1, j) * corr_sig(i-j);
        end
        k(i) = (corr_sig(i) - res) / E(i - 1);
        I(i, i) = k(i);
        for n=1:m-1
            j = n + 1;
            I(i, j) = I(i - 1, j) - k(i) * I(i - 1, i-j);
        end
        E(i) = (1 - k(i)^2) * E(i - 1);
    end
    a = I(p+1, 2:end);
    a = [1, -a];

end