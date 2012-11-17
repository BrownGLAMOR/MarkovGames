%-----------------------------------------------------------------------
% Funciton: update
%
% Description:  Update the Q-value table for this player
%               Q(gamestate, opponent_action, team_action)
%
%-----------------------------------------------------------------------
function [player, newQ, V] = update(player, reward, curState, newState, ...
                                actions, isGameOver)

% decay learning rate
player.numUpdates = player.numUpdates + 1;

if isGameOver == 1
    V = 0;
else
    [player, V] = calcV(player, newState);
end

% update Values
if strcmp(player.normGamma, 'GammaNorm')
    newQ = ((1 - player.gamma) * reward) + (player.gamma * V);
else
    newQ = reward + player.gamma * V;
end

player = setQ(player, curState, actions, newQ);
