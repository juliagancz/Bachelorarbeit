function kwx = processKWX(datapath)

% datapath = pwd;
h = dir(fullfile(datapath, '*.kwx'));
if length(h) ~= 1
    fprintf('Strange number of KWX-files!\n');
%     keyboard;
end
for i = 1:length(h)
    datafile = fullfile(datapath, h(i).name);
    fprintf('There is a KWX file in this directory but the reading program has not been finished!\n');
    fprintf('The kwx-file is supposed to contain the spike waveforms: (https://open-ephys.atlassian.net/wiki/display/OEW/Data+format)\n');
    fprintf('If you did not record any spikes you can ignore this file!\n\n');
    fprintf('The name of the file is: %s\n', datafile);
    kwx = [];
%     data.starttime = h5readatt(datafile, '/recordings/0/', 'start_time');
%     data.samplerate = h5readatt(datafile, '/recordings/0/', 'sample_rate');
%     data.ttlrecording = h5read( datafile, '/event_types/TTL/events/recording');
%     data.ttltime = h5read( datafile, '/event_types/TTL/events/time_samples');
%     data.evChannels = h5read( datafile, '/event_types/TTL/events/user_data/event_channels');
%     data.nodeID = h5read( datafile, '/event_types/TTL/events/user_data/nodeID');
%     data.evID = h5read( datafile, '/event_types/TTL/events/user_data/eventID');
%     data.messagesTime = h5read( datafile, '/event_types/Messages/events/time_samples');
%     data.messagesRecording = h5read( datafile, '/event_types/Messages/events/recording');
%     data.messagesUD_Text = h5read( datafile, '/event_types/Messages/events/user_data/Text');
%     data.messagesUD_evID = h5read( datafile, '/event_types/Messages/events/user_data/eventID');
%     data.messagesUD_Text = h5read( datafile, '/event_types/Messages/events/user_data/Text');
%     data.messagesUD_nodeID = h5read( datafile, '/event_types/Messages/events/user_data/nodeID');
end