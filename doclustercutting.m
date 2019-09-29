channelno = 15;

[wavepca, pca_plot] = princomp(wf_arr{channelno});
index2cluster = clustercutter(wavepca, pca_plot);
figure;
plot(wf_arr{channelno}(~index2cluster,:)', 'Color', 'k') %plot all spikes outside of cluster
hold on
plot(wf_arr{channelno}(index2cluster,:)', 'Color', 'r') %plot cluster spikes 
plot(mean(wf_arr{channelno}(index2cluster,:))', 'Color', 'g') %mean of cluster spikes
av_spike = mean(wf_arr{channelno}(index2cluster,:)); %mittelwert der Amplitude
amplitudespike = max(av_spike) - min(av_spike); %peak to peak Amplitude
rmschannel = rms(data{1}(channelno,:));
std_channel = std(data{1}(channelno,:));
SNR_RMS = amplitudespike/rmschannel
SNR_STD = amplitudespike/std_channel
SNR_ju = amplitudespike/(2*std_channel)

fprintf('No of spikes in cluster: %i\n', length(find(index2cluster)));