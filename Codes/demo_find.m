%% Some demos on the usage of find
% [row,col,v] = find(X, ...) returns a column or row vector v of
% the nonzero entries in X, as well as row and column indices. If X
% is a logical expression, then v is a logical array. Output v
% contains the non-zero elements of the logical array obtained by
% evaluating the expression X. For example, 


A= magic(4)
[r,c,v]= find(A>10);
r',c',v'
