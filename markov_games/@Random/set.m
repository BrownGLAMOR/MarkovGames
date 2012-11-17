%-----------------------------------------------------------------------
% Funciton: set(player, memberName, value)
%
% Description:
%
%
%-----------------------------------------------------------------------
function player = get(player, varargin)

property_argin = varargin;
while length(property_argin) >= 2,
    memberName = property_argin{1};
    value = property_argin{2};
    property_argin = property_argin(3:end);
    switch memberName
        case 'Team'
            player.team = value;
        otherwise
            error([memberName,' Is not a valid member name']);
    end
end
