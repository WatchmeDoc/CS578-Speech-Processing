function out = lpc_spectral_subtraction(sig, noise, Fs)
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
    
  sigLPC = Win.*sig(slice);
  
  % LPC analysis
  sig_abs = abs(fft(sigLPC));
  sig_angle = angle(fft(sigLPC));
  
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