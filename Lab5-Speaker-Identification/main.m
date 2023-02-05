%% Clear
close all; clear;

%% Feature Extraction
clear; close all;

fprintf('Choose Training Data Directory:\n');
rootdir = uigetdir('.', 'Choose Training Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list
if exist('features', 'dir')
   rmdir('features', 's'); 
end
mkdir('features');
% the gains of all the speech signals 
fprintf('Analyzing Speech files:\n');
fprintf('------------------------------------\n');
for k = 1:length(filelist)
    baseFileName = filelist(k).name;
    fullFileName = [filelist(k).folder, '\', baseFileName];
    [~, name, ~] = fileparts(fullFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    mfcc_arr = feature_extraction(fullFileName);
    
    true_label = regexp(fullFileName,'\','split');
    true_label = true_label{end-1};
    savepath = ['features/', true_label,'_',name, '.mat'];
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
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading features %s\n', baseFileName);
    
    features = load(fullFileName);
    
    [means_arr, variances_arr, weights_arr] = GMM_training(features, mixtures);
    [~, name, ~] = fileparts(fullFileName);
    savepath = ['GMM/', name];
    mkdir(savepath);
    save([savepath, '/means.mat'], 'means_arr');
    
    save([savepath, '/variances.mat'], 'variances_arr');
    save([savepath, '/weights.mat'], 'weights_arr');
end

%% Predict
clear; close all;

fprintf('Choose Testing Data Directory:\n');
rootdir = uigetdir('.', 'Choose Testing Data Directory'); %gets directory
filelist = dir(fullfile(rootdir, '**\*.wav*'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

% the gains of all the speech signals 
fprintf('Analyzing Speech files:\n');
fprintf('------------------------------------\n');
accuracy = 0;
for k = 1:length(filelist)
    baseFileName = filelist(k).name;
    fullFileName = [filelist(k).folder, '\', baseFileName];
    [~, name, ~] = fileparts(fullFileName);
    true_label = regexp(fullFileName,'\','split');
    true_label = true_label{end-1};
    fprintf(1, 'Now reading %s\n', baseFileName);
    
    fprintf('------------------------------------\n');
    mfcc_arr = feature_extraction(fullFileName);
    label = GMM_predict(mfcc_arr);
    fprintf('True label: %s\n', true_label);
    fprintf('\tPrediction: %s\n', label);
    label = regexp(label,'_','split');
    label = label{1};
    correct_pred = strcmp(label, true_label);
    fprintf('\tIs Correct: %s\n', string(correct_pred));
    if (correct_pred)
        accuracy = accuracy + 1;
    end
    fprintf('------------------------------------\n');
end

fprintf('Accuracy: %d\n', accuracy / length(filelist));
