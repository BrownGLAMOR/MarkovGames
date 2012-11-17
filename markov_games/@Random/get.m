%-----------------------------------------------------------------------
% Funciton: get(this, memberName)
%
% Description:
%
%
%-----------------------------------------------------------------------
function value = get(player, memberName)

switch memberName
    case 'Team'
        value = player.team
    case 'Policy'
        value = player.Policy
    otherwise
        error([memberName,' Is not a valid member name']);
end
