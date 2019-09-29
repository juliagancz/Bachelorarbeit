indices = cell(size(data,1),1);
wf_arr = cell(size(data,1),1);
for ii = 1:size(data{1},1)
	fprintf('Working on channel %i of %i\n', ii, size(data{1},1))
	[indices{ii}, wf_arr{ii}] = wf_detect_needle(data{1}(ii,:));
end