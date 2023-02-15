function [qg] = scalar_quantization(G, B, Xmin, Xmax)
%
% INPUT:
%   G: The signal Gain
%   B: The number of Bits
%   Xmin: minimum value of G
%   Xmax: maximum value of G
% OUTPUT:
%   qg: Quantized value of G
%
% George Manos, Alexandros Angelakis
% CSD - CS578

% quantization levels
levels = 2^B;

% quantization step size
delta = (Xmax - Xmin)/levels;

% generating linearly spaced vector between Xmin and Xmax
% same output if we want to use the delta
xi = linspace(Xmin, Xmax, levels+1);

% in which space our G belongs to
indices = find(G <= xi);

if isempty(indices)
    i = levels + 1;
else 
    i = indices(1);
end

if i == 1
    i = 2;
end

% our quantized G by taking the mean
qg = (xi(i) + xi(i - 1)) / 2;
end