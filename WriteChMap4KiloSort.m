%    WriteChMap.m
%    ------------
%    Save Channel map.
%
%    Input:
%        ChanMap - structure with channel map parameters
%        SavePath - Path to save channel map
%
%   Usage:
%       WriteChMap(ChanMap,'/home/hendrik/TestBin/')

function WriteChMap4KiloSort(ChanMap,SavePath, fname)

connected = ChanMap.connected;
chanMap = ChanMap.chanMap;
chanMap0ind = ChanMap.chanMap0ind;
xcoords = ChanMap.xcoords;
ycoords = ChanMap.ycoords;
kcoords = ChanMap.kcoords;
fs = ChanMap.fs;
save([SavePath filesep fname '_chanMap.mat'], 'chanMap', 'connected',...
             'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')

end