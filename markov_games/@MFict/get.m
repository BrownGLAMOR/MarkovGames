%-----------------------------------------------------------------------
% Funciton: get(player, memberName)
%
% Description:
%
%
%-----------------------------------------------------------------------
function value = get(player, memberName)

switch memberName
    case 'Team'
        value = player.team;
    case 'QTable'
        disp(['Try get(p, ''Counts'')']);
        value = player.Counts;
    case 'Counts'
        value = player.Counts;
    case 'Tables'
        value{1} = player.Counts;
    case 'Gamma'
        value = player.gamma;
    case 'NumUpdates'
        value = player.numUpdates;
    case 'Game'
        value = player.game;
    case 'ParamSet'
        value = player.paramSet;
    case 'InitPolicy'
        value = player.initPolicy;
    otherwise
        error([memberName,' Is not a valid member name']);
end
