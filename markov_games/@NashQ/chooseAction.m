%-----------------------------------------------------------------------
% File: chooseAction
%
% Description:
%       Choose an action on-policy
%       randomly select an action based on current policy
%
%-----------------------------------------------------------------------
function [act] = chooseAction(player, curState, mode)

global PolicyTieTolerance;

pStateRef = curState;
pStateRef{player.sLen + 1} = ':';
% a vector
pol = squeeze(player.Policy{1}(pStateRef{:}));

if strcmp(mode, 'train') == 1 
    maxPol = max(pol);
    noTie = find(pol + PolicyTieTolerance < maxPol);
    pol(noTie) = 0;
    % find nonZero entries, choose uniformly from equal policies
    nonZero = find(pol);
    if isempty(nonZero)
        nonZero = 1:size(pol,1);
    end
    choice = ceil(rand * length(nonZero));
    act = nonZero(choice);

else
    nonZero = find(pol);
    numPol = length(nonZero);
    polCumSum = cumsum(pol(nonZero));
    rChoice = rand;
    act = nonZero(numPol);
    for action = 1:numPol
        if rChoice <= polCumSum(action)
            act = nonZero(action);
            break;
        end
    end
end
