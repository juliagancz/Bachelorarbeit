function PlotMultiChannelData(data,ttl, idx2starttime)

figure;
if isempty(ttl)
    high_time = [];
else
    high = (ttl.evID == 1);
    low = (ttl.evID == 0);
    starttime = double(ttl.starttime(idx2starttime));
%     starttime = uint64(0);
    high_time = double(ttl.ttltime(high));
    low_time = double(ttl.ttltime(low));
    high_time = high_time - starttime;
    high_time(high_time < 0) = [];
    low_time = low_time - starttime;
    low_time(low_time < 0) = [];
end
colorvector = 'bgrcmykw';
colorvector = 'kkkkkkkk';
hold on;
offset = 150;%150 
ms_100 = 1; %here:edit Time in ms(500ms is good, OP Raum sind 2sec)

ds = size(data);
st = floor((ds(2)/2)/(3000*ms_100));
maxst = floor(ds(2)/(3000*ms_100));
st = 1;
% st = (maxst-1)/2;
% st = maxst-1;
 
average_ = mean(data, 2);
mult = 1:length(average_);
position = average_  + (mult * offset)';

x_achse = (0:1/30:(100*ms_100)) + (st*(3000*ms_100));
xachseind = x_achse(1):1:x_achse(1) + length(x_achse) - 1;
y_ax_entries = [];

for i = 1:size(data,1)
    y_ax_entries(i) = (i*offset);
    ph(i) = plot(x_achse, data(i, st*(3000*ms_100):st*(3000*ms_100)+(3000*ms_100)) + (i*offset),...
        colorvector(mod(i-1, length(colorvector))+1), 'LineWidth', 1.5);
    th(i) = text(-10, position(i), sprintf('Ch %i', i), 'FontName', 'Arial', 'FontSize', 14); 
end

ind = find(high_time' > xachseind(1) & high_time' < xachseind(end));
if ~isempty(ind)
    for i = 1:length(ind)
        hp(i) = line([x_achse(find(ismember(xachseind, high_time(ind(i))))) ...
            x_achse(find(ismember(xachseind, high_time(ind(i)))))],...
            ylim, 'Color', 'r', 'LineWidth', 3);
        set(hp(i), 'Tag', 'Trigger');
    end
else 
    hp  = [];
end

set(gca, 'UserData', {st data offset ms_100 high_time hp}, 'ButtonDownFcn', @bdf,...
   'FontSize', 14, 'FontName', 'Arial', 'Color', 'None');
xlabel('Zeit [ms]'); %time
ylabel('Elektrode'); %habe ich geändert
set(gca, 'YTick', y_ax_entries);
counttmp = 0;
for i = length(y_ax_entries):-1:1
    counttmp = counttmp + 1;
    lab{counttmp} = sprintf('%2i', i); %'Ch. %2i'
end
set(gca, 'YTickLabel', lab)
%set(gca, 'Xticklabel', [0 20 40 60 80 100])

function status = bdf(pph, ~)

children = get(pph, 'Children');

idx2line = zeros(1, length(children));
for i = 1:length(children)
    if isempty(get(children(i), 'Tag'))
        idx2line(i) = strcmp('line', get(children(i), 'Type'));
    end
end
idx2line = find(idx2line);

ud = get(pph, 'UserData');
index = ud{1};
data = ud{2};
offset = ud{3};
ms_100 = ud{4};
high_time = ud{5};
hp = ud{6};

for i = 1:length(hp)
    set(hp(i), 'Visible', 'off')
end

modifier = get(gcf, 'SelectionType');
switch modifier
    case 'normal'
        ni = 1;
    case 'alt'
        if index == 1
            ni = 0;
        else
            ni = -1;
        end
    otherwise
        ni = 0;
end
        
x_achse = (0:1/30:(100*ms_100)) + ((index+ni)*(3000*ms_100));
xachseind = x_achse(1):1:x_achse(1) + length(x_achse) - 1;
ind = find(high_time > xachseind(1) & high_time < xachseind(end));


for i = 1:length(idx2line)
    xd = get(children(idx2line(i)), 'XData');
    try
    yd = data(i, (index+ni)*(3000*ms_100)+1: (index+ni)*(3000*ms_100)+(3000*ms_100)+1)...
        + (i*offset);
    catch, end
    xd = x_achse;
    set(children(idx2line(i)), 'YData', yd, 'XData', xd);
end

if ~isempty(ind)
    try
        for i = 1:length(ind)
            if length(hp) < i
                hp(i) = line([x_achse(find(ismember(xachseind, high_time(ind(i))))) ...
                    x_achse(find(ismember(xachseind, high_time(ind(i)))))],...
                    ylim, 'Color', 'r', 'LineWidth', 3);
                set(hp(i), 'Tag', 'Trigger');
            else
                
                set(hp(i), 'XData', [x_achse(find(xachseind == high_time(ind(i)))) ...
                    x_achse(find(xachseind == high_time(ind(i))))],...
                    'YData', ylim, 'Color', 'r', 'Visible', 'on', 'LineWidth', 3);
            end
        end
        
    catch,keyboard,fprintf('Line 104\n'),end
else
    set(hp, 'Visible', 'off');
end

set(pph, 'UserData', {index+ni data offset ms_100 high_time hp});


