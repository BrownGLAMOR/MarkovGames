%-----------------------------------------------------------------------
% Funciton: set(paramset, memberName, value)
%
% Description:
%
%
%-----------------------------------------------------------------------
function paramset = set(paramset, varargin)

global DecayStateExponential;
global DecayStateFractional;
global DecayExponential;
global DecayFractional;
global DecayFixed;
global DecayUniform;

property_argin = varargin;
while length(property_argin) >= 2,
    memberName = property_argin{1};
    value = property_argin{2};
    property_argin = property_argin(3:end);
    switch memberName
        case 'Gamma'
            paramset.gamma = value;
        case 'NumIter'
            paramset.numIter = value;
        case 'AvgIter'
            paramset.avgIter = value;
            if paramset.alphaType == DecayStateExponential
                paramset.alphaDecay = ...
                    10^(log10(alphaParams(2)/alphaParams(1))/paramset.avgIter);
            end
        case 'GameDims'
            paramset.gameDims = value;
            if paramset.alphaType == DecayUniform | ...
               paramset.alphaType == DecayStateFractional
                paramset.alphaUniVals = zeros(paramset.gameDims);
            elseif paramset.alphaType == DecayStateExponential
                paramset.alphaUniVals = ...
                    ones(paramset.gameDims) .* paramset.prevAlpha;
            end
            if paramset.exploreType == DecayUniform 
                paramset.epsUniVals = zeros(paramset.gameDims);
            end
        case 'AlphaVals'
            paramset.alphaUniVals = value;
        case 'AlphaInit'
            paramset.initAlpha = value;
        case 'ExploreVals'
            paramset.epsUniVals = value;
        otherwise
            error(['Invalid member: ', memberName]);
    end
end
