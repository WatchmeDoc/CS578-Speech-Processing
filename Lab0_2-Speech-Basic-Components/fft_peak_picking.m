function [f_0] = fft_peak_picking(frame, fs, NFFT)
% fft_peak_picking uses the STFT of the signal and chooses the first 'highest' peak and
% return the provided speech frame's pitch (fundamental frequency)

freq = [0:fs/NFFT:fs/2-1/fs];
max_freq = 500;
min_freq = 70;

X = abs(fft(frame, NFFT));
X1 = 20*log10(X(1:NFFT/2));

[pks, locs] = findpeaks((X1), freq);

% A child's pitch varies from 300 to 500 Hz max.
valid_locs = locs(locs >= min_freq & locs <= max_freq);
valid_peaks = pks(locs >= min_freq & locs <= max_freq);
valid_peaks = find(valid_peaks > 0);

f_0 = valid_locs(valid_peaks(1));