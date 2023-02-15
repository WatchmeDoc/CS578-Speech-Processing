function probability = gauss_proba(mu, sigma, x)
%
% INPUT:
%   mu: gaussian mixture mu parameter, 1xN
%   sigma: covariance matrix, NxN
%   x: input vector, 1xN
% OUTPUT:
%   out: the probability of the multivariate gaussian
%
% George Manos, Alexandros Angelakis
% CSD - CS 578
%
d = length(x);
if (isvector(sigma))
    N = abs(sigma);
else
    N = det(sigma);
end
probability = 1 / (sqrt(2*pi)^d * sqrt(N)) * exp(-1/2 * ((x - mu) / sigma) * (x - mu).');
   
end