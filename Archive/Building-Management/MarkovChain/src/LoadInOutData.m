function data = LoadInOutData(datfilename)
% This function loads a txt file containing tab delimited N x 3 matrix and return it in Matlab
% matrix form
% Input:
% datfilename - filepath + name of the data txt file
% Output:
% data - 2D matrix of data extracted

fid = fopen(datfilename);
str = fgetl(fid);
i = 0;
j = 0;
while ischar(str)
    % find line format
    [d1, f1] = regexp(str, '\/', 'split');
    [d2, f2] = regexp(str, '\ ', 'split');
    if ~isempty(f1) && isempty(f2)
        j = j+1;
        i = 0;
        data{j}.date = str;
    elseif ~isempty(f2) && isempty(f1)
        i = i+1;
        data{j}.values(i,:) = [str2num(cell2mat(d2(2))), str2num(cell2mat(d2(3)))];
        data{j}.time(i) = d2(1);
    else
%         fgetl(fid);
    end
    
    str = fgetl(fid);
end
fclose(fid);


%% Comment
% Well, had those codes been written by Mrs Haleimah, we would not
% be in such a great trouble now. Anyway, no Masdar, no
% Happiness. All in all, you are a student, and you ARE a
% student. For one thing, you should carry out research heart and
% soul. For another, as with what to research & how to reach it,
% you should follow your heart.