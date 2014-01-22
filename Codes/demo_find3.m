% The expression returns a vector of row indices of the nonzero
% entries of N where N=(X>2) a vector of column indices of the
% nonzero entries of N where N=(X>2) and a logical array that
% contains the nonzero elements of N where N=(X>2). 
X = [3 2 0; -5 0 7; 0 0 1];
[r,c,v] = find(X>2);
r
c
v
