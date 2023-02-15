function out = wiener_filter(sig, Sb, a, Fs)
%
% INPUT:
%   sig: the signal we want to enhance using the wiener filter
%   Sb:  the noise power spectra
%   a:   the smoothing parameter
%   Fs:  the sampling frequency
% OUTPUT:
%   out: the enhanced signal
%
% George Manos, Alexandros Angelakis
% CSD - CS578

Horizon = 30;  %30ms - window length
Buffer = 0;    % initialization
out = zeros(size(sig)); % initialization

Horizon = floor(Horizon*Fs/1000);
Shift = floor(Horizon/2);       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
tosave = 1:Shift;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames

% Initializations
s = Win.*sig(slice);
spectral_subtraction = abs(fft(s)).^2 - Sb;
spectral_subtraction = max(spectral_subtraction, 0); % if sig_abs.^2 - noise < 0 set it to 0
Sx = spectral_subtraction;
smoothed_Sx = Sx;
H = smoothed_Sx ./ (smoothed_Sx + Sb);

% analysis frame-by-frame
for l=1:Nfr
   
  s = Win.*sig(slice);
  
  % analysis
  sig_fft = fft(s);
  sig_abs = abs(sig_fft);
  sig_angle = angle(sig_fft);
    
  X = sig_fft .* H;
  Sx = max(abs(sig_fft).^2 - Sb, 0);
  smoothed_Sx = a * smoothed_Sx + (1-a) * Sx;
  H = smoothed_Sx ./ (smoothed_Sx + Sb);

  clean_sig = abs(X) .* exp(1i * sig_angle);
  clean_sig = real(ifft(clean_sig));
  
  % synthesis
  clean_sig(1:Shift) = clean_sig(1:Shift) + Buffer;  % Overlap and add
  out(tosave) = clean_sig(1:Shift);          % save the first part of the frame
  Buffer = clean_sig(Shift+1:Horizon);       % buffer the rest of the frame
  
  slice = slice+Shift;   % move the frame
  tosave = tosave+Shift;
  
end