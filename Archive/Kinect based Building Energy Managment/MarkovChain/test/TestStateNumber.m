function test_suite = TestStateNumber()
% unit testing test cases
initTestSuite;

function testWithSampleInputs()
inp = [1,1,1,1,1];
expout = 1;
assertEqual(expout, StateNumber(inp))
inp = [1,1,1,1,4];
expout = 4;
assertEqual(expout, StateNumber(inp))
inp = [4,4,4,4,4];
expout = 1024;
assertEqual(expout, StateNumber(inp))
inp = [1,1,1,2,1];
expout = 5;
assertEqual(expout, StateNumber(inp))
