%-----------------------------------------------------------------------
% Funciton: update
%
% Description:  Update the Q-value table for this player
%               Q(gamestate, team_action)
%
%-----------------------------------------------------------------------
function [player, newQ] = update(player, reward, curState, newState, ...
                                actions, isGameOver)

player.numUpdates = player.numUpdates + 1;
%[player.paramSet, alpha] = newAlpha(player.paramSet);

qStateRef = newState;
qStateRef{player.sLen + 1} = actions(player.team);
player.Counts(qStateRef{:}) = player.Counts(qStateRef{:}) + 1;
newQ = player.Counts(qStateRef{:});
