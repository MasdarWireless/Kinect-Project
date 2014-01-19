function statenums = StateNumber(statematrix)
% this function reads the individual rows of the `statematrix` and computes
% the equivalent statenumber. example for the set of states of 5 zones
% being {E,E,E,E,E} the combined new state representation is 1. then a
% states set {E,E,E,E,F} is 2 and so on till {C,C,C,C,C} is 4^5.
% total number of combined states we can have is
% numIndividualStates^numZones.

statenums = statematrix(:,5) + (statematrix(:,4)-1)*4 + (statematrix(:,3)-1)*16 + (statematrix(:,2)-1)*64 + (statematrix(:,1)-1)*256;