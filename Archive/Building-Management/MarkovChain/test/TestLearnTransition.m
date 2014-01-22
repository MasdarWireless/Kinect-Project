function test_suite = TestLearnTransition()
% unit testing test cases
initTestSuite;

function testWithSampleInputs()
inp = [1,1,1,1,1;1,1,1,1,1];
out = LearnTransition(inp);
out = out(1,1);
expout = 1;
assertEqual(out, expout)
inp = [1,1,1,1,1;1,1,1,1,2];
out = LearnTransition(inp);
out = out(1,2);
expout = 1;
assertEqual(out, expout)
inp = [1,1,1,1,2;1,1,1,1,1];
out = LearnTransition(inp);
out = out(2,1);
expout = 1;
assertEqual(out, expout)
inp = [1,1,1,1,1;1,1,1,1,2;1,1,1,1,1];
out = LearnTransition(inp);out(1:2,1:2)
expout = 0.5;
assertEqual(out(1,2), expout)
expout = 0.5;
assertEqual(out(2,1), expout)