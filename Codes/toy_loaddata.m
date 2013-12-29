% Import the file, specifying the space delimiter and the single
% column header. 
filename = 'myfile01.txt';
delimiterIn = ' ';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);

% View columns 3 and 5.
for k = [3, 5]
   disp(A.colheaders{1, k})
   disp(A.data(:, k))
   disp(' ')
end