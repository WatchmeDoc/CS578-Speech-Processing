%% Spectral Subtraction
close all; clear;

fprintf('-------------------\n');
fprintf('Speech Enhancement using Spectral Subtraction\n');

[s, ~] = audioread('furelise-1000z.wav');
[s_noisy, fs] = audioread('furelise-1000z-noise.wav');

% Listen to the noisy signal
soundsc(s_noisy, fs);
fprintf('Listening to the noisy signal\n');
pause(35);

% Extracting the white noise
noise = s_noisy(1:1000);

% Calculating the noise power spectra
noise_power_spectra = power_spectra(noise, fs);

% Spectral Subtraction for removing the noise
s_clean = spectral_subtraction(s_noisy, noise_power_spectra, fs);

% Listen to the clear signal
soundsc(s_clean, fs);
fprintf('Listening to the enhanced signal using Spectral Subtraction\n');

figure;
subplot(2,1,1); 
plot(s_clean); title('Enhanced Signal using Spectral Subtraction');
subplot(2,1,2); 
plot(s_noisy); title('Noisy Signal');

MSE = (1/size(s_noisy,1)) * sum((s_noisy - s_clean).^2);
fprintf('MSE between enhanced and noisy: %f\n', MSE);

figure;
subplot(2,1,1); 
plot(s_clean); title('Enhanced Signal using Spectral Subtraction');
subplot(2,1,2); 
plot(s); title('Clean Signal');

MSE = (1/size(s,1)) * sum((s - s_clean).^2);
fprintf('MSE between enhanced and clean: %f\n', MSE);

%% Wiener Filter
close all; clear;

fprintf('-------------------\n');
fprintf('Speech Enhancement using Wiener filtering\n');

[s, ~] = audioread('furelise-1000z.wav');
[s_noisy, fs] = audioread('furelise-1000z-noise.wav');

% Listen to the noisy signal
soundsc(s_noisy, fs);
fprintf('Listening to the noisy signal\n');
pause(35);

% Extracting the white noise
noise = s_noisy(1:1000);

% Calculating the noise power spectra
noise_power_spectra = power_spectra(noise, fs);

% Applying wiener filter
a = 0.5; % Smoothing parameter
s_clean = wiener_filter(s_noisy, noise_power_spectra, a, fs);
soundsc(s_clean, fs);
fprintf('Listening to the enhanced signal using the Wiener filter\n');
pause(35);

figure;
subplot(2,1,1); 
plot(s_clean); title('Enhanced Signal using Wiener filtering');
subplot(2,1,2); 
plot(s_noisy); title('Noisy Signal');

MSE = (1/size(s_noisy,1)) * sum((s_noisy - s_clean).^2);
fprintf('MSE between enhanced and noisy: %f with smoothing parameter: %f\n', MSE, a);

figure;
subplot(2,1,1); 
plot(s_clean); title('Enhanced Signal using Wiener filtering');
subplot(2,1,2); 
plot(s); title('Clean Signal');

MSE = (1/size(s,1)) * sum((s - s_clean).^2);
fprintf('MSE: %f with smoothing parameter: %f\n', MSE, a);

%% Wiener filtering with different smoothing parameters
close all; clear;

fprintf('-------------------\n');
fprintf('Speech Enhancement using Wiener filtering\n');

[s, ~] = audioread('furelise-1000z.wav');
[s_noisy, fs] = audioread('furelise-1000z-noise.wav');

% Listen to the noisy signal
soundsc(s_noisy, fs);
fprintf('Listening to the noisy signal\n');
pause(35);

% Extracting the white noise
noise = s_noisy(1:1000);

% Calculating the noise power spectra
noise_power_spectra = power_spectra(noise, fs);

% Applying wiener filter
a1 = 0.2; % Smoothing parameter
s_clean1 = wiener_filter(s_noisy, noise_power_spectra, a1, fs);
soundsc(s_clean, fs);
fprintf('Listening to the enhanced signal using the Wiener filter\n');
pause(35);

% Increasing the smoothing parameter
a2 = 0.8; % Smoothing parameter
s_clean2 = wiener_filter(s_noisy, noise_power_spectra, a2, fs);
soundsc(s_clean, fs);
fprintf('Listening to the enhanced signal using the Wiener filter\n');

figure;
subplot(2,1,1); 
plot(s_clean1); title(['Enhanced Signal using Wiener filtering with ? = ', num2str(a1)]);
subplot(2,1,2); 
plot(s_clean2); title(['Enhanced Signal using Wiener filtering with ? = ', num2str(a2)]);

%% Comparing SS with Wiener filtering
[s, ~] = audioread('furelise-1000z.wav');
[s_noisy, fs] = audioread('furelise-1000z-noise.wav');

% Extracting the white noise
noise = s_noisy(1:1000);

% Calculating the noise power spectra
noise_power_spectra = power_spectra(noise, fs);

% Spectral Subtraction for removing the noise
s_clean_SS = spectral_subtraction(s_noisy, noise_power_spectra, fs);

a = 0.5; % Smoothing parameter
s_clean_wiener = wiener_filter(s_noisy, noise_power_spectra, a, fs);

figure;
subplot(2,1,1); 
plot(s_clean_SS); title('Enhanced Signal using Spectral Subtraction');
subplot(2,1,2); 
plot(s_clean_wiener); title('Enhanced Signal using Wiener filtering');

%% George Manos voice
close all; clear;

fprintf('-------------------\n');
fprintf('Speech Enhancement using Spectral Subtraction\n');

[s, ~] = audioread('personal/stars_16k.wav');
[s_noisy, fs] = audioread('personal/stars_16k-noise.wav');
s = [zeros(1000,1); s];
% Listen to the noisy signal
soundsc(s_noisy, fs);
pause(6);

% Extracting the white noise
noise = s_noisy(1:1000);

% Calculating the noise power spectra
noise_power_spectra = power_spectra(noise, fs);

% Spectral Subtraction for removing the noise
s_clean = spectral_subtraction(s_noisy, noise_power_spectra, fs);

% Listen to the clear signal
soundsc(s_clean, fs);
pause(6);

figure;
subplot(2,1,1); 
plot(s_clean); title('Enhanced Signal using Spectral Subtraction');
subplot(2,1,2); 
plot(s); title('Clean Signal');

MSE = (1/size(s,1)) * sum((s - s_clean).^2);
fprintf('MSE: %f using Spectral Subtraction\n', MSE);

fprintf('-------------------\n');
fprintf('Speech Enhancement using Wiener filtering\n');

a = 0.5;
s_clean = wiener_filter(s_noisy, noise_power_spectra, a, fs);
soundsc(s_clean, fs);

figure;
subplot(2,1,1); 
plot(s_clean); title('Enhanced Signal using Wiener filtering');
subplot(2,1,2); 
plot(s); title('Clean Signal');

MSE = (1/size(s,1)) * sum((s - s_clean).^2);
fprintf('MSE: %f using Wiener filter\n', MSE);

%% Alexandros Angelakis voice
close all; clear;

fprintf('-------------------\n');
fprintf('Speech Enhancement using Spectral Subtraction\n');

[s, ~] = audioread('personal/truth_16k.wav');
s = [zeros(1000,1); s];
[s_noisy, fs] = audioread('personal/truth_16k-noise.wav');

% Listen to the noisy signal
soundsc(s_noisy, fs);
pause(4);

% Extracting the white noise
noise = s_noisy(1:1000);

% Calculating the noise power spectra
noise_power_spectra = power_spectra(noise, fs);

% Spectral Subtraction for removing the noise
s_clean = spectral_subtraction(s_noisy, noise_power_spectra, fs);

% Listen to the clear signal
soundsc(s_clean, fs);
pause(4);

figure;
subplot(2,1,1); 
plot(s_clean); title('Enhanced Signal using Spectral Subtraction');
subplot(2,1,2); 
plot(s); title('Clean Signal');

MSE = (1/size(s,1)) * sum((s - s_clean).^2);
fprintf('MSE: %f using Spectral Subtraction\n', MSE);

fprintf('-------------------\n');
fprintf('Speech Enhancement using Wiener filtering\n');

a = 0.5;
s_clean = wiener_filter(s_noisy, noise_power_spectra, a, fs);
soundsc(s_clean, fs);

figure;
subplot(2,1,1); 
plot(s_clean); title('Enhanced Signal using Wiener filtering');
subplot(2,1,2); 
plot(s); title('Clean Signal');

MSE = (1/size(s,1)) * sum((s - s_clean).^2);
fprintf('MSE: %f using Wiener filter\n', MSE);

