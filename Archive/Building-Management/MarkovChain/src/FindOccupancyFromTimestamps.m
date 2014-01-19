function occupancy = FindOccupancyFromTimestamps(kfiles, numzones)
% This function finds the occupancy by using the timestamps and predicting
% where a person travels from one plcae to another.

% Parsing files and extracting serial date-time number and corresponding
% in/out trigger (in=1,out=-1) for each sensor)
numSensors = 8;
sensor = {};
for n = 1:numSensors
    filename = kfiles{n};
    fid = fopen(filename);
    str = fgetl(fid);
    fclose(fid);
    id_1 = strfind(str, 'AM');
    id_2 = strfind(str, 'PM');
    if ~isempty(id_1) || ~isempty(id_2)
        timeformat = 1;
    else
        timeformat = 2;
    end

    fid = fopen(filename);
    if timeformat == 1
        parsedStruct = textscan(fid, '%s %s %s IN: %d OUT: %d');
    elseif timeformat == 2
        parsedStruct = textscan(fid, '%s %s IN: %d OUT: %d');
    else
        error('invalid timeformat')
    end
    fclose(fid);

    % The result is of format:
    % <Date>
    % <time> <in> <out>
    % 00:00 to 00:30 %half hr slots
    if timeformat == 1
        inOutMat = [parsedStruct{4}, parsedStruct{5}];
    elseif timeformat == 2
        inOutMat = [parsedStruct{3}, parsedStruct{4}];
    end
    % finding reset times(idx) of counter
    matdiff = inOutMat(2:end,:) - inOutMat(1:end-1,:);
    resetPts = find((matdiff(:,1) < 0 & matdiff(:,2) <= 0) | (matdiff(:,1) <= 0 & matdiff(:,2) < 0)) + 1;
    if isempty(resetPts)
        newInOutMat = [inOutMat(1,:); matdiff];
    else
        resetPts = [1; resetPts];
        newInOutMat = [];
        for i = 1:length(resetPts)
            if i < length(resetPts)
                newInOutMat = [newInOutMat; inOutMat(resetPts(i),:); inOutMat(resetPts(i)+1:resetPts(i+1)-1,:) - inOutMat(resetPts(i):resetPts(i+1)-2,:)];
            else
                newInOutMat = [newInOutMat; inOutMat(resetPts(i),:); inOutMat(resetPts(i)+1:end,:) - inOutMat(resetPts(i):end-1,:)];
            end
        end
    end
    newInOutMat = newInOutMat(:,1) - newInOutMat(:,2);% converting the In Out count matrix to a single column
    sensor(n).trigger = newInOutMat;
    whitespaces = mat2cell(repmat(blanks(1), size(parsedStruct{1})), ones(size(parsedStruct{1})));
    if timeformat == 1
        sensor(n).datestr = strcat(parsedStruct{1}, whitespaces, parsedStruct{2},...
                             whitespaces, parsedStruct{3});
    else
        sensor(n).datestr = strcat(parsedStruct{1}, whitespaces, parsedStruct{2});
    end
%     sensor(n)
end

% TODO - init all zone count = 0
% numSensors = 5; %delete
for n = 1:numSensors
    sensor(n).dateserial = datenum(sensor(n).datestr, 'dd/mm/yyyy HH:MM:SS');
end
% TODO - make chronological list of timestamps, 5 zone cnts (in = 1. out =
%        -1)
serials = [];
for n = 1:numSensors
    serials = sort(unique([serials; sensor(n).dateserial]));
end

occupancy.matrix = zeros(size(serials,1), numzones);
occupancy.dateserials = serials;
occupancy.datestrings = datestr(serials, 'dd/mm/yyyy HH:MM:SS');

inoutmat = zeros(size(serials,1), numSensors);

for n = 1:numSensors
    for j = 1:size(serials,1)
        idx = serials(j) == sensor(n).dateserial;
        if ~isempty(find(idx, 1))
            try
                inoutmat(idx, n) = inoutmat(idx, n) + double(sensor(n).trigger(idx));
            catch err
                disp('error in adding integers')
            end
        end
    end
end

% since we have 8 sensors and 5 zones let us define a 8 x 5 matrix which
% can be used to compute the zone occupancy from the `inoutmat`. When the
% function has to be turned generic, this matrix has to be edited to be an
% optional parameter by the user. [TODO]

% How is this matrix created?
% If sensor-1 is between zone1 and zone2. And a positive count from
% sensor-1 represents a person moving from zone1 to zone2, then in an
% matrix of zeros of size [8 x 5], make the element (1,1) = -1 and element
% (1,2) = 1. where a element (i,j) represents i'th sensor, j'th zone and +1
% represent positive count on the zone and -1 a negative count. Similarly
% fill all elements based on the sensor placements
counterToOccMat = [ 1, 0, 0, 0, 0;...
                   -1, 1, 0, 0, 0;...
                    0, 0, 1, 0, 0;...
                    0, 0, 1, 0, 0;...
                    0, 0, 0, 1, 0;...
                    0, 0, 0, 1, 0;...
                    0, 0, 0, 0, -1;...
                    0, 0, 0, 0, 1 ];
for i = 1:size(inoutmat, 1)
    row = inoutmat(i, :)*counterToOccMat;
    occupancy.matrix(i, :) = row;
end

