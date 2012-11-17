%-----------------------------------------------------------------------
% File:
%
% Description:
%
%-----------------------------------------------------------------------
function display(paramset)

global DecayStateExponential;
global DecayStateFractional;
global DecayExponential;
global DecayFractional;
global DecayFixed;
global DecayUniform;
dispStr = ['AlphaType: '];
switch paramset.alphaType
    case DecayExponential
        dispStr = [dispStr, 'Exponential decay (', ...
                   num2str(paramset.alphaDecay), ') curAlpha (', ...
                   num2str(paramset.prevAlpha), ')'];
    case DecayFractional
        dispStr = [dispStr, 'Fractional init value (', ...
                   num2str(paramset.initAlpha), ') end value (', ...
                   num2str(paramset.initAlpha/paramset.invEndAlpha), ')'];
    case DecayFixed
        dispStr = [dispStr, 'Fixed value (', num2str(paramset.initAlpha), ')'];
    case DecayStateExponential
        dispStr = [dispStr, 'State Exponential decay (', ...
                   num2str(paramset.alphaDecay), ') curAlpha (', ...
                   num2str(paramset.prevAlpha), ') avgIter (', ...
                   num2str(paramset.avgIter), ')'];
    case DecayStateFractional
        dispStr = [dispStr, 'State Fractional init value (', ...
                   num2str(paramset.initAlpha), ') end value (', ...
                   num2str(paramset.initAlpha/paramset.invEndAlpha), ...
                   ') avgIter (', num2str(paramset.avgIter), ')'];
    case DecayUniform
        dispStr = [dispStr, 'Uniform'];
    otherwise
        error(['Invalid AlphaType ', alphaType]);
end
disp(dispStr);

dispStr = ['ExploreType: '];
switch paramset.exploreType
    case DecayExponential
        dispStr = [dispStr, 'Exponential decay (', ...
                   num2str(paramset.exploreDecay), ') curExplore (', ...
                   num2str(paramset.prevExplore), ')'];
    case DecayFractional
        dispStr = [dispStr, 'Fractional init value (', ...
                   num2str(paramset.initExplore), ') end value (', ...
                   num2str(paramset.initExplore/paramset.invEndExplore), ')'];
    case DecayFixed
        dispStr = [dispStr,'Fixed value (', num2str(paramset.initExplore), ')'];
    case DecayUniform
        dispStr = [dispStr, 'Uniform'];
    otherwise
        error(['Invalid ExploreType ', exploreType]);
end
disp(dispStr);

disp(['PerturbEps: ', num2str(paramset.perturbEps)]);
disp(['Gamma: ', num2str(paramset.gamma)]);
disp(['Playing game for ', num2str(paramset.numIter), ' iterations']);
