%-----------------------------------------------------------------------
% Funciton: Player.move
%
% Performs the action 
%
%-----------------------------------------------------------------------
function [game, reward] = move(game, player, action)

global InternalDebug;
reward = 0;

% actions 1 = enter bar, 2 = stay home
if game.waiting(player) == 1 
    if action ~= 1
        error(['Action (', num2str(action), ') while waiting in line.']);
    end
    game.waiting(player) = 0;
end

switch action
    case 1
        if InternalDebug == 1
            status = ['Player: ', num2str(player), 'entered the '];
        end
        game.inBar(player) = 1;
    case 2
    case 3
        if InternalDebug == 1
            disp(['Player: ', num2str(player), 'WAITING to enter bar']);
        end
        game.waiting(player) = 1;
    otherwise
        error([action,' Is not a valid Game action']);
end
