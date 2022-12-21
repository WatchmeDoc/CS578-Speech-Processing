%% normal
file = 'speechsample.wav';
out = lpc_as_toyou(file);
[sig, fs] = audioread(file);

soundsc(out, fs);
%sound(out,fs);
%sound(sig,fs);
% sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo

%% whisper
file = 'speechsample.wav';
out = whisper_exp(file);
[sig, fs] = audioread(file);

soundsc(out, fs);
%sound(out,fs);
%sound(sig,fs);
% sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo


%% robot
file = 'speechsample.wav';
out = robot_exp(file);
[sig, fs] = audioread(file);

soundsc(out, fs);
%sound(out,fs);
%sound(sig,fs);
% sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo
