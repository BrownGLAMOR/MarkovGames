%-----------------------------------------------------------------------
% Class: QLearner (Constructor)
%
%
%-----------------------------------------------------------------------
function player = QLearner(teamNum, game, ndMode, paramSet, normGamma)

global QLearnerTolerance;
QLearnerTolerance = .001;

if nargin < 5
    player.normGamma = 'noGammaNorm';
else
    switch normGamma
    case 'NoGammaNorm'
    case 'GammaNorm'
    otherwise
        error(['(QLearner) Unknown Norm Gamma type: ', normGamma]);
    end
    player.normGamma = normGamma;
end
if teamNum == 1
    disp(['QLearner gamma setting: ', player.normGamma]);
end

player.team = teamNum;
player.numActions = get(game, 'NumActions');
player.gamma = get(paramSet, 'Gamma');

global DeterministicMode;
DeterministicMode = 1;
global NonDeterministicMode;
NonDeterministicMode = 2;
global NoBiasDeterministicMode;
NoBiasDeterministicMode = 3;
% length of state array
switch ndMode
    case 'deterministic'
        player.ndMode = DeterministicMode;
    case 'nobiasdeterministic'
        player.ndMode = NoBiasDeterministicMode;
    case 'nondeterministic'
        player.ndMode = NonDeterministicMode;
    otherwise
        error(['Invalid QLearner ND mode: ', ndMode]);
end
player.game = game;
player.stateDim = get(game, 'GameStateDim');
player.sLen = length(player.stateDim);
player.paramSet = set(paramSet, 'GameDims', ...
              [player.stateDim, player.numActions]);
[player.Qvalues, player.Policy] = ...
                            initTables(game, teamNum, 'StateSingleAction');
player.initQvalues = player.Qvalues;
player.Qvalues = player.Qvalues .* 0;

player.numUpdates = 0;

%-------------------------------------
% Not used at all
oppVec = [];
player.opponent = 0;
% Not used at all
%-------------------------------------

player = class(player, 'QLearner');
