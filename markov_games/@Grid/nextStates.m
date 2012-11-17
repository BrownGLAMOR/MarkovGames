%-----------------------------------------------------------------------
% Funciton: nextStates
%
%   Determines the "next" states for the given move
%   Returns the state index, the reward for moving to that state
%   and the probability of transitioning to the state given the 
%   action.
%
%   Returns next state records, each record contains:
%
%   List of lists (first 3 required, 4th + is optional)
%   (1) - next position (vector)
%   (2) - probability of next state
%   (3) - reward for next state
%   (4) - did it hit the L/R barrier?
%   (5) - did we score a goal?
%
%-----------------------------------------------------------------------
function [playerInfo] = nextStates(game, team, action)

global InternalDebug;
global gridReward;

% actions 1=U, 2=D, 3=R, 4=L
if game.validPositions(game.position{team}(1), ...
            game.position{team}(2), action) == 0
  error(['Attempting to make an invalid move']);
end

%%% U/D barriers are not the same as L/R barriers
%%% no penalty for jointly passing through the U/D barriers
playerInfo = {};
numNext = 1;
switch action
  case 1
    % Player got past the barrier
    playerInfo{numNext}{1} = game.position{team} + [1 0];
    if game.position{team} == game.initPosition{team} 
      playerInfo{numNext}{2} = 1.0 - game.barriers(2);
      playerInfo{numNext}{3} = game.barrierReward(2);
    else
      playerInfo{numNext}{2} = 1.0;
      playerInfo{numNext}{3} = 0;
    end
    playerInfo{numNext}{4} = 0;
    playerInfo{numNext}{5} = 0;
    if playerInfo{numNext}{1} == game.goal{team}
      playerInfo{numNext}{3} = playerInfo{numNext}{3} + 1;
      playerInfo{numNext}{5} = game.playerMode;
    end
    if game.position{team} == game.initPosition{team} & game.barriers(2) > 0
      % Player hit the wall
      numNext = numNext + 1;
      playerInfo{numNext}{1} = game.position{team};
      playerInfo{numNext}{2} = game.barriers(2);
      playerInfo{numNext}{3} = 0;
      playerInfo{numNext}{4} = 0;
      playerInfo{numNext}{5} = 0;
    end
  case 2
    % Player got past the barrier
    playerInfo{numNext}{1} = game.position{team} - [1 0];
    if game.position{team} == game.initPosition{team} 
      playerInfo{numNext}{2} = 1.0 - game.barriers(2);
      playerInfo{numNext}{3} = game.barrierReward(2);
    else
      playerInfo{numNext}{2} = 1.0;
      playerInfo{numNext}{3} = 0;
    end
    playerInfo{numNext}{4} = 0;
    playerInfo{numNext}{5} = 0;
    if playerInfo{numNext}{1} == game.goal{team}
      playerInfo{numNext}{3} = playerInfo{numNext}{3} + 1;
      playerInfo{numNext}{5} = game.playerMode;
    end
    if game.position{team} == game.initPosition{team} & game.barriers(2) > 0
      % Player hit the wall
      numNext = numNext + 1;
      playerInfo{numNext}{1} = game.position{team};
      playerInfo{numNext}{2} = game.barriers(2);
      playerInfo{numNext}{3} = 0;
      playerInfo{numNext}{4} = 0;
      playerInfo{numNext}{5} = 0;
    end
  case 3
    % Player got past the barrier
    playerInfo{numNext}{1} = game.position{team} + [0 1];
    if game.position{team} == game.initPosition{team} 
      playerInfo{numNext}{2} = 1.0 - game.barriers(1);
      playerInfo{numNext}{3} = game.barrierReward(1);
    else
      playerInfo{numNext}{2} = 1.0;
      playerInfo{numNext}{3} = 0;
    end
    playerInfo{numNext}{4} = 1;
    playerInfo{numNext}{5} = 0;
    if playerInfo{numNext}{1} == game.goal{team}
      playerInfo{numNext}{3} = playerInfo{numNext}{3} + 1;
      playerInfo{numNext}{5} = game.playerMode;
    end
    if game.position{team} == game.initPosition{team} & game.barriers(1) > 0 
      % Player hit the wall
      numNext = numNext + 1;
      playerInfo{numNext}{1} = game.position{team};
      playerInfo{numNext}{2} = game.barriers(1);
      playerInfo{numNext}{3} = 0;
      playerInfo{numNext}{4} = 0;
      playerInfo{numNext}{5} = 0;
    end
  case 4
    playerInfo{numNext}{1} = game.position{team} - [0 1];
    playerInfo{numNext}{2} = 1.0;
    playerInfo{numNext}{3} = 0;
    playerInfo{numNext}{4} = 0;
    playerInfo{numNext}{5} = 0;
  otherwise
    error([action,' Is not a valid Game action']);
end
