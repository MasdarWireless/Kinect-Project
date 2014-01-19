function occupancy = FindOccupancy(filenames)
% This function loads and parses the log files from kinnect sensors and
% gives out the occupancy matrix 2D
% input:
% a struct of log files, numFiles = numSensors
% e.g:
% >> filenames = {[pwd '\data\k-files\k1.txt'],...
%              [pwd '\data\k-files\k2.txt'],...
%              [pwd '\data\k-files\k3.txt'],...
%              [pwd '\data\k-files\k4.txt'],...
%              [pwd '\data\k-files\k5.txt'],...
%              [pwd '\data\k-files\k6.txt'],...
%              [pwd '\data\k-files\k7.txt'],...
%              [pwd '\data\k-files\k8.txt']};
% output:
% >> occupancy
% occupancy =
% 
%      2     0     0    -1     1
%      0     0     0     0     0
%      4    -3     0     0    -1
%      2     0     0     0     0
%      2    -1     0     0     1
%      1     0     0     0     0
%      .     .     .     .     .

numSensors = 8;

for i = 1:numSensors
    dataStruct{i} = ParseLogFiles(filenames{i});
end

% Find common dates among all logs and create array of in, out from these
% common dates part of the dataStruct.

common = containers.Map; % Key value pairs like python's dictionary
for i = 1:numSensors
    for j = 1:size(dataStruct{i},2)
        idate = cell2mat(dataStruct{i}{j}.date);
        if common.isKey(idate)
            common(idate) = common(idate) + 1;
        else
            common(idate) = 1;
        end
    end
end

% find the dates that all sensor has logged
dateIdx = cell2mat(common.values) == numSensors;
dates = common.keys;
commondates = dates(dateIdx);

% Calculate occupancy from in, out data
occupancy = [];
for d = 1:size(commondates, 2)
    sensor = {};    
    for i = 1:numSensors
        for j = 1:size(dataStruct{i},2)
            if strcmp(dataStruct{i}{j}.date{1}, commondates{d})
                sensor{i} = dataStruct{i}{j};
                break;
            end
        end
    end
    % Occupancy formulas used
    %   zone1 = k1_in + k2_out - k2_in
    %   lobby = k2_in - k2_out + k3_out - k3_in + k6_out - k6_in
    %   zone2 = k3_in - k3_out + k4_in - k4_out
    %   zone3 = k6_in - k6_out + k5_in - k5_out
    %   zone4 = k8_in - k8_out + k7_out - k7_in
    
    occupancy = [occupancy; sensor{1}.infinal' + sensor{2}.outfinal' - sensor{2}.infinal',...
                sensor{2}.infinal' - sensor{2}.outfinal' + sensor{3}.outfinal' - sensor{3}.infinal' + sensor{6}.outfinal' - sensor{6}.infinal',...
                sensor{3}.infinal' - sensor{3}.outfinal' + sensor{4}.infinal' - sensor{4}.outfinal',...
                sensor{6}.infinal' - sensor{6}.outfinal' + sensor{5}.infinal' - sensor{5}.outfinal',...
                sensor{8}.infinal' - sensor{8}.outfinal' + sensor{7}.outfinal' - sensor{7}.infinal'];
end
occupancy(occupancy < 0) = 0; % This step is to ensure that total count is not made negative