function data = processKWE(datapath)

% datapath = pwd;
h = dir(fullfile(datapath, '*.kwe'));
if length(h) ~= 1
    fprintf('Strange number of KWE-files!\n');
%     keyboard;
end
for i = 1:length(h)
    datafile = fullfile(datapath, h(i).name);
    info = h5info(datafile, '/recordings/');
    for ii = 1:length(info.Groups)
        stringval = sprintf('/recordings/%i/', ii-1);
        data.starttime(ii) = h5readatt(datafile, stringval, 'start_time');
        data.samplerate(i) = h5readatt(datafile, stringval', 'sample_rate');
    end
    data.ttlrecording = h5read( datafile, '/event_types/TTL/events/recording');
    data.ttltime = h5read( datafile, '/event_types/TTL/events/time_samples');
    data.evChannels = h5read( datafile, '/event_types/TTL/events/user_data/event_channels');
    data.nodeID = h5read( datafile, '/event_types/TTL/events/user_data/nodeID');
    data.evID = h5read( datafile, '/event_types/TTL/events/user_data/eventID');
    data.messagesTime = h5read( datafile, '/event_types/Messages/events/time_samples');
    data.messagesRecording = h5read( datafile, '/event_types/Messages/events/recording');
    data.messagesUD_Text = h5read( datafile, '/event_types/Messages/events/user_data/Text');
    data.messagesUD_evID = h5read( datafile, '/event_types/Messages/events/user_data/eventID');
    data.messagesUD_Text = h5read( datafile, '/event_types/Messages/events/user_data/Text');
    data.messagesUD_nodeID = h5read( datafile, '/event_types/Messages/events/user_data/nodeID');
end