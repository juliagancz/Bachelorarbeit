clear
filename = 'D:\Julia\BA\In Vivo\Ratte1\Rat20190513_2019-07-03_12-34-05_0010c\experiment1_105.raw.kwd';
[data,ttl] = analyse_Kwd(filename);

 data{1}(1,:)=NaN; %für channel 18, von unten zählen
 data{1}(10,:)=NaN; %für channel 9, von unten zählen
%   data{1}(8,:)=NaN; %für channel 11
%   data{1}(9,:)=NaN; %für channel 10
%   data{1}(15,:)=NaN; %für channel 4
%   data{1}(16,:)=NaN; %für channel 3
%   data{1}(17,:)=NaN; %für channel 2
%   data{1}(18,:)=NaN; %für channel 1

PlotMultiChannelData(data{1},ttl, 1)
set(gcf,'color','w');
% set(gca,'XTick',[], 'YTick', []);
% 
% xticks = ([0 20 40 60 80 100]);
% xticklabels = ({'0','20','40','60','80','100'});
% yticks = ([17 16 15 14 13 12 11 10 8 7 6 5 4 3 2 1]);
% 
% %xticks = linspace(1, size(C, 2), numel(xticklabels));
% %set(gca, 'XTick', xticks, 'XTickLabel', xticklabels)
% %yticklabels = [];
% %yticks = linspace(1, size(C, 1), numel(yticklabels));
% %set(gca, 'YTick', yticks, 'YTickLabel', yticklabels);
% %title('Korrelation');
% xlabel('Zeit [ms]');

% hold on;
% plot([3105,3105],[0,100],'LineWidth',1.5,'Color',[0 0 0]);
% annotation(gcf,'textbox',...
%     [0.86 0.127053064600189 0.0691666680673759 0.0557350573901791],...
%     'String',{'100 µV'},...
%     'HorizontalAlignment','center',...
%     'LineStyle','none');
% %annotation('line',[1 1],[0 1],'String','100µV')
% %plot([3105,3105],[0,100]);
% hold off
%saveas(gcf,'C:\Users\julia\OneDrive\Desktop\Uni\SoSe19\Bachelorarbeit\Daten\Auswertung\Ratte 1\Ableitung\2.jpg')