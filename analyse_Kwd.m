function [data, ttl] = analyse_Kwd(filename)

%% definition
spectralanalysis = false;%true; %false
correlationanalysis = false;%true;
reference = false;%true;
referenceChannel = 15;
analyse_ms = 0;
writekilo = 1;
n_electrodes = 18

%% processing
if isempty(filename) | ~exist(filename, 'file')
    datapath = pwd;
    infoexp = get_session_info(datapath);
    hh = dir(fullfile(pwd, '*.kwd'));
    if length(hh) > 1
        [datafile, datapath, ~] = uigetfile('*.kwd', 'Pick a Raw data file');
        
    elseif length(hh) == 0;
        return;
    else
        datafile = hh(1).name;
    end
    if datafile == 0
        return
    end
else
    [a,b,c] = fileparts(filename);
    if ~strcmp(c, '.kwd')
        fprintf('This is not a kwd-file!\n');
        keyboard;
    end
    datapath = a;
    datafile = [b c];
end
infohdf = hdf5info(fullfile(datapath, datafile));
fileseperator  = findstr(datapath, filesep);

if fileseperator(end) ~= length(datapath)
    basename = datapath(fileseperator(end)+1:end);
else
    basename = datapath(fileseperator(end-1)+1:fileseperator(end)-1);
end

% according to
% https://open-ephys.atlassian.net/wiki/display/OEW/Data+format this is
% volts/bit in microvolts (see datasheet for the intan chip 0.195 ?volts!
try
    bit_volts = h5readatt(fullfile(datapath,datafile), '/recordings/0/application_data', 'channel_bit_volts');
catch ME
    %     keyboard;
    fprintf('reading of the bit_depth failed! - taking the default value for INTAN chips\n');
    bit_volts = ones(18, 1) * 0.1950;
end
% data is int16!
% in case there are more datasets then just one:
for i = 1:size(infohdf.GroupHierarchy.Groups.Groups,2)
    stringvalue = sprintf('/recordings/%i/', i-1);
    % data is read in as int16 data --> no need for conversion!
    data{i} = h5read(fullfile(datapath, datafile), [stringvalue 'data']);
    data{i} = flipud(data{i});
    if size(data{i}, 1) > n_electrodes
        data{i} = data{i}(4:end,:);
    end
%     data{i}(9,:) = int16(0);
    tmp = strsplit(datafile, '.');
    bin_name = sprintf('%s_Rec%i', basename, i-1);
    if writekilo
        WriteBinaryData4KiloSort( data{i}, datapath, [bin_name '.dat']);
    end
    samplerate(i) = uint64(h5readatt(fullfile(datapath,datafile),...
        stringvalue, 'sample_rate'));   
    starttime(i) = h5readatt(fullfile(datapath,datafile), stringvalue,...
        'start_time');
        %% create channel map
    ChanMap.chanMap = 1:size(data{i}, 1);
    ChanMap.connected = true(1, size(data{i}, 1));
    %% V1 
    ChanMap.ycoords = [
        200
        370
        540
        710
        880
        1050
        1220
        1390
        1950
        50
        285
        455
        625
        795
        965
        1135
        1305
        1475
        ];
    %% V2.1
%     ChanMap.ycoords = [
%         50
%         1800
%         2000
%         2200
%         2400
%         2600
%         2800
%         3000
%         3200
%         1700
%         1900
%         2100
%         2300
%         2500
%         2700
%         2900
%         3100
%         3300
%         ];
    %% V2.2
%     ChanMap.ycoords = [
%         50
%         2200
%         2400
%         2600
%         2800
%         3000
%         3200
%         3400
%         3600
%         2100
%         2300
%         2500
%         2700
%         2900
%         3100
%         3300
%         3500
%         3700
%         ];
    %% V3.1
%     ChanMap.ycoords = [
%         260
%         652
%         1044
%         1436
%         1828
%         2220
%         2612
%         3004
%         3400
%         50
%         456
%         848
%         1240
%         1632
%         2024
%         2416
%         2808
%         3200
%         ];
    %% V3.2
%     ChanMap.ycoords = [
%         2100
%         2492
%         2884
%         3276
%         3668
%         4060
%         4452
%         4844
%         5240
%         50
%         2296
%         2688
%         3080
%         3472
%         3864
%         4256
%         4648
%         5040
%         ];
    %% Tet V2
%     ChanMap.ycoords = [
%         633
%         380
%         300
%         713
%         967
%         1047
%         1300
%         1380
%         1950
%         633
%         380
%         300
%         713
%         967
%         1047
%         1300
%         1380
%         1174
%         ];
   
    ChanMap.xcoords = [
        -75
        -75
        -75
        -75
        -75
        -75
        -75
        -75
        0
        75
        75
        75
        75
        75
        75
        75
        75
        75
        ];
    %% general linear layout:
    ChanMap.kcoords = ones(1, size(data{i}, 1));
    %% tetrode layout:
%     ChanMap.kcoords = [
%         2 % 1
%         1 % 2
%         1 % 3
%         2 % 4
%         3 % 5
%         3 % 6
%         4 % 7
%         4 % 8
%         6 % 9
%         2 %10
%         1 %11
%         1 %12
%         2 %13
%         3 %14
%         3 %15
%         4 %16
%         4 %17
%         5 %18
%         ];
    ChanMap.chanMap0ind = ChanMap.chanMap - 1;
    ChanMap.fs = double(samplerate(i));
    if writekilo
        WriteChMap4KiloSort(ChanMap,datapath, bin_name);
    end
    %% KiloParams:
    KiloParams = struct(...
        'multiFac', 2,...
        'doGPU', 0,...
        'doparfor', 0,...
        'initSpikes', 'no',...
        'fullpasses', 6,...
        'fs', double(samplerate(i)),...
        'Kmerge', 1,...
        'Nchan', 18,...
        'NchanTot', size(data{i}, 1),...
        'Temps', 32);
    MyParams = struct(...
        'seeds', 1,...
        'ReduceRez', 1,...
        'saveDir', [datapath filesep],...
        'binDir', [datapath filesep],...
        'binName', bin_name(1:end-4));
    if writekilo
        save([datapath filesep sprintf('%s_%i.mat', bin_name, i-1)], 'KiloParams', 'MyParams')
    end
    % data = double(data) * 0.195 / 1000; % data unit is in mV
    %changed this 2017.12.04
    data{i} = double(data{i}) * 0.195 ; % data unit is in ?V
end

%% 20170811 took this out for the 32 channel recordings done with two needles implanted!
% if size(data, 1) > 16
%     fprintf('Apparently you are having the three additional channels recorded - I am deleting these!\n');
%     data = data(1:16, :);
% end

ttl = processKWE(datapath);


% this needs to be done to align the timing of ttl and data - see:
% https://groups.google.com/forum/#!msg/open-ephys/UKMvDOmDyac/yR7-zBc_BAAJ
%%-----------------
% took this out 2018.07.11, starting to get multiple recordings in one file
% to run
for i = 1:length(ttl.messagesUD_Text)
    if findstr(ttl.messagesUD_Text{i}, 'Processor:')
        idx2validsync = i;
    end
end
if isempty(idx2validsync)
    fprintf('Something wrong with the synchronzation timestamp in the KWE file!\n');
    keyboard;
else
    ttl.ttltime = ttl.ttltime - ttl.messagesTime(idx2validsync);
%     ttl.ttltime = ttl.ttltime - ttl.starttime(1);
end
%%-----------------


% are there spike waveforms? - https://open-ephys.atlassian.net/wiki/display/OEW/Data+format
kwx = processKWX(datapath);
if starttime ~= ttl.starttime
    fprintf('Error: two different starttimes!\n');
%     keyboard;
end
if samplerate ~= ttl.samplerate
    fprintf('Error: two different samplerates!\n');
%     keyboard;
end

% doing a spectral analysis of the data:
for j = 1:size(data)
    for i = 1:size(data{j}, 1)
        if spectralanalysis
            fft_SectralAnalysis(data{j}(i,:), samplerate);
        end
    end
    
    
    % analyzing the electrical microstimulation:
    
    if analyse_ms
        psth_matrixRef(:,:) = analyse_ttlPulses(ttl, data{j}(referenceChannel,:),...
            starttime, samplerate, [], 15);
        
        if ~reference
            psth_matrixRef = zeros(size(psth_matrixRef));
        end
        
        figure, ph = subplot(4,4,1)
        for i = 1:size(data{j}, 1)
            if 1
                ph = subplot(size(data{j},1)/6,6,i);
                psth_matrix(:,:,i) = analyse_ttlPulses(ttl, data{j}(i,:), starttime, samplerate, ph, i,...
                    mean(psth_matrixRef));
            end
        end
    end
    
    % do a correlation analysis if wanted:
    analyse_rho = 0;
    if analyse_rho
        RHO = corr(double(data{j}'));
        figure; hold on
        for i = 1:size(RHO, 2)
            for ii = 1:size(RHO, 1)
                plot(i, RHO(ii,i), '.')
                text(i, RHO(ii,i), sprintf('%i', ii))
            end
        end
        
        %% Correlation in dependence on the distance between wires on the cable:
        if correlationanalysis
            figure;
            cableneighbors = [1 2 3 4 5 6 7 8 16 15 14 13 12 11 10 9];
            index = 1:length(cableneighbors);
            corrmat_cabledist = cell(1, length(cableneighbors));
            for i = 1:length(cableneighbors)
                distance = abs(index - index(i));
                for j = 1:length(distance)
                    corrmat_cabledist{1, distance(j)+1}(end+1) = corr2(data{j}(cableneighbors(i),:), data{j}(cableneighbors(j),:));
                end
            end
            
            for i = 1:length(corrmat_cabledist)
                average_correlation(i) = mean(corrmat_cabledist{1,i});
                std_correlation(i) = std(corrmat_cabledist{1,i});
            end
            
            eh = errorbar(0:length(corrmat_cabledist)-1, average_correlation, ...
                std_correlation, 'r', 'LineWidth', 2);
            hold on
            
            %% Correlation in dependence on the distance of individual electrodes:
            % figure;
            % Randelektroden:
            electrodeneighbors = [8 16 7 15 6 14 5 13 4 12 3 11 2 10 1 9];
            % Tetroden:
            % electrodeneighbors = [8 16 7 15 6 14 5 13 4 12 1 9 2 10 3 11];
            index = 1:length(electrodeneighbors);
            corrmat_electrodedist = cell(1, length(electrodeneighbors));
            for i = 1:length(electrodeneighbors)
                distance = abs(index - index(i));
                for j = 1:length(distance)
                    corrmat_electrodedist{1, distance(j)+1}(end+1) = corr2(data{j}(electrodeneighbors(i),:), ...
                        data{j}(electrodeneighbors(j),:));
                end
            end
            
            for i = 1:length(corrmat_electrodedist)
                ed_average_correlation(i) = mean(corrmat_electrodedist{1,i});
                ed_std_correlation(i) = std(corrmat_electrodedist{1,i});
            end
            
            eh = errorbar(0:length(corrmat_electrodedist)-1, ed_average_correlation,...
                ed_std_correlation, 'k', 'LineWidth', 2);
            title('Correlation in relation to electrode distance on the needle');
            xlabel('Distance[number of electrodes]')
            ylabel('correlation coefficient');
            legend({'distance on the cable' 'distance between electrodes'})
        end
    end
end

%% creating some variables for easy saving of data:

broadband = strcat(basename, '_0.1-6000Hz.mat')
lowband = strcat(basename, '_0.1-0150Hz.mat')
highband = strcat(basename, '_300-6000Hz.mat')

% save([datapath filesep broadband], 'data', 'ttl', '-v7.3');