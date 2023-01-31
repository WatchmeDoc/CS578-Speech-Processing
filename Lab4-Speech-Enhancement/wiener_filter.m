function out = wiener_filter(sig, noise, Fs)

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
a = 0.5;
wiener_filter = zeros(length(Win), Nfr);
Sx = zeros(length(Win), Nfr);

% analysis frame-by-frame
for l=1:Nfr
   
  s = Win.*sig(slice);
  
  % analysis
  sig_fft = fft(s);
  sig_abs = abs(sig_fft);
  sig_angle = angle(sig_fft);
  
  % Initialization of wiener filter with spectral subtraction
  if l == 1   
      spectral_subtraction = sig_abs.^2 - noise;
      spectral_subtraction = max(spectral_subtraction, 0); % if sig_abs.^2 - noise < 0 set it to 0
      Sx(:,l) = spectral_subtraction;
  else
      X = sig_fft .* wiener_filter(:,l-1);
      Sx(:,l) = ((abs(X)).^2);
      Sx(:,l) = a * Sx(:,l-1) + (1-a) * Sx(:,l);
  end
  
  wiener_filter(:,l) = Sx(:,l) ./ (Sx(:,l) + noise);
  clean_sig = sqrt(Sx(:,l)) .* exp(1i * sig_angle);
  clean_sig = real(ifft(clean_sig));
  
  % synthesis
  clean_sig(1:Shift) = clean_sig(1:Shift) + Buffer;  % Overlap and add
  out(tosave) = clean_sig(1:Shift);          % save the first part of the frame
  Buffer = clean_sig(Shift:Horizon);       % buffer the rest of the frame
  
  slice = slice+Shift;   % move the frame
  tosave = tosave+Shift;
  
end