% csvwrite(filename,M) writes matrix M into filename as
% comma-separated values. The filename input is a string enclosed
% in single quotes. 
m = [3 6 9 12 15; 5 10 15 20 25; ...
     7 14 21 28 35; 11 22 33 44 55];
csvwrite('csvlist.dat',m)
type csvlist.dat


% The next example writes the matrix to the file, starting at a
% column offset of 2. 
csvwrite('csvlist_new.dat',m,0,2)
type csvlist_new.dat