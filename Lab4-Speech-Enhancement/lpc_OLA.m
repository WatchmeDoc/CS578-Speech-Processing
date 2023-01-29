function out = lpc_OLA(s, clear, Fs)
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
Buffer = 0;    % initialization
Win = hanning(Horizon);  % analysis window

Lsig = length(s);
slice = 1:Horizon;
tosave = 1:Shift;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

% analysis frame-by-frame
for l=1:Nfr
     
  % LPC analysis
  clear_ifft = real(ifft(clear(:,l)));
  sigLPC = clear_ifft;
  
  % synthesis
  sigLPC(1:Shift) = sigLPC(1:Shift) + Buffer;  % Overlap and add
  out(tosave) = sigLPC(1:Shift);          % save the first part of the frame
  Buffer = sigLPC(Shift:Horizon);       % buffer the rest of the frame
  
  slice = slice+Shift;   % move the frame
  tosave = tosave+Shift;
  
end