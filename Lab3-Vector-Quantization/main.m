%% Clearing and params:
clear; close all;
num_bits = 6;

%% Analysis

fprintf('Choose Training Data Directory:\n');
rootdir = uigetdir('.', 'Choose Training Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

% the gains of all the speech signals
G = cell(length(filelist), 1);
comp_coeffs = cell(length(filelist), 1);
fprintf('Analyzing Speech files:\n');
fprintf('------------------------------------\n');
for k = 1:length(filelist)
    baseFileName = filelist(k).name;
    fullFileName = [filelist(k).folder, '\', baseFileName];
    fprintf(1, 'Now reading %s\n', baseFileName);
    [new_g, new_coeffs] = speech_analysis(fullFileName);
    G{k} = new_g;
    comp_coeffs{k} = new_coeffs;
    
end

%% Find scalar quantization function
fprintf('------------------------------------\n');
fprintf('Building Scalar Quantization...\n');
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

fprintf('Scalar Quantization Training Finished\n');
fprintf('------------------------------------\n');

%% Building Vector Quantization Codebook
fprintf('------------------------------------\n');
fprintf('Building Vector Quantization...\n');

vq_codebook = construct_vq_codebook(comp_coeffs, num_bits);

fprintf('Vector Quantization Training Finished\n');
fprintf('------------------------------------\n');
%% Check Quantization Levels and how they are applied
for k = 1:length(G)
    tmp = zeros(1, length(G{k}));
    for l = 1:length(G{k})
        tmp(l) = scalar_quantization(G{k}(l), num_bits, min_G, max_G);
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

fprintf('Choose Test Data Directory:\n');
rootdir = uigetdir('.', 'Choose Test Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


%% Apply LPC with Quantization on test set
for k = 1:length(filelist)
    baseFileName = filelist(k).name;
    fullFileName = [filelist(k).folder, '\', baseFileName];
    fprintf(1, 'Applying Quantization to %s\t', baseFileName);

    out = quantized_lpc(fullFileName, num_bits, min_G, max_G, vq_codebook);
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