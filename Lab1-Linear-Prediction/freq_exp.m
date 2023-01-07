function freq_exp(file)
%
% INPUT:
%   file: input filename of a wav file
% OUTPUT:
%   out: a vector contaning the output signal
%
% Example:
%
%   out = lpc_as('speechsample.wav');
%   [sig,fs]= wavread('speechsample.wav');
%   sound(out,fs);
%   sound(sig,fs);
%   sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo
%
%
% Yannis Stylianou
% CSD - CS 578
%

[sig, fs] = audioread(file);

Horizon = 30;  %30ms - window length
OrderLPC = 123; %order of LPC

Horizon = Horizon*fs/1000;
Shift = Horizon/2;       % frame size - step size
Win = hanning(Horizon);  % analysis window

Lsig = length(sig);
slice = 1:Horizon;
Nfr = floor((Lsig-Horizon)/Shift)+1;  % number of frames
NFFT = 2048;
freq = 0:fs/NFFT:fs/2-1/fs;

% analysis frame-by-frame
for l=1:Nfr
    
    sigLPC = Win.*sig(slice);
    
    % LPC analysis
    [r,lg] =  xcorr(sigLPC); % correlation
    r = r(lg>=0);
    a =  my_levinson(r,OrderLPC);  % LPC coef.
    G =  sqrt(sum(a .* r(1:OrderLPC + 1).'));  % gain
    
    % Voiced speech frame
    if l == 167
        [h,~] = freqz(G,a, 'whole', NFFT);
        X = fft(sigLPC, NFFT);
        
        figure;
        plot(freq, 20*log10(abs(h(1:NFFT/2))), 'LineWidth',2); grid;
        hold on;
        plot(freq, 20*log10(abs(X(1:NFFT/2))), 'LineWidth',1); grid;
        title(['Voiced Frame in Frequency Domain with orderLPC: ', num2str(OrderLPC)]);
        hold off;
        xlabel('Frequency (Hz)')
        ylabel('Amplitude (dB)')
        legend('Magnitude of LP filter', 'Magnitude of FFT of frame');
        
    end
   
    % Unvoiced speech frame
    if l == 1
        [h,~] = freqz(G,a, 'whole', NFFT);
        X = fft(sigLPC, NFFT);
        
        figure;
        plot(freq, 20*log10(abs(h(1:NFFT/2))), 'LineWidth',2); grid;
        hold on;
        plot(freq, 20*log10(abs(X(1:NFFT/2))), 'LineWidth',1); grid;
        title(['Unvoiced Frame in Frequency Domain with orderLPC: ', num2str(OrderLPC)]);
        hold off;
        xlabel('Frequency (Hz)')
        ylabel('Amplitude (dB)')
        legend('Magnitude of LP filter', 'Magnitude of FFT of frame');
    end
    slice = slice+Shift;   % move the frame
end