function probability = gauss_proba(mu, sigma, x)
%
% INPUT:
%   mu: gaussian mixture mu parameter, 1xN
%   sigma: covariance matrix, NxN
%   x: input vector, 1xN
% OUTPUT:
%   out: a vector contaning the output signal
%
% Example:
%   
%   out = lpc_as('speechsample.wav');
%   [sig,fs]= wavread('speechsample.wav');
%   sound(out,fs);
%   sound(sig,fs);
%   sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo
%
%
% Yannis Stylianou
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