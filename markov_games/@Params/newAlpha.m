%-----------------------------------------------------------------------
%
% function [paramSet, curAlpha] = newAlpha(paramSet)
%   - return the current alpha determined by the paremters set
%   - updates the number of alpha calcs have been made
%
%-----------------------------------------------------------------------
function [paramSet, curAlpha] = newAlpha(paramSet, state)

global DecayStateExponential;
global DecayStateFractional;
global DecayExponential;
global DecayFractional;
global DecayFixed;
global DecayUniform;
paramSet.numUpdates = paramSet.numUpdates + 1;
switch paramSet.alphaType
    case DecayExponential
        curAlpha = paramSet.prevAlpha * paramSet.alphaDecay;
        paramSet.prevAlpha = curAlpha;
    case DecayFractional
        curAlpha = paramSet.initAlpha * ...
                 ((paramSet.numIter/paramSet.invEndAlpha + 1) / ...
                 (paramSet.numIter/paramSet.invEndAlpha + paramSet.numUpdates));
    case DecayFixed
        curAlpha = paramSet.initAlpha;
    case DecayStateExponential
        if paramSet.avgIter == 0
            error('State-wise exponential decay requires avgIter to be set');
        end
        curAlpha = paramSet.alphaUniVals(state{:}) * paramSet.alphaDecay;
        paramSet.alphaUniVals(state{:}) = curAlpha;
    case DecayStateFractional
        paramSet.alphaUniVals(state{:}) = ...
                            paramSet.alphaUniVals(state{:}) + 1;
        curAlpha = paramSet.initAlpha * ...
                 ((paramSet.avgIter/paramSet.invEndAlpha + 1) / ...
                 (paramSet.avgIter/paramSet.invEndAlpha + ...
                  paramSet.alphaUniVals(state{:})));
    case DecayUniform
        if nargin < 2
            error(['Param uniform alpha must be passed state']);
        end
        paramSet.alphaUniVals(state{:}) = ...
                            paramSet.alphaUniVals(state{:}) + 1;
        curAlpha = 1/paramSet.alphaUniVals(state{:});
    otherwise
        error(['Invalid alphaType: ', int2str(paramSet.exporeType)]);
end
