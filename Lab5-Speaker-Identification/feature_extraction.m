function out = feature_extraction(file)
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
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

out = cell(Nfr, 1); % initialization
% analysis frame-by-frame
for l=1:Nfr
    
  sigLPC = Win.*sig(slice);
  
  mfcc = v_melcepst(sigLPC,fs);  %mel-scale Frequency Cepstral Coefficients
  out{l} = mfcc;
  
  slice = slice+Shift;   % move the frame
  
end