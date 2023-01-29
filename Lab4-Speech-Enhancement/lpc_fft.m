function [sig_abs, sig_angle] = lpc_fft(sig, Fs)
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

Horizon = 30;  %30ms - window length
OrderLPC = 10; %order of LPC

Horizon = ceil(Horizon*Fs/1000);
Shift = ceil(Horizon/2);       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

% analysis frame-by-frame
for l=1:Nfr
    
  sigLPC = Win.*sig(slice);
  en = sum(sigLPC.^2); % get the short - term energy of the input
  
  % LPC analysis
  sig_abs(:,l) = (abs(fft(sigLPC))).^2;
  sig_angle(:,l) = angle(fft(sigLPC));
  
  slice = slice+Shift;   % move the frame  
end