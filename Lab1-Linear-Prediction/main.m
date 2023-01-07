%% normal
close all; clear;

file = 'speechsample.wav';
out = lpc_as_toyou(file);
[sig, fs] = audioread(file);

figure; 
subplot(211); plot(sig); title('Original signal');
subplot(212); plot(out); title('Synthesized signal');

MSE = (1/size(sig,1)) * sum((sig - out).^2);

soundsc(out, fs);
%sound(out,fs);
%sound(sig,fs);
% sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo

%% freqz
close all; clear;

file = 'speechsample.wav';
freq_exp(file);


%% whisper
close all; clear;

file = 'speechsample.wav';
out = whisper_exp(file);
[sig, fs] = audioread(file);

soundsc(out, fs);
%sound(out,fs);
%sound(sig,fs);
% sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo


%% robot
close all; clear;

file = 'speechsample.wav';
out = robot_exp(file);
[sig, fs] = audioread(file);

soundsc(out, fs);
%sound(out,fs);
%sound(sig,fs);
% sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo

%% George Manos voice
close all; clear;

file = 'stars_16k.wav';
out = lpc_as_toyou(file);
[sig, fs] = audioread(file);

figure; 
subplot(211); plot(sig); title('Original signal');
subplot(212); plot(out); title('Synthesized signal');

MSE = (1/size(sig,1)) * sum((sig - out).^2);

soundsc(out, fs);

%% Alexandros Angelakis voice
close all; clear;

file = 'truth_16k.wav';
out = lpc_as_toyou(file);
[sig, fs] = audioread(file);

figure; 
subplot(211); plot(sig); title('Original signal');
subplot(212); plot(out); title('Synthesized signal');

MSE = (1/size(sig,1)) * sum((sig - out).^2);

soundsc(out, fs);


