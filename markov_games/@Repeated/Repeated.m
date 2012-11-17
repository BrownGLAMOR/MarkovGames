%-----------------------------------------------------------------------
% Class:  Repeated (Constructor)
%       The game of repeated chicken 
%
%-----------------------------------------------------------------------
function game = Repeated(gamePlay, gameType)

% game.reward{playerNum}
switch gamePlay
case 'Chicken'
    game.rewardVal{1} = [6, 2; 7, 0];
    game.rewardVal{2} = [6, 7; 2, 0];
case 'Coordination'
    game.rewardVal{1} = [1, 0; 0, 1];
    game.rewardVal{2} = [1, 0; 0, 1];
case 'Sexes'
    game.rewardVal{1} = [2, 0; 0, 1];
    game.rewardVal{2} = [1, 0; 0, 2];
case 'Pennies'
    game.rewardVal{1} = [1, 0; 0, 1];
    game.rewardVal{2} = [0, 1; 1, 0];
otherwise
    error(['Unknown Repeated Game: ', gamePlay]);
end
        

game.gameType = gameType;
switch gameType
case 'repeated'
case 'single'
otherwise
    error(['Unknown gameType: ', gameType]);
end
disp(['Repeated gameType: ', gameType]);

game.numStates = 1;
game.numActions = 2;

game.curState = 1;
game.prevState = 1;
game.actions = zeros(1,2);

game.gamesPlayed = 0;
game.reset = 0;
game.avgReward = 0;

game = class(game, 'Repeated');
