%-----------------------------------------------------------------------
% Funciton: Player.move
%
% Performs the action 
%
%-----------------------------------------------------------------------
function [game, reward] = move(game, team, action)

global InternalDebug;
global gridReward;

reward = 0;
% actions 1=U, 2=D, 3=R, 4=L
if game.validPositions(game.position{team}(1), ...
                      game.position{team}(2), action) == 0
    error(['Attempting to make an invalid move']);
end

%%% U/D barriers are not the same as L/R barriers
%%% no penalty for jointly passing through the U/D barriers
switch action
    case 1
        if game.position{team} == game.initPosition{team}
            if game.barriers(2) == 0 | rand > game.barriers(2) 
                game.nextPosition{team} = game.position{team} + [1 0];
                reward = game.barrierReward(2);
            else
                if InternalDebug == 1
                    disp(['  *** ', num2str(team), ' hit UD-wall at ', ...
                        get(game, 'StatusString')]);
                end
            end
        else
            game.nextPosition{team} = game.position{team} + [1 0];
        end
    case 2
        if game.position{team} == game.initPosition{team}
            if game.barriers(2) == 0 | rand > game.barriers(2) 
                game.nextPosition{team} = game.position{team} - [1 0];
                reward = game.barrierReward(2);
            else
                if InternalDebug == 1
                    disp(['  *** ', num2str(team), ' hit UD-wall at ', ...
                        get(game, 'StatusString')]);
                end
            end
        else
            game.nextPosition{team} = game.position{team} - [1 0];
        end
    case 3
        if game.position{team} == game.initPosition{team}
            if game.barriers(1) == 0 | rand > game.barriers(1) 
                game.nextPosition{team} = game.position{team} + [0 1];
                reward = game.barrierReward(1);
                game.hitLRBarrier(team) = 1;
            else
                if InternalDebug == 1
                    disp(['  *** ', num2str(team), ' hit RL-wall at ', ...
                         get(game, 'StatusString')]);
                end    
            end
        else
            game.nextPosition{team} = game.position{team} + [0 1];
        end
    case 4
        game.nextPosition{team} = game.position{team} - [0 1];
    otherwise
        error([action,' Is not a valid Game action']);
end

if game.nextPosition{team} == game.goal{team}
    game.score(team) = game.score(team) + 1;
    reward = 1;
    game.reset = game.playerMode;
    if InternalDebug == 1
        disp(['  !!! player ', num2str(team), ' scored']);
    end
end
