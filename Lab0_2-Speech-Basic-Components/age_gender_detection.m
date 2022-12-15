clear; close all;

frame_rate = 0.01;
frame_length = 0.03;

myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);

    % Reading the speech signal
    [s, fs] = audioread(fullFileName);
    
    % Remove mean value (DC component)
    s = s - mean(s);

    % Signal length
    D = length(s);

    % Frame length (30 ms, how many samples? )
    L = fs * frame_length;

    % Frame shift (10 ms, how many samples? )
    U = fs * frame_rate;

    % Window type (Hamming)
    win = hamming(L);

    % Number of frames
    Nfr = floor((D - L) / U) + 1;
    
    % Memory allocation (for speed)
    f_acf = zeros(1, Nfr);
    f_fft = zeros(1, Nfr);
    T = zeros(1, Nfr);
    
    % Number of FFT points for the FFT peak picking
    NFFT = 2048;
    
    VUS = vus_classification(s, fs);
    
    % Loop which calculates the speech features
    for i = 1:1:Nfr
        frame = s((i-1) * U + 1: (i-1) * U + L ) .* win; % a frame of speech windowed by the Hamming window
        if VUS(i) == 1.0
            f_acf(i) = acf_peak_picking(frame, fs);
            f_fft(i) = fft_peak_picking(frame, fs, NFFT);
        else
            f_acf(i) = 0;
            f_fft(i) = 0;
        end
        T(i) = L/2 + (i-1)*U; % Next analysis time instant
    end
    
    % Use this if interp1 causes errors
    % [t, index] = unique(T); % Keep only unique values of T
    f_acf_i = interp1(T, f_acf, 1:1:D, 'spline');
    f_fft_i = interp1(T, f_fft, 1:1:D, 'spline');
    
    
    % Taking the average of the pitch from all the frames for both methods
    f_acf_avg = mean(f_acf(f_acf > 0), 'all');
    f_fft_avg = mean(f_fft(f_fft > 0), 'all');
    
    
    % Classification for the age+gender detection using the f_fft_avg
    if f_fft_avg >= 70 && f_fft_avg <= 275
        if f_fft_avg < 160
            disp('Adult Male');
        elseif f_fft_avg < 275
            disp('Adult Female');
        end
    elseif f_fft_avg >= 275 && f_fft_avg <= 500
        disp('Child');
    end
    
    % Classification for the age+gender detection using the f_acf_avg
%     if f_acf_avg >= 70 && f_acf_avg <= 275
%         if f_acf_avg < 160
%             disp('Adult Male');
%         elseif f_acf_avg < 275
%             disp('Adult Female');
%         end
%     elseif f_acf_avg >= 275 && f_acf_avg <= 500
%         disp('Child');
%     end
    
    
    % Visualize
    figure;
    subplot(2,1,1);
    t = 0:1/fs:length(s)/fs-1/fs;
    plot(t, f_acf_i,'LineWidth', 2.5); hold on;
    plot(t, f_fft_i, 'LineWidth', 2.5); hold off;
    title(['Pitch estimation for ', baseFileName], 'Interpreter', 'none');
    legend('AutoCorr', 'FFT');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    
    subplot(2,1,2);
    plot(t, s/max(s), 'r');
    title(['Waveform for ', baseFileName], 'Interpreter', 'none');
    xlabel('Time (s)');
    
    grid;
    
end