%-----------------------------------------------------------------------
% Class:  Exist (Constructor)
%       'Existence' game
%       test for existence of consistent solutions
%
%-----------------------------------------------------------------------
function game = Exist(gameType)

game.gameType = gameType;
switch gameType

% game.reward{playerNum, stateNum}
case 'original'
    game.rewardVal{1,1} = [0, 0; 0, 0];
    game.rewardVal{1,2} = [1, 0; 1, 0];
    game.rewardVal{2,1} = [1, 1; 0, 0];
    game.rewardVal{2,2} = [0, 0; 0, 0];
case 'uniqueEQ'
    game.rewardVal{1,1} = [.25, .25; 0, 0];
    game.rewardVal{1,2} = [0, 1; 0, 1];
    game.rewardVal{2,1} = [1, 1; 0, 0];
    game.rewardVal{2,2} = [.25, 0; .25, 0];
otherwise
    error(['Unknown gameType: ', gameType]);
end
disp(['Exist gameType: ', gameType]);

game.numStates = 2;
game.numActions = 2;

game.curState = 1;
game.prevState = 1;
game.actions = zeros(1,2);

game.gamesPlayed = 0;
game.reset = 0;
game.avgReward = 0;

game = class(game, 'Exist');
