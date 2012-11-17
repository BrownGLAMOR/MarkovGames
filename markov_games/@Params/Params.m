%-----------------------------------------------------------------------
% Class: Params (Constructor)
%
% Encapsulate a set of parameters
% Decay Types:
%       Exponential: 
%           prevAlpha = alphaParams(1)
%           newAlpha = prevAlpha * 10^(log10(alphaParam(2))/numIter);
%       Fractional:
%           newAlpha = alphaParam(1) * 
%                 ((numIter/(1/endval) + 1) / (numIter /(1/endval)+ curIter))
%       Fixed:
%           newAlpha = alphaParam(1)
%
% Exploration is similar
%
%-----------------------------------------------------------------------
function paramset = Params(alphaType, alphaParams, exploreType, exploreParams, gamma, numIter,avgIter, perturbEps)
global TestMode;
global TrainMode;
TestMode = 1;
TrainMode = 2;
global DecayStateExponential;
global DecayStateFractional;
global DecayExponential;
global DecayFractional;
global DecayFixed;
global DecayUniform;
DecayExponential = 1;
DecayFractional = 2;
DecayFixed = 3;
DecayUniform = 4;
DecayStateExponential = 5;
DecayStateFractional = 6;

if nargin < 7
    paramset.avgIter = 0;
else
    paramset.avgIter = avgIter;
end

if nargin < 8
    paramset.perturbEps = 0;
else
    paramset.perturbEps = perturbEps;
end

paramset.gameDims = [];
paramset.alphaUniVals = [];
paramset.epsUniVals = [];

paramset.prevAlpha = 0;
paramset.alphaDecay = 0;
paramset.initAlpha = 0;
paramset.invEndAlpha = 0;
switch alphaType
    case 'Exponential'
        paramset.alphaType = DecayExponential;
        paramset.prevAlpha = alphaParams(1);
        paramset.alphaDecay = 10^(log10(alphaParams(2)/alphaParams(1))/numIter);
    case 'Fractional'
        paramset.alphaType = DecayFractional;
        paramset.initAlpha = alphaParams(1);
        if alphaParams(2) == 0
            alphaparams(2) = 1e-10;
        end
        paramset.invEndAlpha = 1/alphaParams(2) * paramset.initAlpha;
    case 'Fixed'
        paramset.alphaType = DecayFixed;
        paramset.initAlpha = alphaParams;
    case 'StateExponential'
        paramset.alphaType = DecayStateExponential;
        paramset.prevAlpha = alphaParams(1);
        if paramset.avgIter > 0
            paramset.alphaDecay = ...
                10^(log10(alphaParams(2)/alphaParams(1))/paramset.avgIter);
        end
    case 'StateFractional'
        paramset.alphaType = DecayStateFractional;
        paramset.initAlpha = alphaParams(1);
        if alphaParams(2) == 0
            alphaparams(2) = 1e-10;
        end
        paramset.invEndAlpha = 1/alphaParams(2) * paramset.initAlpha;
    case 'Uniform'
        paramset.alphaType = DecayUniform;
    otherwise
        error(['Invalid AlphaType ', alphaType]);
end

paramset.prevExplore = 0;
paramset.exploreDecay = 0;
paramset.initExplore = 0;
paramset.invEndExplore = 0;
switch exploreType
    case 'Exponential'
        paramset.exploreType = DecayExponential;
        paramset.prevExplore = exploreParams(1);
        paramset.exploreDecay = ...
                        10^(log10(exploreParams(2)/exploreParams(1))/numIter);
    case 'Fractional'
        paramset.exploreType = DecayFractional;
        paramset.initExplore = exploreParams(1);
        if exploreParams(2) == 0
            exploreParams(2) = 1e-10;
        end
        paramset.invEndExplore = 1/exploreParams(2) * paramset.initExplore;
    case 'Fixed'
        paramset.exploreType = DecayFixed;
        paramset.initExplore = exploreParams(1);
    case 'Uniform'
        paramset.exploreType = DecayUniform;
    otherwise
        error(['Invalid ExploreType ', exploreType]);
end

paramset.numIter = numIter;
paramset.numUpdates = 0;


paramset.gamma = gamma;

paramset = class(paramset, 'Params');
