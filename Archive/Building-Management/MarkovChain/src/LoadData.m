function [data, colnames] = LoadData(datfilename)
% This function loads a txt file of N x M matrix and return it in Matlab
% matrix form
% Input:
% datfilename - filepath + name of the data txt file
% Output:
% colnames - matrix of cells containing cloumn name strings
% data - 2D matrix of data extracted

fid = fopen(datfilename);
str = fgetl(fid);
colnames = textscan(str, '%s %s %s %s %s', 'delimiter', '\t');
str = fgetl(fid);
i = 1;
while ischar(str)
    data(i,:) = cell2mat(textscan(str, '%d %d %d %d %d', 'delimiter', '\t'));
    i = i+1;
    str = fgetl(fid);
end
fclose(fid);