%% This script does a experiment to find the markov chain of a set set of state transitions

clc
clear all
addpath(genpath(fileparts(mfilename('fullpath'))));

% user parameters
% $$$ datfilename = 'E:\Markov Chain - Ahmed\data\Sep29-occupdata.txt';
datfilename = ['/home/abrahamx91/Professional/Git/Kinect-Project/' ...
               'Archive/Kinect based Building Energy Managment/MarkovChain/data/Sep29-occupdata.txt']
thresVec = [0, 5, 8]; % vector of 3 elements which helps threshold and classify 
                      % the data into states [E,F,M,C]. here <= 0 is E,
                      % else if <= 5 is F, else if <= 8 is M, else C.

[traindata, colnames] = LoadData(datfilename); % we can have different training and real data
states = StatesFromData(traindata, thresVec);
transitionmatrix = LearnTransition(states);

% We find the probabilities of transition from one state to another using
% the `realdata` and `transitionmatrix`

% realdata = traindata; % in this case
probabilitymatrix = FetchProbabilityMatrix(states, transitionmatrix);

% Comparing the maximum probability state and the real state transitions
presentstates = StateNumber(states(1:end-1,:));
[~, futurestates] = max(transitionmatrix(presentstates,:),[],2);
comparison = futurestates == StateNumber(states(2:end,:));
disp('The accuracy of the prediction system in scale 0 to 1')
disp(sum(comparison)/length(comparison))


% DELETE Later - this block writes the transition matrix (CSV) for opening with excel
 T = mat2cell(transitionmatrix, ones(1,length(transitionmatrix)), ...
              ones(1,length(transitionmatrix))); 
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