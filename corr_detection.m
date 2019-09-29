% tic; 
% for i = 9:size(data{1}(channelno,:),2)-21
%     crrwrt(i) = corr(av_spike', data{1}(channelno, i-8:i+21)');
%     summeddistance(i) = sum(abs(data{1}(channelno, i-8:i+21) - av_spike));
% end
% toc

correlationvalue = 0.975;
protos = find(crrwrt > correlationvalue);

spike_ind = zeros(1, length(protos));

for i = 1:length(protos)
    indizes = [];
    inLockout = find(abs(protos - protos(i)) < 8);
    if all(crrwrt(protos(inLockout)) == 0)
        continue
    end
    try
    inLockout = inLockout(crrwrt(protos(inLockout)) == max(crrwrt(protos(inLockout))));
    if inLockout == 0
        keyboard
    end
    spike_ind(i) = protos(inLockout);
    catch
        keyboard
    end
end

sp = unique(spike_ind);
corrwf = zeros(length(sp), length(-8:21));
for i = 1:length(sp)
    corrwf(i,:) = data{1}(channelno,sp(i)-8:sp(i)+21);
end

if ~isempty(corrwf)
    figure('Name', sprintf('Corr threshold %2.4f', correlationvalue));
    plot(corrwf')
    [n,cc] = hist(corr(corrwf', av_spike'), 0.95:0.001:1);
    figure('Name', sprintf('Corr threshold %2.4f', correlationvalue))
    bar(cc, n, 1)
end


for i = 1:size(corrwf,1)
    mxsp(i) = max(corrwf(i,:));
    mnsp(i) = min(corrwf(i,:));
end
amplitude = mxsp-mnsp;
[N,x] = hist(amplitude, min(amplitude):10:max(amplitude));
figure, bar(x, N, 1)