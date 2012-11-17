%-----------------------------------------------------------------------
% Funciton: updateQ
%
% Description:  Update the Q-value table for this player
%               Q(gamestate, opponent_action, team_action)
%
%-----------------------------------------------------------------------
function [player, newQ] = update(player, reward, curState, newState, ...
                                 actions, isGameOver, decay)

newQ = 1;
