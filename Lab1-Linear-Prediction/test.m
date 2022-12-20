file = 'speechsample.wav';
out = lpc_as_toyou(file);
[sig, fs] = audioread(file);

%sound(out,fs);
%sound(sig,fs);
sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo

