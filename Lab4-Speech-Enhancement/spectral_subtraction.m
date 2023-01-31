function out = spectral_subtraction(sig, noise, Fs)

Horizon = 30;  %30ms - window length
Buffer = 0;    % initialization
out = zeros(size(sig)); % initialization

Horizon = round(Horizon*Fs/1000);
Shift = round(Horizon/2);       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
tosave = 1:Shift;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

% analysis frame-by-frame
for l=1:Nfr
    
  s = Win.*sig(slice);
  
  % analysis
  sig_abs = abs(fft(s));
  sig_angle = angle(fft(s));
  
  spectral_subtraction = sig_abs.^2 - noise;
  spectral_subtraction = max(spectral_subtraction, 0); % if sig_abs.^2 - noise < 0 set it to 0
  
  % writing it in polar form
  clear_sig = sqrt(spectral_subtraction) .* exp(1i * sig_angle);
  clear_sig = real(ifft(clear_sig));
  
  % synthesis
  clear_sig(1:Shift) = clear_sig(1:Shift) + Buffer;  % Overlap and add
  out(tosave) = clear_sig(1:Shift);          % save the first part of the frame
  Buffer = clear_sig(Shift:Horizon);       % buffer the rest of the frame
  
  slice = slice+Shift;   % move the frame
  tosave = tosave+Shift;
  
end