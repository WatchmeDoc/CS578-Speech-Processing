function out = power_spectra(sig, Fs)
%
% INPUT:
%   sig: the input signal
%   Fs:  the sampling frequency
% OUTPUT:
%   out: the power spectra of the input signal

Horizon = 30;  %30ms - window length

Horizon = floor(Horizon*Fs/1000);
Shift = floor(Horizon/2);       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

% analysis frame-by-frame
for l=1:Nfr
    
  s = Win.*sig(slice);
 
  sigFFT(:,l) = (abs(fft(s))).^2;
  
  slice = slice+Shift;   % move the frame  
end

out = mean(sigFFT,2);