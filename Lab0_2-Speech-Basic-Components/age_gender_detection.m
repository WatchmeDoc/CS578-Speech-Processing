clear; close all;

frame_rate = 0.01;
frame_length = 0.03;

myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*-pout-*.wav')); %gets all wav files in struct
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

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
    f0 = zeros(1, Nfr+1);
    
    % Loop which calculates the speech features
    for i = 1:1:Nfr
        frame = s((i-1) * U + 1: (i-1) * U + L ) .* win; % a frame of speech windowed by the Hamming window
        f0(i) = 0; % CALL FUNCTION THAT DOES THE PEAK PICKING
        T(i) = L/2 + (i-1)*U; % Next analysis time instant
    end
    
    % Use this if interp1 causes errors
    % [t, index] = unique(T); % Keep only unique values of T
    f0_i = interp1(T, f0, 1:1:D, 'method', 'spline');
    
    % Visualize
    figure;
    t = 0:1/fs:length(s)/fs-1/fs;
    plot(t, f0_i,'LineWidth', 2.5);
    hold on; plot(t, s/max(s), 'r'); hold off;
    xlabel('Time (s)');
    ylim([-1.5 1.5]);
    title(['Pitch estimation for ', baseFileName], 'Interpreter', 'none');
    legend('Pitch contour', 'Input Speech');
    grid;
end