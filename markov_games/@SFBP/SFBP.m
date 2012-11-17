%-----------------------------------------------------------------------
% Class:  SFBP (Constructor)
%       Sante Fe Bar Problem game
%
%-----------------------------------------------------------------------
function game = SFBP(popSize, capacity, infinite, gameType, fee)

game.unCrowdedReward = 1;
game.crowdedReward = -1;
if nargin < 1
    game.popSize = 100;
else
    game.popSize = popSize;
end
if nargin < 2
    game.capacity = 60;
else
    game.capacity = capacity;
end
if nargin < 5
    game.fee = 0;
else
    game.fee = .4;
end

game.infinite = 0;
if nargin > 2 & infinite > 0
    disp(['SFBP: infinite game']);
    game.infinite = 1;
end

game.numStates = 1;
game.actions = 'BH';        % bar or home
game.numActions = 2;
game.payoffs{1} = [1 0];
game.payoffs{2} = [-1 0];
game.payoffs{3} = [0 0];
if nargin > 3 
    game.gameType = gameType;
    switch gameType
    case 'standard'
    case 'waiting'
        % boolean for now...
        game.numStates = 2;
        game.actions = 'BHW';
        game.numActions = 3;
        game.infinite = 1;
    case 'crowdMarkov'
        game.numStates = 2;
    otherwise
    end
else
    game.gameType = 'standard';
end

game.gamesPlayed = 0;
game.reset = 0;
game.lastNumInBar = 0;
game.waiting = zeros(1,popSize);
game.inBar = zeros(1,popSize);
game.state = 1;
game.avgReward = 0;


game = class(game, 'SFBP');
