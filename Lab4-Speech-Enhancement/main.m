%% Spectral Subtraction
close all; clear;

[s, ~] = audioread('furelise-1000z.wav');
[s_noise, fs] = audioread('furelise-1000z-noise.wav');

soundsc(s_noise, fs);
pause(35);

noise = s_noise(1:1000);
noise_power_spectra = lpc_power_spectra(noise, fs);

[noisy_abs_fft, noisy_angle_fft] = lpc_fft(s_noise, fs);

clear_abs_fft = noisy_abs_fft - noise_power_spectra;
clear_abs_fft = max(clear_abs_fft, 0); % If noisy_abs_fft - noise_power_spectra < 0 set it to 0.

clear_s = sqrt(clear_abs_fft) .* exp(1i .* noisy_angle_fft);

s_new = lpc_OLA(s_noise, clear_s, fs);
soundsc(s_new, fs);
%% Wiener Filter