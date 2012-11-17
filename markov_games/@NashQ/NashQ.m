%-----------------------------------------------------------------------
% Class: NashQ (Constructor)
%
%
%-----------------------------------------------------------------------
function player = NashQ(teamNum, game, paramSet, neType, normGamma)

addpath 'NashLCP'

if nargin < 4
    player.neType = 'first';
else
    player.neType = neType;
end
if nargin < 5
    player.normGamma = 'noGammaNorm';
else
    switch normGamma
    case 'NoGammaNorm'
    case 'GammaNorm'
    otherwise
        error(['(NashQ) Unknown Norm Gamma type: ', normGamma]);
    end
    player.normGamma = normGamma;
end
if teamNum == 1
    disp(['NashQ gamma setting: ', player.normGamma]);
end
player.updateAllPolicies = 1;
switch player.neType
    case 'first'
    case 'second'
    case 'best'
    case 'coord'
        player.updateAllPolicies = 0;
    otherwise
        error(['(NashQ) Unknown NashQ player type: ', neType]);
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
[player.Qvalues, tmpPolicy] = ...
            initTables(game, teamNum, 'StateDoubleAction');

% 2-player ONLY!!!  LCP solution is only for 2 players
player.Policy{1} = tmpPolicy;
player.Policy{2} = tmpPolicy;
player.initQvalues = player.Qvalues;
player.Qvalues = player.Qvalues .* 0;

player.numUpdates = 0;
player = class(player, 'NashQ');
