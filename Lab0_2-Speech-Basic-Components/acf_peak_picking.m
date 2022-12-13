function [f_0] = acf_peak_picking(frame, fs)
% acf_peak_picking uses short-time autocorrelation method to estimate and
% return the provided speech frame's pitch (fundamental frequency)

N = length(frame);
corr = xcorr(frame);
pos_corr = corr(N:2*N - 1);
up_thresh = round(1/70 * fs);
low_thresh = round(1/500 * fs);

[pks, locs] = findpeaks(pos_corr(low_thresh: up_thresh), fs);

[~, argmax] = max(pks);
t_0 = locs(argmax) + low_thresh / fs;
f_0 = 1 / t_0;