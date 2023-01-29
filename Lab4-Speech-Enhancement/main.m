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

% Calculating the magnitude and the phase of the FT of the noisy signal
[noisy_abs_fft, noisy_angle_fft] = lpc_fft(s_noise, fs);

% Removing the power spectra of the noise from the original noisy signal
clear_abs_fft = noisy_abs_fft - noise_power_spectra;
clear_abs_fft = max(clear_abs_fft, 0); % If noisy_abs_fft - noise_power_spectra < 0 set it to 0.

% Clear signal's FT in polar form
clear_s = sqrt(clear_abs_fft) .* exp(1i .* noisy_angle_fft);

% Overlapping and Add the inverse fourier transform of each frame
s_new = lpc_OLA(s_noise, clear_s, fs);

% Listen to the clear signal
soundsc(s_new, fs);
%% Wiener Filter