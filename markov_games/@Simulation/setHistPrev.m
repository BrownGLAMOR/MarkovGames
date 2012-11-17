%-----------------------------------------------------------------------
% File: setHistPrev
%
% Description:
%   Sets the history information for the Previous q-values
%
%-----------------------------------------------------------------------
function [history, qPrev] = setHistPrev(simul, history, stateLen, curState, ...
                                        newState, actions, iteration, tNum)

oppTeam = [2 1];
qPrev = getQ(simul.teams{tNum},curState, actions);
if simul.numTeams == 2
    opp = oppTeam(tNum);
    for i = 1:stateLen
        history(tNum, i) = curState{i};
    end
    history(tNum, stateLen + 1) = actions(opp);
    history(tNum, stateLen + 2) = actions(tNum);
    history(tNum, stateLen + 3) = qPrev;
else
    history(1) = iteration;
    history(2) = tNum;
    history(3) = newState{1};
    history(4) = actions(tNum);
    history(5) = qPrev;
end
