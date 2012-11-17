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
        case 'ParamSet'
            player.paramSet = value;
            player.gamma = get(value, 'Gamma');
        case 'QTable'
            player.Qvalues = value;
        case 'Policy'
            player.Policy = value;
        case 'CEType'
            player.ceType = value;
            player.updateAllPolicies = 0;
            switch player.ceType
                case 'lax'
                case 'utilitarian'
                case 'egalitarian'
                case 'republican'
                case 'libertarian'
                    player.updateAllPolicies = 1;
                otherwise
                    error(['(CorrEQ) Unknown CE player type: ', ceType]);
            end
        otherwise
            error([memberName,' Is not a valid member name']);
    end
end
