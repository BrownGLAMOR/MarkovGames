%-----------------------------------------------------------------------
% Class: MinimaxQ (Constructor)
%
%
%-----------------------------------------------------------------------
function player = MinimaxQ(teamNum, game, paramSet, normGamma)

if nargin < 4
    player.normGamma = 'noGammaNorm';
else
    switch normGamma
    case 'NoGammaNorm'
    case 'GammaNorm'
    otherwise
        error(['(Minimax-Q/Foe-Q) Unknown Norm Gamma type: ', normGamma]);
    end
    player.normGamma = normGamma;
end
if teamNum == 1
    disp(['Minimax-Q/Foe-Q gamma setting: ', player.normGamma]);
end
player.team = teamNum;
oppVec = [2 1];
player.opponent = oppVec(teamNum);

player.gamma = get(paramSet, 'Gamma');

player.game = game;
player.numPlayers = get(game, 'NumPlayers');
player.numActions = get(game, 'NumActions');
player.stateDim = get(game, 'GameStateDim');
player.sLen = length(player.stateDim);
player.paramSet = set(paramSet, 'GameDims', [player.stateDim, player.numActions, player.numActions]);
% length of state array
[player.Qvalues, player.Policy] = initTables(game, teamNum, 'StateDoubleAction');
player.initQvalues = player.Qvalues;
player.Qvalues = player.Qvalues .* 0;

player.numUpdates = 0;

player = class(player, 'MinimaxQ');
