function [G, comp_coeffs] = speech_analysis(file, OrderLPC)
%
% INPUT:
%   file: input filename of a wav file
% OUTPUT:
%   G : the gains of each frame of the wav file
%
[sig, Fs] = audioread(file);

Horizon = 30;  % 30ms - window length

Horizon = Horizon*Fs/1000;
Shift = Horizon/2;       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames
G = zeros(1,Nfr); % number of gains
comp_coeffs = cell(Nfr, 1);

% analysis frame-by-frame
for l=1:Nfr
    
  sigLPC = Win.*sig(slice);
  
  % LPC analysis
  [r,lg] =  xcorr(sigLPC); % correlation
  r = r(lg>=0);
  [a, g] =  my_levinson(r,OrderLPC);  % LPC coef.
    
  G(l) =  sqrt(sum(a .* r(1:OrderLPC + 1).'));  % gain
  comp_coeffs{l} = g;
  
  slice = slice+Shift;   % move the frame  
end