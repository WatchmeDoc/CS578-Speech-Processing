clear; close all;

[s, fs] = audioread('arctic_bdl1_snd_norm.wav');
soundsc(s, fs);
pause(4);

[Y, SNR] = SinM_test_hy578(s, fs);

soundsc(Y, fs);
fprintf('SNR: %f\n', SNR);