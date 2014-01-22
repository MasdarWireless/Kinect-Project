%% Example 1
% This example uses the default white-space delimiter. Note that
% space characters at the start of the string are not included in
% the token output, but the space character that follows token is
% included in remain: 
s = '  This is a simple example.';
[token, remain] = strtok(s);

