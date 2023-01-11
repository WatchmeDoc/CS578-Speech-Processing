function a = rc_to_lpc(k, OrderLPC)
% Function that converts reflection coefficients to linear 
% prediction coefficients.
%
% INPUT:
%   LPC_Order: order of LPC 
%   k: the reflection coefficients vector
% OUTPUT:
%   a: the linear prediction coefficients of order OrderLPC
%
% Alexandros Angelakis csd4334
% George Manos csd4333
% CSD - CS 578

% matrix with linear prediction coefficients from order 1 to OrderLPC
LPCmatrix = zeros(OrderLPC, OrderLPC);

% Calculate the LPC vectors.
for p = 0:OrderLPC-1  
    for m = 1:p
       LPCmatrix(p+1, m) = LPCmatrix(p,m) + k(p+1)*LPCmatrix(p, p+1-m); 
    end
    LPCmatrix(p+1,p+1) = k(p+1);
end

% Find the coefficients of order OrderLPC
a = LPCmatrix(OrderLPC, :);
a = [1 a];

end

