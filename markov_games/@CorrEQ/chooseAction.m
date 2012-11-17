%-----------------------------------------------------------------------
% File: chooseAction
%
% Description:
%       Choose an action on-policy
%       randomly select an action based on current policy
%
%-----------------------------------------------------------------------
function [p1Act, p2Act] = chooseAction(player, curState, mode)

global PolicyTieTolerance;

pStateRef = curState;
pStateRef{player.sLen + 1} = ':';
pStateRef{player.sLen + 2} = ':';
pol = squeeze(player.Policy(pStateRef{:}));

if strcmp(mode, 'train') == 1 
    maxPol = max(max(pol));
    noTie = find(pol + PolicyTieTolerance < maxPol);
    pol(noTie) = 0;
    % find nonZero entries, choose uniformly from equal policies
    nonZero = find(pol);
    if isempty(nonZero)
        nonZero = 1:(size(pol,1) * size(pol,2));
    end
    choice = ceil(rand * length(nonZero));
    [oAct, aAct] = ind2sub(size(pol), nonZero(choice));

else
    nonZero = find(pol);
    numPol = length(nonZero);
    polCumSum = cumsum(pol(nonZero));
    rChoice = rand;
    chosenAction = nonZero(numPol);
    for action = 1:numPol
        if rChoice <= polCumSum(action)
            [oAct, aAct] = ind2sub(size(pol),nonZero(action));
            break;
        end
    end
end
if player.team == 1
    p1Act = aAct;
    p2Act = oAct;
else
    p1Act = oAct;
    p2Act = aAct;
end
