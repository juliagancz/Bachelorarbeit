A = zeros(18,18);
for i = 1:18 %row
    for j = 1:18 %column
        kanal_i = data{1}(i,:);
        kanal_j = data{1}(j,:);
        [cc_ij] = corrcoef(kanal_i,kanal_j);
        coef_ij = cc_ij(1,2);
        A(i,j) = coef_ij;
        if i == 9
            continue
        elseif i == 10
            continue
        end
    end
end
B = fliplr(A);
C = flipud(B); %Spalte 1 ist jetzt elektrode 1
C(9,:) = []; %delete row
C(:,9) = []; %delete column
C(9,:) = []; %für elektrode 10
C(:,9) = [];

f2 = figure(2);
clf(f2)
figure(f2);
im = imagesc(C);
im.AlphaData = .5;
colorbar('Ticks',[0,0.3,0.5,0.7,0.9,1],...
         'TickLabels',{'0','0.3','0.5','0.7','0.9','1'})
set(gca, 'YDir', 'normal');
load('MyColormap','mymap')
colormap(gca,mymap);

caxis([0,1]);
xticklabels = [1 2 3 4 5 6 7 8 11 12 13 14 15 16 17 18];
xticks = linspace(1, size(C, 2), numel(xticklabels));
set(gca, 'XTick', xticks, 'XTickLabel', xticklabels)
yticklabels = [1 2 3 4 5 6 7 8 11 12 13 14 15 16 17 18];
yticks = linspace(1, size(C, 1), numel(yticklabels));
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels);
title('Korrelation');
xlabel('Elektrode');
ylabel('Elektrode');

set(gcf,'color','w');
grid on
ax = gca;
XTick = get(ax, 'XTick');
XTickLabel = get(ax, 'XTickLabel');
set(ax,'XTick',XTick+0.5);
set(ax,'XTickLabel',XTickLabel);

YTick = get(ax, 'YTick');
YTickLabel = get(ax, 'YTickLabel');
set(ax,'YTick',YTick+0.5);
set(ax,'YTickLabel',YTickLabel);