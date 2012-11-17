%-----------------------------------------------------------------------
% Funciton: set(paramset, memberName, value)
%
% Description:
%
%
%-----------------------------------------------------------------------
function game = set(game, varargin)

property_argin = varargin;
while length(property_argin) >= 2,
    memberName = property_argin{1};
    value = property_argin{2};
    property_argin = property_argin(3:end);
    switch memberName
        case 'State'
            game.position{1} = [value{1} value{2}];
            game.position{2} = [value{3} value{4}];
        otherwise
            error(['Invalid member: ', memberName]);
    end
end
