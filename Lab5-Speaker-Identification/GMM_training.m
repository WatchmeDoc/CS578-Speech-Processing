function [means, variances, weights] = GMM_training(features, k)
%
% INPUT:
%   file: input filename of a wav file
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

mfccs = features.mfcc_arr;

[m, v, w] = v_gaussmix(mfccs,[], [], k, 'v');  %mel-scale Frequency Cepstral Coefficients
means = m;
variances = v;
weights = w;
   
end