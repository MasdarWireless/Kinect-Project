function PrintToFileParsedOutput(inputStruct, outputfilename)
% Prints to file the input struct in a specific format
if nargin < 2
    fid = 1; % output to screen
else
    fid = fopen(outputfilename, 'wt+');
end
for i = 1:size(inputStruct, 2)
    fprintf(fid, '%s', cell2mat(inputStruct{i}.date));
%     sprintf('%s', cell2mat(inputStruct{i}.date))
    fprintf(fid, '\n');
%     sprintf('\n')
    for j = 1:48
        fprintf(fid, '%s %d %d', cell2mat(inputStruct{i}.time(j)), inputStruct{i}.infinal(j), inputStruct{i}.outfinal(j));
%         sprintf('%s %d %d', cell2mat(inputStruct{i}.time(j)), inputStruct{i}.infinal(j), inputStruct{i}.outfinal(j))
        fprintf(fid, '\n');
%         sprintf('\n')
    end
    fprintf(fid, '\n');
end
if fid ~= 1
    fclose(fid);
end


%% Comment
% Learn from good MATLAB codes and alike. Grow with this city
% because you are so fucking lonely.
% With MATLAB you are able to have & preserve a better
% understanding of Matrix, which is vital for a computer science
% shit. 