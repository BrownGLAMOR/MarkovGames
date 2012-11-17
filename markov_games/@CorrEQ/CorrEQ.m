%-----------------------------------------------------------------------
% Class: CorrEQ (Constructor)
%
%
%-----------------------------------------------------------------------
function player = CorrEQ(teamNum, game, paramSet, ceType, normGamma)

if nargin < 4
    player.ceType = 'utilitarian';
else
    player.ceType = ceType;
end
if nargin < 5
    player.normGamma = 'noGammaNorm';
else
    switch normGamma
    case 'NoGammaNorm'
    case 'GammaNorm'
    otherwise
        error(['(CorrEQ) Unknown Norm Gamma type: ', normGamma]);
    end
    player.normGamma = normGamma;
end
if teamNum == 1
    disp(['CorrEQ gamma setting: ', player.normGamma]);
end
player.updateAllPolicies = 0;
switch player.ceType
    case 'lax'
    case 'utilitarian'
    case 'egalitarian'
    case 'republican'
    case 'libertarian'
        player.updateAllPolicies = 1;
    otherwise
        error(['(CorrEQ) Unknown CE player type: ', ceType]);
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
player.paramSet = set(paramSet, 'GameDims', ...
              [player.stateDim, player.numActions, player.numActions]);
% length of state array
[player.Qvalues, player.Policy] = ...
            initTables(game, teamNum, 'StateDoubleJointAction');
player.initQvalues = player.Qvalues;
player.Qvalues = player.Qvalues .* 0;

player.numUpdates = 0;
player = class(player, 'CorrEQ');
