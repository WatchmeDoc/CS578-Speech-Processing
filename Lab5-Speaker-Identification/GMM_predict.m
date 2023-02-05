function label = GMM_predict(mfcc_arr)
%
% INPUT:
%   file: input filename of a wav file
% OUTPUT:
%   out: a vector contaning the output signal
%
% Example:
%   
%   out = lpc_as('speechsample.wav');
%   [sig,fs]= wavread('speechsample.wav');
%   sound(out,fs);
%   sound(sig,fs);
%   sound([out [zeros(2000,1);sig(1:length(sig)-2000)]],fs); % create echo
%
%
% Yannis Stylianou
% CSD - CS 578
%

myDir = 'GMM'; %gets directory
myFiles = dir(myDir); %gets all mat files in struct
myFiles = {myFiles.name}';
myFiles(ismember(myFiles,{'.','..'})) = [];

% the gains of all the speech signals 
fprintf('Analyzing parameter .mat files:\n');
fprintf('------------------------------------\n');
for k = 1:length(myFiles)
    baseFileName = myFiles{k};
    fullFileName = fullfile(myDir, baseFileName);
    
    means = load([fullFileName, '\means.mat']);
    means = means.means_arr;
    vars = load([fullFileName, '\variances.mat']);
    vars = vars.variances_arr;
    weights = load([fullFileName, '\weights.mat']);
    weights = weights.weights_arr;
    
    %%% GMM testing here
end
label = 'None'; %% remove this obviously
end