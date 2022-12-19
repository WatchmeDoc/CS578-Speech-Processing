[sig, Fs] = audioread('speechsample.wav');

Horizon = 30;  %30ms - window length
OrderLPC=24;   %order of LPC
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
  r =  xcorr(sigLPC); % correlation
  a =  lpc(r,OrderLPC);  % LPC coef.
  tmp = 0;
  for k = 1:OrderLPC
      tmp = tmp + a(k+1) .* r(k);
  end
  G =  sqrt(r(1) - tmp);  % gain
  ex = filter(1,a,sigLPC);  % inverse filter

  % synthesis
  s = filter(G,a, ex);
  ens = sum(s.^2);   % get the short-time energy of the output
  g = sqrt(en/ens);  % normalization factor
  s  =s*g;           % energy compensation
  s(1:Shift) = s(1:Shift) + Buffer;  % Overlap and add
  out(tosave) = s(1:Shift);           % save the first part of the frame
  Buffer = s(Shift+1:Horizon);       % buffer the rest of the frame
  
  slice = slice+Shift;   % move the frame
  tosave = tosave+Shift;
  
end

soundsc(out);

