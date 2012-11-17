%-----------------------------------------------------------------------
% Class: MFict (Constructor)
%
% Fictitious play (only works with SFBP for now)
%
%-----------------------------------------------------------------------
function player = MFict(teamNum, game, paramSet, type, desiredStates)

if strcmp(class(game), 'SFBP') == 0
    error(['MFict class only works with SFBP (so far)']);
end

global MFictTolerance;
MFictTolerance = .001;

player.team = teamNum;

player.paramSet = paramSet;
player.gamma = get(paramSet, 'Gamma');

player.game = game;
player.numActions = get(game, 'NumActions');
player.stateDim = get(game, 'GameStateDim');
player.sLen = length(player.stateDim);
[player.Counts, player.initPolicy] = ...
                            initTables(game, teamNum, 'StateSingleAction');
%initial counts are set to 1
%player.Counts = player.Counts .* 0;
player.numStates = prod(player.stateDim);

% types: standard, conditional, allPlayer
if nargin < 4
    player.type = 'standard';
else
    player.type = type;
end
if nargin < 5
    player.desiredStates = [1];
else
    player.desiredStates = desiredStates;
end

player.numUpdates = 0;

player = class(player, 'MFict');
