%-----------------------------------------------------------------------
% function paramSet = params(aType, aParams, eType, eParams, gamma, nIter)
%
% Encapsulate a set of parameters
% Decay Types:
%       Exponential: 
%           prevAlpha = alphaParams(1)
%           newAlpha = prevAlpha * 10^(log10(alphaParam(2))/numIter);
%       Fractional:
%           newAlpha = alphaParam(1) * 
%                                ((numIter/10 + 1) / (numIter / 10 + curIter))
%       Fixed:
%           newAlpha = alphaParam(1)
%
%-----------------------------------------------------------------------
function paramSet = params(numIter, epsInfo, alphaInfo, gamma, perturbEps)

if nargin < 4
    gamma = 1;
end
if nargin < 5
    avgIter = 0;
end

if isempty(epsInfo)
    epsType = 'Uniform';
elseif length(epsInfo) < 2
    epsType = 'Fixed';
else
    epsType = 'Fractional';
end
if nargin < 3
    paramSet = Params('Exponential', [1, .01], epsType, epsInfo, ...
                      gamma, numIter, 0, perturbEps);
else
    if isempty(alphaInfo)
        paramSet = Params('Uniform', [], epsType, epsInfo, gamma, numIter, 0, perturbEps);
    elseif length(alphaInfo) < 2
        paramSet = Params('Fixed', alphaInfo, epsType, epsInfo, gamma, numIter, 0, perturbEps);
    elseif length(alphaInfo) < 3
        paramSet = Params('Exponential', alphaInfo, epsType, epsInfo, ...
                          gamma, numIter, 0, perturbEps);
    else
        paramSet = Params('StateExponential', alphaInfo(1:2), epsType, ...
                          epsInfo, gamma, numIter, alphaInfo(3), perturbEps);
    end
end
