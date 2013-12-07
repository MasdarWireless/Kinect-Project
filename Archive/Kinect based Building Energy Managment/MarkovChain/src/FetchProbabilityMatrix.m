function probabilitymatrix = FetchProbabilityMatrix(chainofstates, transitionmatrix)
% finds the states transitions and fetches the probability from the
% `transitionmatrix`
% Input:
% chainofstates N x 5 matrix, each row being states

N = size(transitionmatrix,1);
states = StateNumber(chainofstates);
probabilitymatrix = transitionmatrix((states(2:end)-1)*N + states(1:end-1));
% If you are wondering what is fetched from `transitionmatrix` it is
% probability elements Pij, where i is the present state and j is the next
% state. Here chainofstates(2:end) represent the next states matrix, and
% chainofstates(1:end-1) represent the present states matrix. 
% chainofstates(2:end)-1)*N + chainofstates(1:end-1) acceses the (i,j)
% elements using 1D converted indices. Ref. linear indexing