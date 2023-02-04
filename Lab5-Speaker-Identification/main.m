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
    mffc_arr = feature_extraction(fullFileName);
    savepath = ['features/', name, '.mat'];
    save(savepath, 'mffc_arr');
end

%% Train
