function [f_0] = acf_peak_picking(frame, fs)
% acf_peak_picking uses short-time autocorrelation method to estimate and
% return the provided speech frame's pitch (fundamental frequency)
%
% George Manos, Alexandros Angelakis
% CSD - CS578

N = length(frame);
corr = xcorr(frame);
pos_corr = corr(N:2*N - 1);
up_thresh = 1/70;
low_thresh = 1/500;

[pks, locs] = findpeaks(pos_corr, fs);

valid_locs = locs(locs >= low_thresh & locs <= up_thresh);
valid_peaks = pks(locs >= low_thresh & locs <= up_thresh);

[~, argmax] = max(valid_peaks);
f_0 = 1 / valid_locs(argmax);