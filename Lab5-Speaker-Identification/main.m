%% Clear
close all; clear;

%% Feature Extraction
clear; close all;

fprintf('Choose Training Data Directory:\n');
rootdir = uigetdir('.', 'Choose Training Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

% the gains of all the speech signals 
fprintf('Analyzing Speech files:\n');
fprintf('------------------------------------\n');
for k = 1:length(filelist)
    baseFileNameMean = filelist(k).name;
    fullFileNameMean = [filelist(k).folder, '\', baseFileNameMean];
    [~, name, ~] = fileparts(fullFileNameMean);
    fprintf(1, 'Now reading %s\n', baseFileNameMean);
    mfcc_arr = feature_extraction(fullFileNameMean);
    savepath = ['features/', name, '.mat'];
    save(savepath, 'mfcc_arr');
end

%% Train
clear; close all;

myDir = 'features/'; %gets directory
myFiles = dir(fullfile(myDir,'*.mat')); %gets all mat files in struct
if exist('GMM', 'dir')
   rmdir('GMM', 's'); 
end
mkdir('GMM');
% the gains of all the speech signals 
fprintf('Analyzing feature .mat files:\n');
fprintf('------------------------------------\n');

mixtures = 12;

for k = 1:length(myFiles)
    baseFileNameMean = myFiles(k).name;
    fullFileNameMean = fullfile(myDir, baseFileNameMean);
    fprintf(1, 'Now reading features %s\n', baseFileNameMean);
    
    features = load(fullFileNameMean);
    
    [means_arr, variances_arr, weights_arr] = GMM_training(features, mixtures);
    [~, name, ~] = fileparts(fullFileNameMean);
    savepath = ['GMM/', name];
    mkdir(savepath);
    save([savepath, '/means.mat'], 'means_arr');
    
    save([savepath, '/variances.mat'], 'variances_arr');
    save([savepath, '/weights.mat'], 'weights_arr');
end

%% Predict
clear; close all;


%% Feature Extraction
clear; close all;

fprintf('Choose Testing Data Directory:\n');
rootdir = uigetdir('.', 'Choose Testing Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

% the gains of all the speech signals 
fprintf('Analyzing Speech files:\n');
fprintf('------------------------------------\n');
for k = 1:length(filelist)
    baseFileNameMean = filelist(k).name;
    fullFileNameMean = [filelist(k).folder, '\', baseFileNameMean];
    [~, name, ~] = fileparts(fullFileNameMean);
    fprintf(1, 'Now reading %s\n', baseFileNameMean);
    mfcc_arr = feature_extraction(fullFileNameMean);
    label = GMM_predict(mfcc_arr);
    fprintf('\tPrediction: %s\n', label);
end
