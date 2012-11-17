%-----------------------------------------------------------------------
% Funciton: Player.move
%
% Performs the action 
%
%-----------------------------------------------------------------------
function [game, reward] = move(game, player, action)

global InternalDebug;
reward = 0;

game.actions(player) = action;
