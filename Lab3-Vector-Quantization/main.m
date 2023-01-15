%% Scalar Quantization
clear; close all;

rootdir = uigetdir; %gets directory
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
bits = 2; % number of bits for the quantization

%% Quantize every gain of the train speech signals
for k = 1:length(G)
    tmp = zeros(1, length(G{k}));
    for l = 1:length(G{k})
        tmp(l) = scalar_quantization(G{k}(l), bits, min_G, max_G);
    end
    qg{k} = tmp;
end

% Plotting
figure; 
plot(G{1}); 
hold on;
plot(qg{1}, 'LineWidth',2);
hold off;
legend('Before Quantization', 'After Quantization');
