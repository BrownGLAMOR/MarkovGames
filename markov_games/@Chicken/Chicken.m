%-----------------------------------------------------------------------
% Class:  Chicken (Constructor)
%       The game of repeated chicken 
%
%-----------------------------------------------------------------------
function game = Chicken(gameType)

% game.reward{playerNum}
game.rewardVal{1} = [6, 2; 7, 0];
game.rewardVal{2} = [6, 7; 2, 0];

game.gameType = gameType;
switch gameType
case 'repeated'
case 'single'
otherwise
    error(['Unknown gameType: ', gameType]);
end
disp(['Chicken gameType: ', gameType]);

game.numStates = 1;
game.numActions = 2;

game.curState = 1;
game.prevState = 1;
game.actions = zeros(1,2);

game.gamesPlayed = 0;
game.reset = 0;
game.avgReward = 0;

game = class(game, 'Chicken');
