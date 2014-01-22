%% Example 2
% Take a string of HTML code and break it down into segments
% delimited by the < and > characters. Write a while loop to parse
% the string and print each segment: 
s = sprintf('%s%s%s%s', ... 
'<ul class=continued><li class=continued>', ...
'<pre><a name="13474"></a>token = strtok', ...
'(''str'', delimiter)<a name="13475"></a>', ...
'token = strtok(''str'')');

remain = s;

while true
   [str, remain] = strtok(remain, '<>');
   if isempty(str),  break;  end
   disp(sprintf('%s', str))
end