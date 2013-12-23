% some files had typo in log files, like AM/PM were replaced by some junk
% characters, this is corrected in this script

filename = 'E:\Markov_Chain_Project_1_4\data\k-files\k7_new_2.txt';
writefilename = 'E:\Markov_Chain_Project_1_4\data\k-files\k7_new_3.txt';
fid = fopen(filename, 'r');
fidw = fopen(writefilename, 'w');
tline = fgetl(fid);
while ischar(tline)
    disp(tline)
    tline = strrep(tline, 'م', 'PM');
    tline = strrep(tline, 'ص', 'AM');
    tline = strrep(tline, '﻿', '');
    disp(tline)
    fprintf(fidw, '%s\r\n', tline);
    tline = fgetl(fid);
end
fclose(fid);
fclose(fidw);