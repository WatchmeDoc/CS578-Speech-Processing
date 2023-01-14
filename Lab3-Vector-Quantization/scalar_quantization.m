function [qg] = scalar_quantization(G, B, Xmin, Xmax)
%
% INPUT:
%   G: The signal Gain
%   B: The number of Bits
%   min: minimum value of G
%   max: maximum value of G
% OUTPUT:
%   qg: Quantized value of G

% quantization levels
levels = 2^B;

% quantization step size
delta = (Xmax - Xmin)/levels;

% generating linearly spaced vector between Xmin and Xmax
% same output if we want to use the delta
xi = linspace(Xmin, Xmax, levels+1);

% in which space our G belongs to
indices = find(G <= xi);
i = indices(1);

if i == 1
    i = 2;
end

% our quantized G by taking the mean
qg = (xi(i) + xi(i - 1)) / 2;

end