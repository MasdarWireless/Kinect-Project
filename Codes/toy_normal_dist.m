%% Description
% Modeling heights in inches for a randomly chosen forth grade. 
height = normrnd(50,2,30,1);             % Simulate heights.
[mu,s,muci,sci] = normfit(height)