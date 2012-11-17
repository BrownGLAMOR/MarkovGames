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
sLen = length(curState);
pStateRef{sLen + 1} = ':';
actList = find(squeeze(player.Policy(pStateRef{:})));
numAct = length(actList);

actId = ceil(rand * numAct);
chosenAction = actList(actId);
