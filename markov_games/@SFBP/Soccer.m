%-----------------------------------------------------------------------
% Class:  Soccer (Constructor)
%         A soccer game
%         Location Row = width of field
%         Location Column = length of field
%
%   example 4x5 game (initial positions noted)
%   
%       *-(width, 2)
%       *         *-(width, length+1)
%       *   NNN   *
%       -----------
%       | | | | | |
%     ---------------
% W   | | | | |1| | |   E
% W   G1-----------G2   E
% W   | | |2| | | | |   E
%     ---------------
%       | | | | | |
%       -----------
%       *   SSS   *
%       *-(1, 2)  *-(1, length+1)
%
% 
% function game = Soccer(width, length, goalPenalty, allowStealing)
%-----------------------------------------------------------------------
function game = Soccer(width, length, goalPenalty, allowStealing)

game.goalValue = 100;
%game.goalValue = 1;

game.actions = 'NSEW-';
numActions = 5;
game.width = width;
game.length = length + 2;
game.oppVec = [2, 1];

if nargin > 2
    game.goalPenalty = goalPenalty;
else
    game.goalPenalty = 0;
end
if nargin > 3
    game.allowStealing = allowStealing;
else
    game.allowStealing = 0;
end

if width < 3
    initWidth1 = width;
    initWidth2 = 1;
else
    initWidth1 = width - 1;
    initWidth2 = 2;
end
if length < 3
    game.initPosition{1} = [initWidth1, length + 1];
    game.initPosition{2} = [initWidth2, 2];
else
    game.initPosition{1} = [initWidth1, length];
    game.initPosition{2} = [initWidth2, 3];
end
game.position = game.initPosition;
game.hasBall = 2;
game.score = [0 0];
game.gamesPlayed = 0;

game.hasScored = 0;
game.reset = 0;


game.ballValidPositions = ones([game.width, game.length, 2, numActions]);
game.ballValidPositions(game.width, :, :, 1) = 0; % can't move north
game.ballValidPositions(1, :, :, 2) = 0;  % can't move south
game.ballValidPositions(:, game.length, :, 3) = 0; % can't move east
game.ballValidPositions(:, 1, :, 4) = 0; % can't move west
% special goal columns (1 and length)
game.ballValidPositions(:, game.length - 1, :, 3) = 0; % can't move east
game.ballValidPositions(:, 2, :, 4) = 0; % can't move west
if game.width < 3
    game.ballValidPositions(:, 2, :, 4) = 2;
    game.ballValidPositions(:, game.length - 1, :, 3) = 3;
else
    game.ballValidPositions(2:(game.width - 1), 2, :, 4) = 2;
    game.ballValidPositions(2:(game.width - 1), game.length - 1, :, 3) = 3;
    % restricted movement from the goal state
    game.ballValidPositions(game.width - 1, [1, game.length], :, 1) = 0;
    game.ballValidPositions(2, [1, game.length], :, 2) = 0;
    game.ballValidPositions([1, game.width], 2, :, 4) = 0;
    game.ballValidPositions([1, game.width], game.length - 1, :, 3) = 0;
end

game = class(game, 'Soccer');
