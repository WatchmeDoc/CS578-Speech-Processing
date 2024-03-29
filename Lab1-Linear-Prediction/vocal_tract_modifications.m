function out = vocal_tract_modifications(file)
%
% INPUT:
%   file: input filename of a wav file
% OUTPUT:
%   out: a vector contaning the output signal
%
% George Manos, Alexandros Angelakis
% CSD - CS578

[sig, Fs] = audioread(file);

Horizon = 30;  %30ms - window length
OrderLPC = 28; %order of LPC
Buffer = 0;    % initialization
out = zeros(size(sig)); % initialization

Horizon = Horizon*Fs/1000;
Shift = Horizon/2;       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
tosave = 1:Shift;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames
mod_coeff = 1.2; % percentage

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
  
  % Find poles and split in imaginary and real ones
  poles = roots(a);
  img_poles = poles(imag(poles) ~= 0);
  real_poles = poles(imag(poles) == 0);
  % Find the max magnitude imaginary ones (assume formants)
  [B, I] = maxk(abs(img_poles), 6);
  % Find their frequency and tamper with it
  frequencies = angle(img_poles(I));
  mod_freq = frequencies * mod_coeff;
  % Replace them in the original list :)
  img_poles(I, :) = B .* exp(1i*mod_freq);
  all_poles = [real_poles; img_poles];
  a = poly(all_poles);
  
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