%-----------------------------------------------------------------------
% File: randAction
%
% Description:
%       choose an action uniformly at random from the valid actions
%
%-----------------------------------------------------------------------
function [action1, action2] = randAction(team, game, curState, numActions)

actList1 = [];
actList2 = [];
for act = 1:numActions
    if nargout > 1 
        if checkAction(game, curState, 2, act) == 1
            actList2 = [actList2 act];
        end
        team = 1;
    end
    if checkAction(game, curState, team, act) == 1
        actList1 = [actList1 act];
    end
end
numAct = length(actList1);
actId = ceil(rand * numAct);
action1 = actList1(actId);
if nargout > 1
    numAct = length(actList2);
    actId = ceil(rand * numAct);
    action2 = actList2(actId);
end
