%----------------------------------------------------------------------
% function [game, gameOver, addRewards] = checkStatus(game)
%
%-----------------------------------------------------------------------
function [game, gameOver, addRewards] = checkStatus(game)

global InternalDebug;
% %gameOver = 1 -> repeated games
% %gameOver = 0 -> infinite game
gameOver = 0;
switch game.gameType
    case 'repeated'
    case 'single'
        gameOver = 1;
end

addRewards = zeros(1,2);
for i = 1:2
    addRewards(i) = game.rewardVal{i}(game.actions(1), game.actions(2));
end
if InternalDebug == 1
    disp(['Rewards = ', num2str(addRewards)]);
end

game.gamesPlayed = game.gamesPlayed + 1;
game.avgReward = (game.avgReward * (game.gamesPlayed - 1) ...
                 + sum(addRewards)) / game.gamesPlayed;
