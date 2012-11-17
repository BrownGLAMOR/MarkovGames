%-----------------------------------------------------------------------
% Class:  Grid (Constructor)
%         A grid game 
%         Location Row = width of field
%         Location Column = length of field
%
%   example 3x3 game (initial positions noted)
%   
%       *-(width, 1)*-(width, length)
%       *           *
%       *    UUU    *
%       -------------
%       | 1 |   | G2|    
%   L   -------------   R
%   L   |   |   |   |   R
%   L   -------------   R
%       | 2 |   | G1|
%       -------------
%       *    DDD    *
%       *           *
%       *-(1, 1)    *-(1, length)
%
% barriers = [rBarriersProb udBarriersProb]
% a barrier restrains the player from moving from it's initial position
% with some probability.
%
% function game = Grid(width, length)
%-----------------------------------------------------------------------
function game = Grid(width, length, barriers, start1, start2, end1, end2, ...
                     collisionPenalty, barrierReward, goalPenalty, ...
                     bTieReward, playerMode, randomStart)

global gridReward;
gridReward = 1;

game.actions = 'UDRL';
numActions = 4;
game.width = width;
game.length = length;
game.oppVec = [2 1];

if nargin < 6
    end1 = [1, length];
    end2 = [width, length];
end

if nargin < 13
    game.randomStart = 1;
else
    game.randomStart = randomStart;
end
game.goal{1} = end1;
game.goal{2} = end2;

if nargin < 4
    start1 = [width, 1];
    start2 = [1, 1];
end
game.initPosition{1} = start1;
game.initPosition{2} = start2;

if game.randomStart == 1
    game.position{1} = ceil(rand(1,2) .* [width length]);
    while all(game.position{1} == game.goal{1}) 
        game.position{1} = ceil(rand(1,2) .* [width length]);
    end
    game.position{2} = ceil(rand(1,2) .* [width length]);
    while all(game.position{2} == game.position{1}) | ...
          all(game.position{2} == game.goal{2}) 
        game.position{2} = ceil(rand(1,2) .* [width length]);
    end
else
    game.position = game.initPosition;
end
game.nextPosition = game.position;


game.score = [0 0];
game.gamesPlayed = 0;

game.barriers = barriers;

game.reset = 0;
game.collisionPenalty = collisionPenalty;
game.barrierReward = barrierReward;
game.bTieReward = bTieReward;
game.goalCost = goalPenalty;
game.hitLRBarrier = [0 0];

switch playerMode
    case 'oneWinner'
        % 2 will force an early quit
        game.playerMode = 2;
    case 'twoWinner'
        game.playerMode = 1;
    otherwise
        error(['Invalid playerMode: ', playerMode]);
end

game.validPositions = ones([game.width, game.length, numActions]);
game.validPositions(game.width, :, 1) = 0; % can't move north
game.validPositions(1, :, 2) = 0;  % can't move south
game.validPositions(:, game.length, 3) = 0; % can't move east
game.validPositions(:, 1, 4) = 0; % can't move west

game = class(game, 'Grid');
