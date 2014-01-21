% This script shows how a set of kinect log files parsed can be made into a
% 2D matrix of occupancy data, based on the occupancy formulas derived from
% the building layout

% input files
clc
filenames = {[pwd '\data\k-files\k1.txt'],...
             [pwd '\data\k-files\k2.txt'],...
             [pwd '\data\k-files\k3.txt'],...
             [pwd '\data\k-files\k4.txt'],...
             [pwd '\data\k-files\k5.txt'],...
             [pwd '\data\k-files\k6.txt'],...
             [pwd '\data\k-files\k7.txt'],...
             [pwd '\data\k-files\k8.txt']};
         
outputfile = [pwd '\data\k-files\occupancy.txt'];
numSensors = 8;

for i = 1:8
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
for d = 1:size(commondates)
    sensor = {};
    occ = [];
    for i = 1:numSensors
        for j = 1:size(dataStruct{i},2)
            dataStruct{i}{j}.date{1}
            commondates{d}
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
    %   zone3 = k6_in - k6_out
    %   zone4 = k8_in - k8_out + k7_out - k7_in
    
    occ = [occ; sensor{1}.infinal' + sensor{2}.outfinal' - sensor{2}.infinal',...
                sensor{2}.infinal' - sensor{2}.outfinal' + sensor{3}.outfinal' - sensor{3}.infinal' + sensor{6}.outfinal' - sensor{6}.infinal',...
                sensor{3}.infinal' - sensor{3}.outfinal' + sensor{4}.infinal' - sensor{4}.outfinal',...
                sensor{6}.infinal' - sensor{6}.outfinal',...
                sensor{8}.infinal' - sensor{8}.outfinal' + sensor{7}.outfinal' - sensor{7}.infinal'];
end
disp(occ) % tte occupancy data computed





%% Comment
% As I said before, those equations used to calculate occupancy in
% the 5-zone situation sucks. Sucks indeed. 
% One more note: You have to sleep earlier. In recent cases, be
% back at 00:00 am and watch 2 episodes. Then sleep.