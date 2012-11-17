%-----------------------------------------------------------------------
% File: chooseAction
%
% Description:
%
%-----------------------------------------------------------------------
function chosenAction = chooseAction(player, curState, mode)

global PolicyTieTolerance;

qStateRef = curState;
qStateRef{player.sLen +1} = ':';
pol = squeeze(player.Policy(qStateRef{:}));

if (any(pol == 1.0))
    [chosenAction, val] = find(pol == 1);
else
    if strcmp(mode, 'train') == 1
        [maxPol, maxAct] = max(pol);
        noTie = find(pol + PolicyTieTolerance < maxPol);
        pol(noTie) = 0;
        % find nonZero entries, choose uniformly from equal policies
        nonZero = find(pol);
        if nonZero > 1
            choice = ceil(rand * length(nonZero));
            chosenAction = nonZero(choice);
        else
            chosenAction = maxAct;
        end
    else
        numPol = length(pol);
        polCumSum = cumsum(pol);
        rChoice = rand;
        chosenAction  = numPol;
        for action = 1:numPol
            if rChoice <= polCumSum(action)
                chosenAction  = action;
                break;
            end
        end
    end
end
