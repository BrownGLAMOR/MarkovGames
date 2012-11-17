%-----------------------------------------------------------------------
% Class: Friend (Constructor)
%
%
%-----------------------------------------------------------------------
function player = Friend(teamNum, game, paramSet, normGamma)

if nargin < 4
    player.normGamma = 'noGammaNorm';
else
    switch normGamma
    case 'NoGammaNorm'
    case 'GammaNorm'
    otherwise
        error(['(Friend-Q) Unknown Norm Gamma type: ', normGamma]);
    end
    player.normGamma = normGamma;
end
if teamNum == 1
    disp(['Friend-Q gamma setting: ', player.normGamma]);
end
player.team = teamNum;
oppVec = [2 1];
player.opponent = oppVec(teamNum);

player.numActions = get(game, 'NumActions');
player.gamma = get(paramSet, 'Gamma');

player.game = game;
player.stateDim = get(game, 'GameStateDim');
player.sLen = length(player.stateDim);
player.paramSet = set(paramSet, 'GameDims', [player.stateDim, player.numActions, player.numActions]);

[player.Qvalues, player.Policy] = initTables(game, teamNum, 'StateDoubleAction');
player.initQvalues = player.Qvalues;
player.Qvalues = player.Qvalues .* 0;

player.numUpdates = 0;

% optimization routine options
player = class(player, 'Friend');
