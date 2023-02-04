%% Clear
close all; clear;

%% Feature Extraction

fprintf('Choose Training Data Directory:\n');
rootdir = uigetdir('.', 'Choose Training Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

% the gains of all the speech signals 
fprintf('Analyzing Speech files:\n');
fprintf('------------------------------------\n');
for k = 1:length(filelist)
    baseFileName = filelist(k).name;
    fullFileName = [filelist(k).folder, '\', baseFileName];
    [~, name, ~] = fileparts(fullFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    mfcc_arr = feature_extraction(fullFileName);
    savepath = ['features/', name, '.mat'];
    save(savepath, 'mfcc_arr');
end

%% Train

fprintf('Choose Training Data Directory:\n');
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.mat')); %gets all mat files in struct

% the gains of all the speech signals 
fprintf('Analyzing Speech files:\n');
fprintf('------------------------------------\n');

mixtures = 12;

for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    
    features = load(baseFileName);
    
    [means_arr, variances_arr, weights_arr] = GMM_training(features, mixtures);
    
    savepath = ['GMM/means/', baseFileName];
    save(savepath, 'means_arr');
    
    savepath = ['GMM/variances/', baseFileName];
    save(savepath, 'variances_arr');
    
    savepath = ['GMM/weights/', baseFileName];
    save(savepath, 'weights_arr');
end