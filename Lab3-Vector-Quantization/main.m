%% Scalar Quantization
clear; close all;
fprintf('Choose Training Data Directory:\n');
rootdir = uigetdir('.', 'Choose Training Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

% the gains of all the speech signals
G = cell(length(filelist), 1);

%% For each train speech signal store all its gains
for k = 1:length(filelist)
    baseFileName = filelist(k).name;
    fullFileName = [filelist(k).folder, '\', baseFileName];
    fprintf(1, 'Now reading %s\n', baseFileName);

    G{k} = SQ_analysis(fullFileName);
end

% Finding the max and min of all gains
max_G = max(G{1});
min_G = min(G{1});

for k = 2:length(G)
    if max(G{k}) > max_G
        max_G = max(G{k});
    end
    if min(G{k}) < min_G
        min_G = min(G{k});
    end
end

qg = cell(length(G), 1); % the quantized gains
bits = 6; % number of bits for the quantization

fprintf('------------------------------------\n');
fprintf('Quantization Training Finished\n');
fprintf('------------------------------------\n');
%% Check Quantization Levels and how they are applied
for k = 1:length(G)
    tmp = zeros(1, length(G{k}));
    for l = 1:length(G{k})
        tmp(l) = scalar_quantization(G{k}(l), bits, min_G, max_G);
    end
    qg{k} = tmp;
end

index = 7;
% Plotting
figure; 
plot(G{index}); 
hold on;
plot(qg{index}, 'LineWidth',2);
hold off;
legend('Before Quantization', 'After Quantization');


%% Read Test Set files
close all;
fprintf('Choose Test Data Directory:\n');
rootdir = uigetdir('.', 'Choose Test Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


%% Apply LPC with Quantization on test set
for k = 1:length(filelist)
    baseFileName = filelist(k).name;
    fullFileName = [filelist(k).folder, '\', baseFileName];
    fprintf(1, 'Applying Quantization to %s\t', baseFileName);

    out = quantized_lpc(fullFileName, min_G, max_G);
    [sig, fs] = audioread(fullFileName);

    figure; 
    subplot(211); plot(sig); title('Original signal');
    subplot(212); plot(out); title('Synthesized signal');

    MSE = (1/size(sig,1)) * sum((sig - out).^2);
    fprintf(1, 'MSE: %f\n', MSE);
    soundsc(sig, fs);
    pause(3);
    soundsc(out, fs);
    pause(3);
end