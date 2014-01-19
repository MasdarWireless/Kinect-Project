function statematrix = StatesFromData(data, thresVec)
% This function thresholds data (number of persons in a zone) and labels
% the state which are { E(mpty), F(ew), M(edian), C(rowd) }
% [0 5 8 10]
if length(thresVec) ~= 3
    error('dataErr:thresLen', 'The number of elements of the thresholding vector is not as needed')
end
if sum(data < 0) > 0
    error('dataErr:badData', 'Data input has invalid elements')
end

statematrix = 4*ones(size(data));
for i = length(thresVec):-1:1
    I = data <= thresVec(i);
    statematrix(I) = i;
end