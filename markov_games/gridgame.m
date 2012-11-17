%-----------------------------------------------------------------------
% Function: gridgame
%
% Description:
%       Trains grid for trainIter number of iterations.
%       Returns the team objects (with optimal policies and Q-values).
%
%-----------------------------------------------------------------------
function game = gridgame(gridGame, randomStart)

playerMode = 'twoWinner';
%playerMode = 'oneWinner';
gameWidth = 3;
gameLength = 3;
if nargin < 2
    randomStart = 1;
end
switch gridGame
    case 1
        barrierProb = [0, 0];
        p1Init = [3,1];
        p2Init = [1,1];
        p1Goal = [1,3];
        p2Goal = [3,3];
        collisionPenalty = -.01;
        barrierReward = [0 0];
        doubleBarrierReward = 0;
        goalPenalty = [0 0];
    case 2
        barrierProb = [.5, 0];
        p1Init = [3,1];
        p2Init = [1,1];
        p1Goal = [2,3];
        p2Goal = [2,3];
        collisionPenalty = -.01;
        barrierReward = [0 0];
        doubleBarrierReward = 0;
        goalPenalty = [0 0];
    case 3
        barrierProb = [0, 0];
        p1Init = [3,1];
        p2Init = [1,1];
        p1Goal = [2,3];
        p2Goal = [2,3];
        collisionPenalty = -.5;
        barrierReward = [0 .25];
        doubleBarrierReward = .2;
        goalPenalty = [0 0];
    case 4
        barrierProb = [0, 0];
        p1Init = [3,1];
        p2Init = [1,1];
        p1Goal = [2,2];
        p2Goal = [2,2];
        collisionPenalty = -1;
        barrierReward = [0 0];
        doubleBarrierReward = 0;
        goalPenalty = [50 10];
        gameLength = 2;
    case 5
        barrierProb = [0, 0];
        p1Init = [3,1];
        p2Init = [1,1];
        p1Goal = [2,2];
        p2Goal = [2,2];
        collisionPenalty = -50;
        barrierReward = [0 25];
        doubleBarrierReward = 20;
        goalPenalty = [0 0];
        gameLength = 2;
end
disp(['Grid game ', int2str(gridGame), ...
      ' Rewards: collision (', num2str(collisionPenalty), ...
      '), barrier (', num2str(barrierReward), ...
      '), barrier tie (', num2str(doubleBarrierReward), ')']);
if randomStart == 1
    disp(['--- Random position at restart']);
else
    disp(['--- Fixed start position at restart']);
end
game = Grid(gameWidth, gameLength, barrierProb, p1Init, p2Init, ...
            p1Goal, p2Goal, collisionPenalty, barrierReward, goalPenalty, ...
            doubleBarrierReward, playerMode, randomStart);
