%% Find occupancy states
% find the different scales in the occupancy stuff. And replace
% them with the ASCII codes respectively.

filename = 'zone4_mar.csv';
% $$$ delimiterIn = '\t';
% $$$ headerlinesIn = 1;
% $$$ Kinect = importdata(filename, delimiterIn);
Markov = csvread(filename);

index1 = find(Markov == 69);            % empty
index2 = find(Markov == 70);            % few
index3 = find(Markov == 65);  
index4 = find(Markov == 67);                  % First find out the
                                        % indices or there would be
                                        % problems later on;

Markov(index1) = 0;                     % empty
Markov(index2) = 28;                   % "few" people in the lab;
Markov(index3) = 26;
Markov(index4) = 24;

% Write the output to a txt or csv file
csvwrite('zone4_temp.csv', Markov)










%% Comment
% TODO: Right now the skeleton of codes is out. I may add a loop to
% make all those process automatic. Just like what "her" code
% does.
% The myth is that in a matrix (the most powerful data type in
% Matlab), you do not always have to use "symbols" or rather
% characters. Like the fcking A, B and C stuff. You can use
% numbers. Why?
% It's all about Mathematics.
% I am a computer scientist I am. Do math. Do science. As simple as
% that. 


%% Notes
% for loop, if possible
% modify this so that works fine for the temperature stuff. 