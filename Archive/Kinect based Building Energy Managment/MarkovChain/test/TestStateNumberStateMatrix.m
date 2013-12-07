function test_suite = TestStateNumberStateMatrix()
% unit testing test cases
initTestSuite;
statematrix = [1,2,1,1,1;1,1,2,1,1;1,2,3,4,3];
statenums = StateNumber(statematrix);
samestatematrix = StateMatrix(statenums);
assertEqual(statematrix, samestatematrix)