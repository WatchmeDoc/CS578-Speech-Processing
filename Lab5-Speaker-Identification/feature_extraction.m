function mfcc = feature_extraction(file)
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

[sig, fs] = audioread(file);

Horizon = 20;  %window length

Horizon = Horizon*fs/1000;
Shift = 5;               % step size

cesptral_coeff = 5;

mfcc = v_melcepst(sig,fs, 'M', cesptral_coeff, floor(3*log(fs)), Horizon, Shift);  %mel-scale Frequency Cepstral Coefficients

end