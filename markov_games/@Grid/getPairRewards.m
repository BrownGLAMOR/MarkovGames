%-----------------------------------------------------------------------
% File:
%
% Description:
%
%-----------------------------------------------------------------------
function [newState, isGameOver, playerInfo] = getPairRewards(game, curState, playerInfo)

global InternalDebug;
addRewards = [0 0];
curPosition{1}(1) = curState{1};
curPosition{1}(2) = curState{2};
curPosition{2}(1) = curState{3};
curPosition{2}(2) = curState{4};
isGameOver = 0;
if playerInfo{1}{5} == 1 | playerInfo{2}{5} == 1
  isGameOver = 1;
  if game.goalCost(1) > 0
    for teamNum = 1:2
      if playerInfo{teamNum}{1} == game.goal{teamNum} & ...
         curPosition{teamNum} ~= (game.goal{teamNum} - [0 1])
        if curPosition{game.oppVec(teamNum)} ~= (game.goal{teamNum} - [0 1])
          playerInfo{teamNum}{3} = playerInfo{teamNum}{3} - (game.goalCost(1)/2);
        else
          playerInfo{teamNum}{3} = playerInfo{teamNum}{3} - (game.goalCost(1));
        end
      end
    end
  end
  if game.goalCost(2) > 0
    for teamNum = 1:2
      if playerInfo{teamNum}{1} == game.goal{teamNum} & ...
         curPosition{teamNum} == (game.goal{teamNum} - [0 1])
        playerInfo{teamNum}{3} = playerInfo{teamNum}{3} - game.goalCost(2);
      end
    end
  end
else
  if playerInfo{1}{1} == playerInfo{2}{1}
    if InternalDebug == 1
      disp(['  *** collision at ', get(game, 'NextState')]);
    end
    playerInfo{1}{1} = curPosition{1};
    playerInfo{2}{1} = curPosition{2};
    playerInfo{1}{3} = playerInfo{1}{3} + game.collisionPenalty;
    playerInfo{2}{3} = playerInfo{2}{3} + game.collisionPenalty;
  else
    if playerInfo{1}{4} == 1 && playerInfo{2}{4} == 1
      playerInfo{1}{3} = playerInfo{1}{3} + game.bTieReward;
      playerInfo{2}{3} = playerInfo{2}{3} + game.bTieReward;
    end
  end
end
% set the new state
newState ={playerInfo{1}{1}(1), playerInfo{1}{1}(2), ...
           playerInfo{2}{1}(1), playerInfo{2}{1}(2)};
