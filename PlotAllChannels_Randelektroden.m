clear
filename = 'D:\Julia\BA\In Vivo\Ratte4\Rat20190521_2019-05-24_10-10-56_0002\experiment1_105.raw.kwd';
[data,ttl] = analyse_Kwd(filename);

data{1}(9,:)=NaN; %für channel 10, von unten zählen
data{1}(10,:)=NaN; %für channel 9, von unten zählen

PlotMultiChannelData(data{1},ttl, 1)
set(gcf,'color','w');