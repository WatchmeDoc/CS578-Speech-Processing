clear; close all;

frame_rate = 0.01;
frame_length = 0.03;

myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.wav')); %gets all wav files in struct
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
    energy = zeros(1, Nfr+1);
    ZCr = zeros(1, Nfr+1);

    % Loop which calculates the speech features
    for i = 1:1:Nfr
        frame = s((i-1) * U + 1: (i-1) * U + L ) .* win; % a frame of speech windowed by the Hamming window
        energy(i) = 1 / L * sum(frame.^2); % calculate energy
        ZCr(i) =  1 / 2 * sum(abs(sign(frame(2:end)) - sign(frame(1:end-1)))); % calculate zero crossings
        T(i) = L/2 + (i-1)*U; % Next analysis time instant
    end

    % THRESHOLDS (you can play with it!)
    Ethres = mean(energy)/2;
    ZCRthres = (3/2)*mean(ZCr) - 0.3*std(ZCr);

    % Classification for each frame
    for i = 1:1:Nfr
        if energy(i) > Ethres
            % VOICED
            VUS(i) = 1.0;
        elseif ZCr(i) < ZCRthres
            % SILENCE
            VUS(i) = 0.0;
        elseif ZCr(i) > ZCRthres
            % UNVOICED
            VUS(i) = 0.5;
        end
    end
    % Interpolation with interp1
    VUSi = interp1(T, VUS, 1:1:D);

    % Visualize
    figure;
    t = 0:1/fs:length(s)/fs-1/fs;
    plot(t, VUSi,'LineWidth', 2.5);
    hold on; plot(t, s/max(s), 'r'); hold off;
    xlabel('Time (s)');
    ylim([-1.5 1.5]);
    title(['VUS discrimination for ', baseFileName], 'Interpreter', 'none');
    legend('VUS classification', 'Input Speech');
    grid;
end