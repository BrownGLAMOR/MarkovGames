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
        value = player.Qvalues;
    case 'Policy'
        value = player.Policy;
    case 'Tables'
        value{1} = player.Qvalue;
        value{2} = player.Policy;
    case 'Gamma'
        value = player.gamma;
    case 'NormGamma'
        value = player.normGamma;
    case 'NumUpdates'
        value = player.numUpdates;
    case 'Game'
        value = player.game;
    case 'ParamSet'
        value = player.paramSet;
    case 'InitQValues'
        value = player.initQvalues;
    otherwise
        error([memberName,' Is not a valid member name']);
end
