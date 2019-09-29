function [indices, wf_arr, varargout] = wf_detect_needle(data)


use_lowerThr = 1;
use_upperThr = 0;
use_alignment = 0;

tic
sortAlg = 'quian'; % 'standard'


% data = smooth(data, 3);
vis = false;
% vis = false;

%% standard
switch sortAlg
    case 'standard'
        stabw = std(data);
        threshold = 2.5*stabw; % how many standard deviations to use as a threshold!
    case 'quian'
        
        %% Quian Quiroga 2004
        % Quian Quiroga R, Nadasdy Z, Ben-Shaul Y (2004)
        % Unsupervised Spike Detection and Sorting with Wavelets and Superparamagnetic
        % Clustering. Neural Comp 16:1661-1687.
        sigmaQ = median(abs(data)/0.6745);
        threshold = 4 * sigmaQ;
    otherwise
        error('Wrong algorithm!')
end

average = mean(data);
lockout = 8;
% PERFORMANCE of 30 (~1.00ms) datapoints seems to be superior to using
% 40 datapoints (~1.00ms). Tested that on:
% /Volumes/Daten/RatData2018/Rat20180731/0002/Rat20180731_2018-08-03_13-11-22_rh0002
% channel 16 on May 31st 2019.

pre_threshold = 8;
post_threshold = 21;
samplerate = 30000;

% lower threshold:
if use_lowerThr
    indices1 = find(data < -(average+threshold));
else
    indices1 = [];
end
% upper threshold
if use_upperThr
    indices2 = find(data > -(average-threshold));
else
    indices2 = [];
end

indices = [indices1 indices2];
indices = unique(indices);
difference = diff(indices);
indices((find(difference < lockout)+1)) = [];

while indices(1) <= pre_threshold
    indices(1) = [];
end
while indices(end) >= length(data)-post_threshold
    indices(end) = [];
end

for i = 1:length(indices)
    if use_alignment
        datasnippet = data(indices(i):indices(i)+round(post_threshold/2));
        maxsnippet = find(datasnippet == max(datasnippet));
        aligned_idx = indices(i)+maxsnippet;
    else
        aligned_idx = indices(i);
    end
    try
    wf_arr(i, :) = data(aligned_idx-pre_threshold:aligned_idx+post_threshold);
%     fprintf('%i of %i\n', i, length(indices))
    catch
        while aligned_idx + post_threshold > length(data)
            aligned_idx = aligned_idx - 1
        end
    end
end

maxvalue = (max(wf_arr'));
averagemax = mean(maxvalue);
stabwmax = std(maxvalue);
biggerthan10 = find(maxvalue > averagemax + 10*stabwmax);
minvalue = (min(wf_arr'));
averagemin = mean(minvalue);
stabwmin = std(minvalue);
smallerthan10 = find(minvalue < averagemin - 10*stabwmin);
biggerthan10 = [biggerthan10 smallerthan10];
fprintf('There are %i outliers!\n', length(biggerthan10));
wf_arr(biggerthan10, :) = [];
indices(biggerthan10) = [];

%% sanity check and visualization
if vis 
%     plot(wf_arr', 'Color', 'k')
%     set(gca, 'YLim', [-100 100])
    figure
    plot(data, 'Color', 'k')
    hold on
    for i = 1:1:length(indices)
        plot(indices(i)-pre_threshold:indices(i)+post_threshold,...
            wf_arr(i, :), 'Color', 'r');
    end
    plot(1:length(data), ones(1,length(data),1)*(-(average+2*stabw)), 'Color', 'g')
    plot(indices, ones(1,length(indices),1)*(-(average+4*stabw)), 'b*')
end

if nargout == 3
    varargout{1} = data;
end

toc
% keyboard;

% [pcas, pcaPlot] = princomp(wf_arr{1})
