%-----------------------------------------------------------------------
% File: accumQvals.m
%
% Description:
%   Accumulates q-values from a qhist list
%   Assumes 2 players
%   Assumes data is for one state only (preprocess with filterStateAction)
%
%   Value iteration version
%       assumes every numQs entries is a true iteration
%
%
%   Ex: 2x2 game q-values are returned in row-major vector:
%       [(2,1) (1,2) (2,1) (2,2)]
%-----------------------------------------------------------------------
function [qlist] = accumQvals(qhist,numAction, stateLen, valiter, withPol)

if nargin < 4
    valiter = 0;
end
if nargin < 5
    withPol = 1;
end

[numIter, dataCols] = size(qhist);
numQs = numAction * numAction;
if withPol
    if dataCols - (stateLen + 5) < 4
        error(['accumQvals: ploting policy, but missing policy values']);
    end
    numOutCols = numQs + 5;
else
    numOutCols = numQs;
end

qtable = zeros(1,numQs);
if valiter
    disp(['Number VI Simulation Iters: ', num2str(numIter/numQs)]);
    qlist = zeros((numIter / numQs)-1, numOutCols);
else
    disp(['Number Q Simulation Iters: ', num2str(numIter)]);
    qlist = zeros(numIter-1,numOutCols);
end
disp(['Number Q-Values: ', num2str(numQs)]);

if withPol
    numIter = numIter -1;
end
curQ = 1;     % needed for valiter version
curEntry = 1; % needed for valiter version
for i = 1:numIter
    avec = qhist(i,[(stateLen+1):(stateLen+2) (stateLen+4)]);
    act1 = avec(1);
    act2 = avec(2);
    qval = avec(3);
    qtable((act1-1) * numAction + act2) = qval;
    if valiter
        if curQ == numQs
            if withPol
                V = sum(qtable .* qhist(i+1,stateLen+6:stateLen+9));
                qlist(curEntry,:) = [qtable qhist(i+1,stateLen+6:stateLen+9) V];
            else
                qlist(curEntry,:) = qtable;
            end
            curEntry = curEntry + 1;
            curQ = 1;
        else
            curQ = curQ + 1;
        end
    else
        if withPol
            V = sum(qtable .* qhist(i+1,stateLen+6:stateLen+9));
            qlist(i,:) = [qtable qhist(i+1,stateLen+6:stateLen+9) V];
        else
            qlist(i,:) = qtable;
        end
    end
end
