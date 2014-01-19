function statematrix = StateMatrix(statenums)
% This is an extra funtion which may not be required in the main script.
% this function converts the statenums back to state matrix, from which by
% thresholding we can get back the state-elements (like {E,E,C,F,M})

statematrix(:,1) = ceil(statenums ./ 256);
statenums(statematrix(:,1) > 1) = (statenums(statematrix(:,1) > 1) - (256 .* (statematrix(statematrix(:,1) > 1,1) - 1)));
statematrix(:,2) = ceil(statenums ./ 64);
statenums(statematrix(:,2) > 1) = (statenums(statematrix(:,2) > 1) - (64 .* (statematrix(statematrix(:,2) > 1,2) - 1)));
statematrix(:,3) = ceil(statenums ./ 16);
statenums(statematrix(:,3) > 1) = (statenums(statematrix(:,3) > 1) - (16 .* (statematrix(statematrix(:,3) > 1,3) - 1)));
statematrix(:,4) = ceil(statenums ./ 4);
statenums(statematrix(:,4) > 1) = (statenums(statematrix(:,4) > 1) - (4 .* (statematrix(statematrix(:,4) > 1,4) - 1)));
statematrix(:,5) = statenums;