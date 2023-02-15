function [means, variances, weights] = GMM_training(features, k)
%
% INPUT:
%   file: the features of a speech signal (mel cepstrum)
%   k:    number of gaussian mixtures
% OUTPUT:
%   means:     mixture means, one row per mixture
%   variances: mixture variances, one row per mixture
%   weights:   mixture weights, one per mixture
%
% George Manos, Alexandros Angelakis
% CSD - CS 578
%

mfccs = features.mfcc_arr;

[m, v, w] = v_gaussmix(mfccs,[], [], k, 'v');  %mel-scale Frequency Cepstral Coefficients

means = m;
variances = v;
weights = w;
if(ndims(v) == 2)
    [k, p] = size(v);
    variances = zeros(p, p, k);
    for i = 1:k
        variances(:, :, i) = v(i, :) .* eye(p, p);
    end
end
   
end