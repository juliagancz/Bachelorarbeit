%channelno = 13;
for i = 1:18
    y(i,:) = abs(data{1}(i,:));
    [wavepca{i}, pca_plot{i}] = princomp(wf_arr{i});
    index2cluster{i} = clustercutter(wavepca{i}, pca_plot{i});
    %figure;
    %plot(wf_arr{i}(~index2cluster{i},:)', 'Color', 'k') %plot all spikes outside of cluster
    %hold on
    %plot(wf_arr{i}(index2cluster{i},:)', 'Color', 'r') %plot cluster spikes 
    %plot(mean(wf_arr{i}(index2cluster{i},:))', 'Color', 'g') %mean of cluster spikes
    av_spike{i} = mean(wf_arr{i}(index2cluster{i},:)); %mittelwert der Amplitude
    amplitudespike{i} = max(av_spike{i}) - min(av_spike{i}); %peak to peak Amplitude
    std_noise{i} = median(abs(data{1}(i,:))/0.6745); %von paper
    SNR_ju{i} = amplitudespike{i}/(2*std_noise{i});
    number_spikes{i} = length(find(index2cluster{i}));
end
    SNR_ju(:,10) = []; %für kanal 10
    SNR_ju(:,9) = []; %für kanal 9
    std_noise(:,10) = [];
    std_noise(:,9) = [];
    gold = cell2mat(SNR_ju(1,1:8));
    pedot = cell2mat(SNR_ju(1,9:16));
    noise_gold = mean(cell2mat(std_noise(1,1:8)));
    noise_pedot = mean(cell2mat(std_noise(1,9:16)));
    SNR_gold = mean(gold);
    SNR_pedot = mean(pedot);
    std_SNR_gold = std(gold);
    std_SNR_pedot = std(pedot);
    std_noise_gold = std(cell2mat(std_noise(1,1:8)));
    std_noise_pedot = std(cell2mat(std_noise(1,9:16)));
    spikes_pedot = mean(cell2mat(number_spikes(1,11:18)));
    spikes_gold = mean(cell2mat(number_spikes(1,1:8)));
%fprintf('No of spikes in cluster: %i\n', length(find(index2cluster)));