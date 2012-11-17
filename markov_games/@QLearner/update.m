%-----------------------------------------------------------------------
% Funciton: update
%
% Description:  Update the Q-value table for this player
%               Q(gamestate, team_action)
%
%-----------------------------------------------------------------------
function [player, newQ] = update(player, reward, curState, newState, ...
                                actions, isGameOver)

global QLearnerTolerance;
% decay learning rate
player.numUpdates = player.numUpdates + 1;

if isGameOver == 1
    V = 0;
else
    % index of q-values for all action-pairs from this state
    [player, V] = calcV(player, newState);
end

if strcmp(player.normGamma, 'GammaNorm')
    newQ = ((1 - player.gamma) * reward) + (player.gamma * V);
else
    newQ = reward + player.gamma * V;
end

player = setQ(player, curState, actions, newQ);
