%% Clearing and params:
clear; close all;
num_bits = 6;
order_lpc = 10;

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
total_rows_coeffs = 0;
total_rows_g = 0;
for k = 1:length(filelist)
    baseFileName = filelist(k).name;
    fullFileName = [filelist(k).folder, '\', baseFileName];
    fprintf(1, 'Now reading %s\n', baseFileName);
    [new_g, new_coeffs] = speech_analysis(fullFileName, order_lpc);
    G{k} = new_g;
    comp_coeffs{k} = new_coeffs;
    total_rows_coeffs = total_rows_coeffs + length(new_coeffs);
    total_rows_g = total_rows_g + length(new_g);
end

shift = 0;
stretched_g = zeros(total_rows_g, 1);
for l = 1:length(filelist)
    Nfr = length(G{l});
    for m = 1:Nfr
        stretched_g(shift + m) = G{l}(m);
    end
    shift = shift + Nfr;
end

Nfiles = length(comp_coeffs);
shift = 0;
stretched_coeffs = zeros(total_rows_coeffs, order_lpc);
for l = 1:Nfiles
    Nfr = length(comp_coeffs{l});
    for m = 1:Nfr
        stretched_coeffs(shift + m, :) = comp_coeffs{l}{m}(:);
    end
    shift = shift + Nfr;
end
comp_coeffs = stretched_coeffs;
%% Find scalar quantization function
fprintf('------------------------------------\n');
fprintf('Building Scalar Quantization...\n');

std_dev = std(stretched_g);
max_G = 4 * std_dev;
min_G = 0;

qg = cell(length(G), 1); % the quantized gains

fprintf('Scalar Quantization Training Finished\n');
fprintf('------------------------------------\n');

%% Building Vector Quantization Codebook
fprintf('------------------------------------\n');
fprintf('Building Vector Quantization...\n');

vq_codebook = construct_vq_codebook(comp_coeffs, num_bits);

fprintf('Vector Quantization Training Finished\n');
fprintf('------------------------------------\n');
%% Check Scalar Quantization Levels and how they are applied
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
title(['Scalar Quantization with ', num2str(num_bits), ' bits in range [0, 4?]']);

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

    out = quantized_lpc(fullFileName, order_lpc, num_bits, min_G, max_G, vq_codebook);
    [sig, fs] = audioread(fullFileName);

    figure; 
    subplot(211); plot(sig); title('Original signal');
    subplot(212); plot(out); title(['Synthesized signal using ', num2str(num_bits)]);

    MSE = (1/size(sig,1)) * sum((sig - out).^2);
    fprintf(1, 'MSE: %f\n', MSE);
    soundsc(sig, fs);
    pause(3);
    soundsc(out, fs);
    pause(3);
end

%% George Manos voice
file = 'personal/stars_16k.wav';
out = quantized_lpc(file, order_lpc, num_bits, min_G, max_G, vq_codebook);
[sig, fs] = audioread(file);

figure; 
subplot(211); plot(sig); title('Original signal');
subplot(212); plot(out); title(['Synthesized signal using ', num2str(num_bits)]);

MSE = (1/size(sig,1)) * sum((sig - out).^2);
fprintf(1, 'MSE: %f\n', MSE);
soundsc(sig, fs);
pause(5);
soundsc(out, fs);
pause(5);

%% Alexandros Angelakis voice
file = 'personal/truth_16k.wav';
out = quantized_lpc(file, order_lpc, num_bits, min_G, max_G, vq_codebook);
[sig, fs] = audioread(file);

figure; 
subplot(211); plot(sig); title('Original signal');
subplot(212); plot(out); title(['Synthesized signal using ', num2str(num_bits)]);

MSE = (1/size(sig,1)) * sum((sig - out).^2);
fprintf(1, 'MSE: %f\n', MSE);
soundsc(sig, fs);
pause(4);
soundsc(out, fs);
pause(4);