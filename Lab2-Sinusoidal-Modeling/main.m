clear; close all;

[s, fs] = audioread('arctic_bdl1_snd_norm.wav');
soundsc(s, fs);
pause(4);

[Y, SNR] = SinM_test_hy578(s, fs);

soundsc(Y, fs);
y_padded = [Y; zeros(length(s) - length(Y), 1)];
figure;
subplot(211); plot(s); title('Original signal');
subplot(212); plot(y_padded); title('Synthesized signal');

MSE = (1/size(s,1)) * sum((s - y_padded).^2);
fprintf('MSE: %f\n', MSE);
figure;
plot(SNR); title('SNR per frame'); xlabel('frame number'); ylabel('SNR (DB)');
