%% Spectral Subtraction
close all; clear;

[s, ~] = audioread('furelise-1000z.wav');
[s_noise, fs] = audioread('furelise-1000z-noise.wav');

% Listen to the noisy signal
soundsc(s_noise, fs);
pause(35);

% Extracting the white noise
noise = s_noise(1:1000);

% Calculating the noise power spectra
noise_power_spectra = lpc_power_spectra(noise, fs);

% Spectral Subtraction for removing the noise
s_clean = lpc_spectral_subtraction(s_noise, noise_power_spectra, fs);

% Listen to the clear signal
soundsc(s_clean, fs);

%% Wiener Filter