function transitionMatrix = LearnTransition(states)
% this function takes in a 2D matrix of data observed in time. i.e. the
% data which contains instances of the state at each zone as observed. And
% using this data it learns the transition matrix (assuming that the
% process at hand remains the same)

transitionMatrix = zeros(1024);
if size(states,1) == 0
    transitionMatrix = eye(1024);
    return
end

combinedstates = StateNumber(states);
numTransistions = size(combinedstates,1) - 1;
if numTransistions > 0
    I = (combinedstates(2:end) - 1)*1024 + combinedstates(1:end-1);
    transitionMatrix(I) = transitionMatrix(I) + 1;
%     transitionMatrix(I) = transitionMatrix(I) ./ numTransistions;
    % Normalizing the rows
    for i = 1:size(transitionMatrix,1)
        if ~isequal(transitionMatrix(i,:), zeros(1,1024))
            transitionMatrix(i,:) = transitionMatrix(i,:) ./ sum(transitionMatrix(i,:));
        elseif isequal(transitionMatrix(i,:), zeros(1,1024))
            transitionMatrix(i,:) = 1/1024; % ASSUMPTION!!! when a particular transition never 
            % occurs, all its states are considered equiprobable and they
            % are given value 1/1024. With a large dataset, number of times
            % this assumption is used will get minimal or negligeble
        else
            error('unknown error, may point to invalid data read')
        end
    end
end


%% Comment
% I say that MATLAB is god damn powerful. Who would like to raise
% some objections.
% In algorithms we trust. In Computer we fuck.
% See how you change with Masdar Institute.