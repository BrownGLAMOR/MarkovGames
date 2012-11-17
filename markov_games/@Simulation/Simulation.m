%-----------------------------------------------------------------------
% Funciton: Simulation (constructor)
% [teams, game] = 
%      playGame(game, teamType, paramSet, teams, debugLevel, histFile, runMode)
%
%-----------------------------------------------------------------------
function simul = Simulation(game, teamType, paramSet, teams, ...
                    debugLevel, histFile, runMode, numTeams, normGamma, policyHist, isAdaptive)

% the following should be paths from where   matlab is started...
addpath 'lpmex';
addpath 'cplex_mex';

global PolicyTieTolerance;
global InternalDebug;
PolicyTieTolerance = .001;

% 
% General setup - set vars for main loop, etc.
%
if nargin < 8
    numTeams = 2;
    disp(['Setting number of teams = 2']);
else
    if (isempty(teams))
        disp(['Number of ', teamType, ' teams = ', num2str(numTeams)]);
    else
        disp(['Number of ', class(teams{1}), ' teams = ', num2str(numTeams)]);
    end
end

if nargin < 9
    normGamma = 0;
end

if normGamma 
    simul.normGamma = 'GammaNorm';
else
    simul.normGamma = 'NoGammaNorm';
end

if nargin < 10
    policyHist = 'long';
end
simul.DisplayIter = 0;
simul.teamType = teamType;
simul.numTeams = numTeams;
simul.game = game;
simul.isAdaptiveAlg = 0;
simul.numIter = get(paramSet, 'NumIter');
simul.histFile = histFile;
simul.policyHist = policyHist;
simul.teams = [];

% display the parameter set
paramSet
simul.paramSet = paramSet;
simul.runMode = '';

simul = class(simul, 'Simulation');
%set up the team information
if isempty(teams)
    simul.runMode = 'train';
    simul = getTeams(simul);
else
    simul.teams = teams;
    if nargin >= 11 & isAdaptive
        simul.isAdaptiveAlg = 1;
    end
    if nargin < 7
        simul.runMode = 'test';
    else
        simul.runMode = runMode;
        switch runMode
        case 'test'
            disp(['Testing']);
        case 'train'
            disp(['Training']);
        otherwise
            error(['Unknown run mode: ', runMode]);
        end
    end
end
simul = setDebug(simul, debugLevel);

