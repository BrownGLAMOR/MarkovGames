%-----------------------------------------------------------------------
% File:
%
% Description:
%
%-----------------------------------------------------------------------
function [game, gameOver, addRewards] = checkStatus(game)

global InternalDebug;
gameOver = 0;
addRewards = [0 0];
if game.reset > 0
    %% gameOver = 1; -> repeated markov games
    %% gameOver = 0; -> inifinite markov game
    %%
    gameOver = 1;
    if game.goalCost(1) > 0
        for teamNum = 1:2
            if game.nextPosition{teamNum} == game.goal{teamNum} & ...
               game.position{teamNum} ~= (game.goal{teamNum} - [0 1])
                if game.position{game.oppVec(teamNum)} ~= (game.goal{teamNum} - [0 1])
                    addRewards(teamNum) = addRewards(teamNum) - (game.goalCost(1)/2);
                else
                   addRewards(teamNum) = addRewards(teamNum) - game.goalCost(1);
                end
            end
        end
    end
    if game.goalCost(2) > 0
        for teamNum = 1:2
            if game.nextPosition{teamNum} == game.goal{teamNum} & ...
               game.position{teamNum} == (game.goal{teamNum} - [0 1])
                addRewards(teamNum) = addRewards(teamNum) - game.goalCost(2);
            end
        end
    end
    if game.randomStart == 1
        game.position{1} = ceil(rand(1,2) .* [game.width game.length]);
        while all(game.position{1} == game.goal{1})
            game.position{1} = ceil(rand(1,2) .* [game.width game.length]);
        end
        game.position{2} = ceil(rand(1,2) .* [game.width game.length]);
        while all(game.position{2} == game.position{1}) | ...
              all(game.position{2} == game.goal{2})
            game.position{2} = ceil(rand(1,2) .* [game.width game.length]);
        end
    else
        game.position = game.initPosition;
    end
    game.nextPosition = game.position;
    game.reset = 0;
    game.gamesPlayed = game.gamesPlayed + 1;
else
    if game.nextPosition{1} == game.nextPosition{2}
        if InternalDebug == 1
            disp(['  *** collision at ', get(game, 'NextState')]);
        end
        game.nextPosition = game.position;
        addRewards = [game.collisionPenalty, game.collisionPenalty];
    else
        if sum(game.hitLRBarrier) == 2
            addRewards = [game.bTieReward, game.bTieReward];
        end
        game.position = game.nextPosition;
    end
end
game.hitLRBarrier = [0 0];
