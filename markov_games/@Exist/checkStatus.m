%----------------------------------------------------------------------
% function [game, gameOver, addRewards] = checkStatus(game)
%
%-----------------------------------------------------------------------
function [game, gameOver, addRewards] = checkStatus(game)

global InternalDebug;
% %gameOver = 1 -> repeated games
% %gameOver = 0 -> infinite game
gameOver = 0;

addRewards = zeros(1,2);
for i = 1:2
    addRewards(i) = ...
             game.rewardVal{i, game.curState}(game.actions(1), game.actions(2));
end
if InternalDebug == 1
    disp(['Rewards = ', num2str(addRewards)]);
end
game.prevState = game.curState;
if game.curState == 1
    if game.actions(1) == 2
        game.curState = 2;
    end
else
    if game.actions(2) == 2
        game.curState = 1;
    end
end

game.gamesPlayed = game.gamesPlayed + 1;
game.avgReward = (game.avgReward * (game.gamesPlayed - 1) ...
                 + sum(addRewards)) / game.gamesPlayed;
