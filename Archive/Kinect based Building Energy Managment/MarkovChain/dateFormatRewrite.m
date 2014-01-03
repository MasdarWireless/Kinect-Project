function dateFormatRewrite(filename)
% this function reads a txt log file for date and flips the first two
% columns of date, like if DD/MM/YYYY format gets changed into MM/DD/YYYY.

fid = fopen(filename, 'r');
[dir, filenm, ext] = fileparts(filename);
fid_new = fopen([dir '\' filenm '_new.txt'], 'w');

tline = fgetl(fid);
while ischar(tline)
    disp(tline)
    [partone, remaining] = strtok(tline, '//');
    [parttwo, remaining] = strtok(remaining, '//');
    wline = [parttwo '/' partone remaining];
    fprintf(fid_new, '%s\r\n', wline);
    tline = fgetl(fid);
end
fclose(fid);
fclose(fid_new);