%----------------------------------------------------------------------
% function [game, gameOver, addRewards] = checkStatus(game)
%
%-----------------------------------------------------------------------
function [game, gameOver, addRewards] = checkStatus(game)

global InternalDebug;
% %gameOver = 1 -> repeated games
% %gameOver = 0 -> infinite game
gameOver = 0;
% number who entered the bar
numInBar = sum(game.inBar);

%debug
if InternalDebug == 1
    if game.numInBar > game.capacity
        status = [status, 'CROWDED bar.'];
    else
        status = [status, 'UNCROWDED bar.'];
    end
end

%calculate rewards for player depending on 
%crowdedness
if numInBar > game.capacity
    addRewards = game.inBar .* game.crowdedReward;
else
    addRewards = game.inBar .* game.unCrowdedReward;
end
if game.fee > 0
    addRewards = addRewards - game.fee;
    homeReward = (numInBar * game.fee) / (game.capacity - numInBar);
    addRewards(find(game.inBar == 0)) = homeReward;
end

if game.infinite == 0
    gameOver = 1;
    game.gamesPlayed = game.gamesPlayed + 1;
    game.avgReward = (game.avgReward * (game.gamesPlayed - 1) ...
                      + sum(addRewards)) / game.gamesPlayed;
end


game.lastNumInBar = numInBar;
game.inBar = zeros(1,game.popSize);
game.reset = 0;
