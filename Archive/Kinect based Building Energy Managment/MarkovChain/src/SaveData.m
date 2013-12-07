function SaveData(datfilename, occupancyMat, zones)
% saves a tab delimited txt file of the occupancy matrix 
% (which can be computed from the log files using the function
% FindOccupancy() )
% zones:- a cell array of zone names
if nargin < 3
    zones = {};
    for i = 1:size(occupancyMat,2)
        zones{end + 1} = ['zone', num2st(i)];
    end
end

fid = fopen(datfilename, 'w');
fprintf(fid, '%s\t%s\t%s\t%s\t%s\r\n', zones{:}); % print to file Header row
for i = 1:size(occupancyMat,1)
    fprintf(fid, '%d\t%d\t%d\t%d\t%d\r\n', occupancyMat(i,:));
end
fclose(fid);