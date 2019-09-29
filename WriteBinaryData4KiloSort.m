%   WriteBinary.m
%   -------------
%   Write array as binary file (int 16).
%
%   Input:
%       data - array [NCh, T]
%       fpath - Path to save the binary
%       bin_name - Name of binary file (with extension)
%
%   Usage:
%       WriteBinary(data, '/home/hendrik/TestBin/', 'testFile.dat')


function WriteBinaryData4KiloSort( data, fpath, bin_name )

fidW     = fopen(fullfile(fpath, [bin_name]), 'w');
count = fwrite(fidW, data, 'int16');
fprintf('Written %i items - should be %i\n', count, size(data,1)*size(data,2))
fclose(fidW);

end

