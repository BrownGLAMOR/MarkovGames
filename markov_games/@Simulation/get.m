%-----------------------------------------------------------------------
% File: get
%
% Description:
%   get stuff from Simulate class
%
%-----------------------------------------------------------------------
function value = get(simul, memberName, player)

switch memberName
    case 'Teams'
        value = simul.teams;
    case 'Game'
        value = simul.game;
    case 'TeamType'
        value = simul.teamType;
    case 'NumTeams'
        value = simul.numTeams;
    case 'IsAdaptiveAlg'
        value = simul.isAdaptiveAlg;
    case 'NumIter'
        value = simul.numIter;
    case 'NormGamma'
        value = simul.normGamma;
    case 'ParamSet'
        value = simul.paramSet;
    case 'HistFile' 
        value = simul.histFile;
    case 'PolicyHist'
        value = simul.policyHist;
    otherwise
        error([memberName,' Is not a valid member name']);
end
