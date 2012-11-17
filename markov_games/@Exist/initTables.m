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
case 'StateSingleAction'
    qTable = ones(game.numStates, numActions);
    if team == 1
        qTable(2, 2) = 0;
    else
        qTable(1, 2) = 0;
    end
    for i = 1:game.numStates
        policy(i, :) = qTable(i, :) / sum(qTable(i, :));
    end
case {'StateDoubleAction', 'StateDoubleJointAction'}
    qTable = ones([game.numStates, numActions, numActions]);
    if team == 1
        qTable(1, 2, :) = 0;
        qTable(2, :, 2) = 0;
    else
        qTable(1, :, 2) = 0;
        qTable(2, 2, :) = 0;
    end
    if strcmp(tableType, 'StateDoubleAction')
        for i = 1:game.numStates
            qSum = sum(qTable(i,1,:));
            if qSum < 1e-3
                policy(i, :) = zeros(1,numActions);
            else
                policy(i, :) = ...
                        qTable(i, 1, :) / sum(qTable(i, 1, :));
            end
        end
    elseif strcmp(tableType, 'StateDoubleJointAction')
        for i = 1:game.numStates
            policy(i, :, :) = qTable(i, :, :) / sum(sum(qTable(i, :, :)));
        end
    else
        %should not be possible to get here
        error([tableType,' Not implimented ... yet']);
    end
otherwise
    error([tableType,' Is not a valid tableType']);
end
