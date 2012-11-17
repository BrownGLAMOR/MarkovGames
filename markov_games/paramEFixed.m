%-----------------------------------------------------------------------
% function paramSet = params(aType, aParams, eType, eParams, gamma, nIter)
%
%-----------------------------------------------------------------------
function paramSet = paramEFixed(numIter, fixedE, fixedA)

if nargin < 3
    paramSet = Params('Exponential', [1, .01], 'Fixed', [fixedE], .9, numIter);
else
    paramSet = Params('Fixed', fixedA, 'Fixed', fixedE, .9, numIter);
end
