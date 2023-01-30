function out = power_spectra(sig, Fs)

Horizon = 30;  %30ms - window length

Horizon = ceil(Horizon*Fs/1000);
Shift = ceil(Horizon/2);       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

% analysis frame-by-frame
for l=1:Nfr
    
  sigLPC = Win.*sig(slice);
  
  [acf, lags] = xcorr(sigLPC);
  acf = acf(lags >= 0);
  sigFFT(:,l) = (abs(fft(acf))).^2;
  
  slice = slice+Shift;   % move the frame  
end

out = mean(sigFFT,2);