%% Find occupancy states
% find the different scales in the occupancy stuff. And replace
% them with the ASCII codes respectively.

filename = 'occshzone4.txt';
delimiterIn = '\t';
% $$$ headerlinesIn = 1;
Kinect = importdata(filename, delimiterIn);

index1 = find(Kinect == 0);
index2 = find(0<Kinect & Kinect < 7);   % 1--6
index3 = find(7<=Kinect & Kinect < 15);  % 7--14
index4 = find(15<=Kinect);               % First find out the
                                        % indices or there would be
                                        % problems later on;

Kinect(index1) = 'E';                   % empty
Kinect(index2) = 'F';                   % "few" people in the lab;
Kinect(index3) = 'A';
Kinect(index4) = 'C';

% Write the output to a txt or csv file
csvwrite('zone4_mar.csv', Kinect)










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