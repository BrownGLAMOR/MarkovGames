%-----------------------------------------------------------------------
% Funciton: initPolicy
%
%   returns a game grid with the valid actions for this team
%   and hasball status.
%       only handles action set that is a numActions or numActions^2
%
%-----------------------------------------------------------------------
function [qTable, policy] = initTables(game, team, tableType)

numActions = game.numActions;
switch tableType
case 'SimpleState'
    qTable = ones(game.numStates, numActions);
    policy = ones(game.numStates, numActions) / numActions;
    if strcmp(game.gameType, 'waiting') == 1
        qTable(2, 2:end) = 0;
        policy(2, :) = qTable(2,:);
    end
case 'StateSingleAction'
    qTable = ones(game.numStates, numActions);
    policy = ones(game.numStates, numActions) / numActions;
    if strcmp(game.gameType, 'waiting') == 1
        qTable(2, 2:end) = 0;
        policy(2, :) = qTable(2,:);
    end
case {'StateDoubleAction', 'StateDoubleJointAction'}
    error([tableType,' Not implimented ... yet']);
otherwise
    error([tableType,' Is not a valid tableType']);
end
