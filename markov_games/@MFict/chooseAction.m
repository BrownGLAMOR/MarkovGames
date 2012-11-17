%-----------------------------------------------------------------------
% File: chooseAction
%
% Description:
%   Choose the action with is most likely to get us
%   top a desirable state.  Use historical data to
%   determine this likelihood.
%
%-----------------------------------------------------------------------
function chosenAction = chooseAction(player, curState, mode)

global MFictTolerance;

payoffs = get(player.game, 'Payoffs');
bestAct = [];
switch player.type
case 'conditional'
    dists = player.Counts ./ repmat(sum(player.Counts), player.numStates, 1);
    bestActE = 0;
    for action = 1:player.numActions
        actE = 0;
        for state = 1:player.numStates
            actE = actE + (dists(state,action) * payoffs{state}(action));
        end
        if (actE + MFictTolerance) >= bestActE
            if actE <= (bestActE + MFictTolerance)
                bestAct = [bestAct action];
            else
                bestAct = action;
                bestActE = actE;
            end
        end
    end
case 'standard'
    error(['don''t use this for now...']);
    dists = player.Counts ./ sum(sum(player.Counts));
    bestActE = 0;
    for action = 1:player.numActions
        actE = 0;
        for state = 1:player.numStates
            actE = actE + (dists(state,action) * payoffs{state}(action));
        end
        if (actE + MFictTolerance) >= bestActE
            if actE <= (bestActE + MFictTolerance)
                bestAct = [bestAct action];
            else
                bestAct = action;
                bestActE = actE;
            end
        end
    end
case 'allPlayer'
    %Major hack for SFBP
    if isa(player.game, 'SFBP') == 0
        error(['Only works for SFBP']);
    end
    sumCounts = sum(player.Counts');
    if sumCounts(1) > sumCounts(2)
        bestAct = 1;
    elseif sumCounts(2) > sumCounts(1)
        bestAct = 2;
    else
        bestAct = [1,2];
    end
otherwise
    error(['Unknown player type: ', player.type]);
end
if isempty(bestAct)
    error(['MFict: error selecting an action']);
end

if length(bestAct) > 1
    chosenAction = bestAct(ceil(rand * length(bestAct)));
else
    chosenAction = bestAct;
end
