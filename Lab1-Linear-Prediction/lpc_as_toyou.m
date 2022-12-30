function out = lpc_as_toyou(file)
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

[sig, Fs] = audioread(file);

Horizon = 30;  %30ms - window length
OrderLPC = 1; %order of LPC
Buffer = 0;    % initialization
out = zeros(size(sig)); % initialization

Horizon = Horizon*Fs/1000;
Shift = Horizon/2;       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
tosave = 1:Shift;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

% analysis frame-by-frame
for l=1:Nfr
    
  sigLPC = Win.*sig(slice);
  en = sum(sigLPC.^2); % get the short - term energy of the input
  
  % LPC analysis
  [r,lg] =  xcorr(sigLPC); % correlation
  r = r(lg>=0);
  a =  my_levinson(r,OrderLPC);  % LPC coef.
  G =  sqrt(sum(a .* r(1:OrderLPC + 1).'));  % gain
  ex = filter(a,1,sigLPC);  % inverse filter
  
  % synthesis
  s = filter(G,a, ex);
  ens = sum(s.^2);   % get the short-time energy of the output
  g = sqrt(en/ens);  % normalization factor
  s  = s*g;          % energy compensation
  s(1:Shift) = s(1:Shift) + Buffer;  % Overlap and add
  out(tosave) = s(1:Shift);          % save the first part of the frame
  Buffer = s(Shift+1:Horizon);       % buffer the rest of the frame
  
  slice = slice+Shift;   % move the frame
  tosave = tosave+Shift;
  
end