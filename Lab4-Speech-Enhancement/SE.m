% code to generate the noisy signal

% read the file: it has 1000 zero samples in the beginning
[s,fs] = audioread('data/furelise-1000z.wav');

% listen to the file
soundsc(s,fs); % nice ee?

% generate noise; gaussian - zero mean, variance is one
Noise = randn(size(s));

% set the (global) SNR in dB
SNR=10;

% find the multiplicative coeff for the noise
Es = sum(s.^2);
En = sum(Noise.^2);
a = sqrt(10^(-SNR/20)*Es/En);

sn = s+a*Noise;

% listen to the noisy file
soundsc(sn,fs); % bad ee?

% normalize it in order to save it as wav
sn = sn/(1.1*max(abs(sn)));

% save it for your work:
audiowrite(sn,fs,16,'furelise-1000z-noise.wav');

% so, clean it with Spectral subtraction and Wiener filtering.