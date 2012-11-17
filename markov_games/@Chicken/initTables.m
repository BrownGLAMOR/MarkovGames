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
    qTable(1, :) = [1 1];
    policy(1, :) = [.5 .5];
case {'StateDoubleAction', 'StateDoubleJointAction'}
    qTable(1,:,:) = [1 1; 1 1];
    if strcmp(tableType, 'StateDoubleAction')
        policy(1,:) = [.5, .5];
    elseif strcmp(tableType, 'StateDoubleJointAction')
        policy(1,:,:) = [.25 .25; .25 .25];
    else
        %should not be possible to get here
        error([tableType,' Not implimented ... yet']);
    end
otherwise
    error([tableType,' Is not a valid tableType']);
end
