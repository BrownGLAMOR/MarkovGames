%-----------------------------------------------------------------------
%
% function setDebug(debugLevel, runMode)
%
%-----------------------------------------------------------------------
function simul = setDebug(simul, debugLevel)

global InternalDebug;
InternalDebug = 0;
disp(['DEBUG set to ', num2str(debugLevel)]);
switch debugLevel
case 0
    simul.DisplayIter = 1000000;
case 1
    simul.DisplayIter = 100000;
case 2
    simul.DisplayIter = 10000;
case 3
    simul.DisplayIter = 1000;
case 4
    simul.DisplayIter = 100;
case 5
    simul.DisplayIter = 10;
case 6
    simul.DisplayIter = 1;
case 7
    simul.DisplayIter = 100;
    InternalDebug = 1;
case 8
    simul.DisplayIter = 10;
    InternalDebug = 1;
otherwise
    simul.DisplayIter = 1;
    InternalDebug = 1;
end
switch simul.runMode
    case 'test'
    case 'train'
    otherwise
        error(['Invalid run mode: ', simul.runMode]);
end
