for aa = 0:124
    tmpa = aa;
    action = [];
    for ttNum = 3:-1:1
        ttDiv = 5^(ttNum - 1);
        curActNum = floor(tmpa / ttDiv);
        action(ttNum) = curActNum + 1;
        tmpa = mod(tmpa,ttDiv);
        disp(['aa: ', num2str(aa), ' ttDiv: ', num2str(ttDiv), ' curActNum: ', num2str(curActNum), ...
              ' tmpa: ', num2str(tmpa)]);
    end
    action
end

