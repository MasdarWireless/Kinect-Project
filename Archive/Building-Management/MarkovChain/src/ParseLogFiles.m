function dataStruct = ParseLogFiles(filename)
% function to parse log files
% timeformat = 1, has AM,PM
% timeformat = 2, is 24 hrs clk
% if nargin<2
%     timeformat = 1;
% end
% finding the time format used in the log file
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
% if ~isempty(find(newInOutMat < 0)) % A test to the resetPts finding bug
%                                    % fix
%     error('Negative found')
% end
if timeformat == 1
    parsedStruct{4} = newInOutMat(:,1);
    parsedStruct{5} = newInOutMat(:,2);
else
    parsedStruct{3} = newInOutMat(:,1);
    parsedStruct{4} = newInOutMat(:,2);
end
% Splitting by date
dates = unique(parsedStruct{1});
dataStruct = {};
finalStruct = {};

%time slots
k = 0;
timeslotnums = zeros(1,48);
timeslots = {};
for i = 1:48 % there are 48 half hr slots in a day
    str = sprintf('%02d:%02d', floor(k/60), mod(k,60));
    timeslots{i} = str;
    timeslotnums(i) = datenum(str, 'HH:MM');
    k = k+30;
end

for i = 1:length(dates)
    dataStruct{i}.date = dates(i);
    idx = strcmp(parsedStruct{1}, dates(i));
    dataStruct{i}.timelogs = parsedStruct{2}(idx);
    if timeformat == 1
        dataStruct{i}.AmPm = parsedStruct{3}(idx);
        dataStruct{i}.in = parsedStruct{4}(idx);
        dataStruct{i}.out = parsedStruct{5}(idx);
    else
        dataStruct{i}.in = parsedStruct{3}(idx);
        dataStruct{i}.out = parsedStruct{4}(idx);
    end
    for j = 1:length(dataStruct{i}.timelogs)
        str = cell2mat(dataStruct{i}.timelogs(j));
        if timeformat == 1
            if strcmp(dataStruct{i}.AmPm(j), 'AM') 
                str = [str, ' ', 'AM'];
            else
                str = [str, ' ', 'PM'];
            end
            dataStruct{i}.timenum(j) = datenum(str, 'HH:MM:SS PM');            
        elseif timeformat == 2
            dataStruct{i}.timenum(j) = datenum(str, 'HH:MM:SS');
        end
    end
    % Windowing the timelogs
    for k = 1:48
        if k < 48
            idxTimeSlot = dataStruct{i}.timenum > timeslotnums(k) & dataStruct{i}.timenum < timeslotnums(k+1);
            dataStruct{i}.time{k} = timeslots{k};
            dataStruct{i}.infinal(k) = sum(dataStruct{i}.in(idxTimeSlot));
            dataStruct{i}.outfinal(k) = sum(dataStruct{i}.out(idxTimeSlot));
        else
            idxTimeSlot = dataStruct{i}.timenum > timeslotnums(k);
            dataStruct{i}.time{k} = timeslots{k};
            dataStruct{i}.infinal(k) = sum(dataStruct{i}.in(idxTimeSlot));
            dataStruct{i}.outfinal(k) = sum(dataStruct{i}.out(idxTimeSlot));
        end
    end
    dataStruct{i} = rmfield(dataStruct{i}, 'timelogs');
    dataStruct{i} = rmfield(dataStruct{i}, 'in');
    dataStruct{i} = rmfield(dataStruct{i}, 'out');
    dataStruct{i} = rmfield(dataStruct{i}, 'timenum');
    if timeformat == 1
        dataStruct{i} = rmfield(dataStruct{i}, 'AmPm');
    end
end


%% Comment
% Write down what you think. Learn from masterpiece, or rest in
% peace. Choose one.
% One thing to note for me is that you do not have to be TOO
% fancy. Make it run 