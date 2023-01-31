%% Spectral Subtraction
close all; clear;

[s, ~] = audioread('furelise-1000z.wav');
[s_noisy, fs] = audioread('furelise-1000z-noise.wav');

% Listen to the noisy signal
soundsc(s_noisy, fs);
pause(35);

% Extracting the white noise
noise = s_noisy(1:1000);

% Calculating the noise power spectra
noise_power_spectra = power_spectra(noise, fs);

% Spectral Subtraction for removing the noise
s_clean = spectral_subtraction(s_noisy, noise_power_spectra, fs);

% Listen to the clear signal
soundsc(s_clean, fs);

%% Wiener Filter
close all; clear;

[s, ~] = audioread('furelise-1000z.wav');
[s_noisy, fs] = audioread('furelise-1000z-noise.wav');

% Listen to the noisy signal
% soundsc(s_noisy, fs);
% pause(35);

% Extracting the white noise
noise = s_noisy(1:1000);

% Calculating the noise power spectra
noise_power_spectra = power_spectra(noise, fs);

% Applying wiener filter
s_clean = wiener_filter(s_noisy, noise_power_spectra, fs);
soundsc(s_clean, fs);
plot(s_clean);