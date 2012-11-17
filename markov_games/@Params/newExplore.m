%-----------------------------------------------------------------------
%
% function [paramSet, curExplore] = newExplore(paramSet)
%   - return the current explore determined by the paremters set
%   - updates the number of explore calcs have been made
%
%-----------------------------------------------------------------------
function [paramSet, curExplore] = newExplore(paramSet, state)

global DecayExponential;
global DecayFractional;
global DecayFixed;
global DecayUniform;
paramSet.numUpdates = paramSet.numUpdates + 1;
switch paramSet.exploreType
    case DecayExponential
        curExplore = paramSet.prevExplore * paramSet.exploreDecay;
        paramSet.prevExplore = curExplore;
    case DecayFractional
        curExplore = paramSet.initExplore * ...
               ((paramSet.numIter/paramSet.invEndExplore + 1) / ...
               (paramSet.numIter/paramSet.invEndExplore + paramSet.numUpdates));
    case DecayFixed
        curExplore = paramSet.initExplore;
    case DecayUniform
        if nargin < 2
            error(['Param uniform epsilon must be passed state']);
        end
        paramSet.epsUniVals(state{:}) = ...
                            paramSet.epsUniVals(state{:}) + 1;
        curExplore = 1/paramSet.epsUniVals(state{:});
    otherwise
        error(['Invalid exploreType: ', int2str(paramSet.exporeType)]);
end
