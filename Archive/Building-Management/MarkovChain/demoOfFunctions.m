%% A demo script which tries to explain the functionality of all the function written till 12/11/13.
clc
close all

% The data that we have as input to the prediction system is the log files
% from sensors. first step is to parse it and find occupancy

% load some log files from all sensors
filenames = {[pwd '\data\k-files\k1.txt'],...
             [pwd '\data\k-files\k2.txt'],...
             [pwd '\data\k-files\k3_new.txt'],...
             [pwd '\data\k-files\k4_new.txt'],...
             [pwd '\data\k-files\k5_new.txt'],...
             [pwd '\data\k-files\k6_new.txt'],...
             [pwd '\data\k-files\k7_new.txt'],...
             [pwd '\data\k-files\k8_new.txt']};

%% ParseLogFiles(filename)

% ParseLogFiles() parses the log files and give out a computer readable
% struct (or object) which is used down the blocks for further processing
for i = 1:size(filenames, 2)
    dataStruct{i} = ParseLogFiles(filenames{i});
end

%% PrintToFileParsedOutput(inputStruct, outputfilename)

% this function is used to print the datastructs computed using ParseLogFiles()
% into a file in a human-readable format
% FORMAT:
% <date>
% <timeslot> <incount> <outcount>

% The function takes 2 arguments, 1 - datastruct, 2 - outputfilename
% here we ignore the second argument, this makes the function print the
% output to screen.
PrintToFileParsedOutput(dataStruct{1}) % example write (print to screen)

%% FindOccupancy(filenames)

% This function takes input as a struct of filenames, using the
% ParseLogFiles() internally and computes the occupancy based on formulas 
% based on the zones orientation.

disp('Occupancy:')
fprintf('zone1\tlobby\tzone2\tzone3\tzone4\n');
occupancy = FindOccupancy(filenames);
disp(occupancy)

%% We can save the occupancy matrix to a text file, which can be later loaded and analysed to
% find the transition matrix
datfilename = [pwd '\data\tempOccMat.txt'];
zones = {'zone1', 'lobby', 'zone2', 'zone3', 'zone4'};
SaveData(datfilename, occupancy, zones)

%% Finding the markov states from the occupancy data computed. The SaveData() and LoadData()
% is just used for demo here, we can directly use the occupancy matrix
% computed in case there is no need to save the occupancy matrix as a file.

thresVec = [0, 5, 8]; % vector of 3 elements which helps threshold and classify 
                      % the data into states [E,F,A,C]. here <= 0 is E,
                      % else if <= 5 is F, else if <= 8 is A, else C.

datfilename = [pwd '\data\tempOccMat.txt'];
[traindata, colnames] = LoadData(datfilename); % we can have different training and real data
states = StatesFromData(traindata, thresVec); % Markov states computed. E = 1, F = 2, A = 3, C = 4.

%% Learning the transition matrix. using the markov states, the transition matrix is found
transitionmatrix = LearnTransition(states);

%% Writing the transition matrix to a CSV file
T = mat2cell(transitionmatrix, ones(1,length(transitionmatrix)), ones(1,length(transitionmatrix)));
S = StateMatrix([1:1024]');
Str = blanks(5);
Str = repmat(Str, 1024,1);
Str(S == 1) = 'E';
Str(S == 2) = 'F';
Str(S == 3) = 'A';
Str(S == 4) = 'C';
StrT = mat2cell(Str, ones(1,length(transitionmatrix)));
writeMat = [{''},StrT'];
writeMat = [writeMat; [StrT, T]];
cellwrite('transitionmatrixnew.csv', writeMat)

%% Verify the accuracy of the system by using the training data
% Here we chk if the system predicts the next state of the building
% accuractely. For a state row, e.g. [1,2,1,1,3] which means {E,F,E,E,A} 
% a unique number from 1 to 1024 (i.e 4^5, 4 possible individual state, 5 combinations)
% is assigned. As we already know the next state, from the observed data,
% we just chk how many times the system is accurate and print the accuracy
% on screen.
presentstates = StateNumber(states(1:end-1,:));
[~, futurestates] = max(transitionmatrix(presentstates,:),[],2);
comparison = futurestates == StateNumber(states(2:end,:));
disp('The accuracy of the prediction system in scale 0 to 1')
disp(sum(comparison)/length(comparison))





%% Comment
% Actually the code is well-written. But the student may not know
% what have happened in the whole process.