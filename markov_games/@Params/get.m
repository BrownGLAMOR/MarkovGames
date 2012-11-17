%-----------------------------------------------------------------------
% Funciton: get(paramset, memberName)
%
% Description:
%
%
%-----------------------------------------------------------------------
function value = get(paramset, memberName)

global DecayStateExponential;
global DecayStateFractional;
global DecayExponential;
global DecayFractional;
global DecayFixed;
global DecayUniform;
switch memberName
    case 'AlphaType'
        switch paramset.alphaType
            case DecayStateExponential
                value = 'StateExponential';
            case DecayExponential
                value = 'Exponential';
            case DecayStateFractional
                value = 'StateFractional';
            case DecayFractional
                value = 'Fractional';
            case DecayFixed
                value = 'Fixed';
            case DecayUniform
                value = 'Uniform';
        end
    case 'PrevAlpha'
        value = paramset.prevAlpha;
    case 'AlphaDecay'
        value = paramset.alphaDecay;
    case 'InitAlpha'
        value = paramset.initAlpha;
    case 'AlphaVals'
        value = paramset.alphaUniVals;
    case 'ExploreType'
        switch paramset.exploreType
            case DecayExponential
                value = 'Exponential';
            case DecayFractional
                value = 'Fractional';
            case DecayFixed
                value = 'Fixed';
            case DecayUniform
                value = 'Uniform';
        end
    case 'PrevExplore'
        value = paramset.prevExplore;
    case 'ExploreDecay'
        value = paramset.exploreDecay;
    case 'InitExplore'
        value = paramset.initExplore;
    case 'ExploreVals'
        value = paramset.epsUniVals;
    case 'Gamma'
        value = paramset.gamma;
    case 'NumIter'
        value = paramset.numIter;
    case 'PerturbEps'
        value = paramset.perturbEps;
    otherwise
            error(['Invalid member: ', memberName]);
end
