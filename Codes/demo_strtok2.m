%% Example 3

s = {'all in good time'; ...
     'my dog has fleas'; ...
     'leave no stone unturned'};

remain = s;

for k = 1:4
    [token, remain] = strtok(remain);
    token  
end





%% Acknowledgment
% Thank MATLAB for providing a powerful matrix processor to handle
% "matrix-like" data.
