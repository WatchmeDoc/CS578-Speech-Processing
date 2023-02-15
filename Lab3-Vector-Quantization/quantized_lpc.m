function out = quantized_lpc(file, OrderLPC, num_bits, min_g, max_g, vq_codebook)
%
% INPUT:
%   file:     input filename of a wav file
%   OrderLPC: the order of the LPC
%   num_bits: the number of bits for quantization
%   min_g:    minimum value for the scalar quantization
%   max_g:    maximum value for the scalar quantization
%   vq_codebook: the codebook for the vector quantization
%
% OUTPUT:
%   out: a vector contaning the output signal
%
% George Manos, Alexandros Angelakis
% CSD - CS578
%
[sig, Fs] = audioread(file);

Horizon = 30;  % 30ms - window length
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
  [r,lg] =  xcorr(sigLPC); % correlation
  r = r(lg>=0);
  [a,g] =  my_levinson(r,OrderLPC);  % LPC coef.
  G =  sqrt(sum(a .* r(1:OrderLPC + 1).'));  % gain
  ex = filter(a,1,sigLPC);  % inverse filter
  % TODO Check if quantized "a" coeffs should be applied to excitation
  % signal or not
  
  
  q_coeffs = vector_quantization(g, vq_codebook);
  k = (1 - 10.^(q_coeffs))./(1 + 10.^(q_coeffs)); % Inverse companding function
  a_new = rc_to_lpc(k, OrderLPC); % LPC coef.
  
  qg = scalar_quantization(G, num_bits, min_g, max_g);
  
  % synthesis
  s = filter(qg, a_new, ex);
  % ens = sum(s.^2);   % get the short-time energy of the output
  % g = sqrt(en/ens);  % normalization factor
  % s  = s*g;          % energy compensation
  s(1:Shift) = s(1:Shift) + Buffer;  % Overlap and add
  out(tosave) = s(1:Shift);          % save the first part of the frame
  Buffer = s(Shift+1:Horizon);       % buffer the rest of the frame
  
  slice = slice+Shift;   % move the frame
  tosave = tosave+Shift;
  
end