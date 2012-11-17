%----------------------------------------------------------------------
% function [game, gameOver, addRewards] = checkStatus(game)
%
%-----------------------------------------------------------------------
function [game, gameOver, addRewards] = checkStatus(game)

gameOver = 0;
addRewards = [0 0];
if game.reset > 0
    % %gameOver = 1 -> repeated games
    % %gameOver = 0 -> infinite game
    gameOver = 1;
    addRewards(game.hasScored) = game.goalValue;
    % if we are player zero-sum
    if game.goalPenalty == 1 
        addRewards(game.oppVec(game.hasScored)) = - game.goalValue;
    end
    game.hasBall = ceil(rand * 2);
    if game.randomStart == 1
        game.position{1} = ceil(rand(1,2) .* [game.width game.length]);
        while game.hasBall == 1 & ...
             (game.position{1}(2) == 1 | game.position{1}(2) == game.length)
            game.position{1} = ceil(rand(1,2) .* [game.width game.length]);
        end
        game.position{2} = ceil(rand(1,2) .* [game.width game.length]);
        while all(game.position{2} == game.position{1}) | ...
              (game.hasBall == 2 & ...
               (game.position{2}(2) == 1 | game.position{2}(2) == game.length))
            game.position{2} = ceil(rand(1,2) .* [game.width game.length]);
        end
    else
        game.position = game.initPosition;
    end
    game.hasScored = 0;
    game.reset = 0;
    game.gamesPlayed = game.gamesPlayed + 1;
end
