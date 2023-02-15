function mfcc = feature_extraction(file)
%
% INPUT:
%   file: input filename of a wav file
% OUTPUT:
%   out: the mel cepstrum of the file
%
% George Manos, Alexandros Angelakis
% CSD - CS 578
%

[sig, fs] = audioread(file);

Horizon = 20;  %window length

Horizon = Horizon*fs/1000;
Shift = 5;               % step size

cesptral_coeff = 5;

mfcc = v_melcepst(sig,fs, 'M', cesptral_coeff, floor(3*log(fs)), Horizon, Shift);  %mel-scale Frequency Cepstral Coefficients

end