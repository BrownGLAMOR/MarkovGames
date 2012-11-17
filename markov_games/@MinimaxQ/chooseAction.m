%-----------------------------------------------------------------------
% File: chooseAction
%
% Description:
%       Choose an action on-policy
%       randomly select an action based on current policy
%
%-----------------------------------------------------------------------
function chosenAction = chooseAction(player, curState, mode)

pStateRef = curState;
pStateRef{player.sLen + 1} = ':';
policy = squeeze(player.Policy(pStateRef{:}));
nonZero = find(policy);

numPol = length(nonZero);
polCumSum = cumsum(policy(nonZero));
rChoice = rand;
chosenAction = nonZero(numPol);
for action = 1:numPol
    if rChoice <= polCumSum(action)
        chosenAction = nonZero(action);
        break;
    end
end
