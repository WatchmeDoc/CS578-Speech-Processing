function freq_exp(file)
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

[sig, fs] = audioread(file);

Horizon = 30;  %30ms - window length
OrderLPC = 10; %order of LPC
Buffer = 0;    % initialization
out = zeros(size(sig)); % initialization

Horizon = Horizon*fs/1000;
Shift = Horizon/2;       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
tosave = 1:Shift;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames
NFFT = 2048;
freq = 0:fs/NFFT:fs/2-1/fs;

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
 
  
  if l == 125
    [h,w] = freqz(1,a, 'whole', NFFT);
    X = fft(sigLPC, NFFT);
    
    figure;
    plot(freq, 20*log10(abs(h(1:NFFT/2)))); grid;
    hold on;
    plot(freq, 20*log10(abs(X(1:NFFT/2)))); grid;
    hold off;
  end
  
end