function [k,g] = lpc_to_rc(coeff, OrderLPC)
% Function that converts linear prediction coefficients to 
% reflection coefficients.
%
% INPUT:
%   OrderLPC: order of LPC 
%   coeff: the linear prediction coefficients of order OrderLPC
% OUTPUT:
%   k: the reflection coefficients vector
%   g: the companding reflection coefficients vector
%
% Alexandros Angelakis csd4334
% George Manos csd4333
% CSD - CS 578

% reflection coefficients
k = zeros(1, OrderLPC);

% all the LPC vectors from order 1 to OrderLPC
a = zeros(OrderLPC, OrderLPC);

% Remove the first column of coeff
coeff(:, 1) = [];

% initialize the last row with our coefficients of order OrderLPC
a(OrderLPC, :) = coeff;

for p = OrderLPC:-1:2
    k(p) = a(p, p);
    F = 1 - k(p)^2;
    
    for m = 1:p-1
       a(p-1, m) = (a(p,m)/F) - ((k(p)*a(p, p-m))/F);
    end
    
end

k(1) = a(1,1);

g = log10((1 - k)./(1 + k));

end

