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
max = -inf;
label = 'None';
for k = 1:length(myFiles)
    baseFileName = myFiles{k};
    fullFileName = fullfile(myDir, baseFileName);
    [~, name, ~] = fileparts(fullFileName);
    
    means = load([fullFileName, '\means.mat']);
    means = means.means_arr;
    vars = load([fullFileName, '\variances.mat']);
    vars = vars.variances_arr; % NxNxK, N features K GMMs
    weights = load([fullFileName, '\weights.mat']);
    weights = weights.weights_arr;
    total_prob = 0;
    for i = 1:length(mfcc_arr)
        frame_mfcc = mfcc_arr(i, :);
        proba = 0;
        for j = 1:length(weights)
            if(isvector(vars))
                vars_slice = vars(j, :);
            else
                vars_slice = vars(:, :, j);
            end
            proba = proba + weights(j) * gauss_proba(means(j, :), vars_slice, frame_mfcc);
        end
        total_prob = total_prob + log(proba);
    end
    
    if (total_prob > max)
        max = total_prob;
        label = name;
    end
    %%% GMM testing here
end
end