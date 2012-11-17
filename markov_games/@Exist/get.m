%-----------------------------------------------------------------------
% Funciton: get(memberName)
%
% Description: returns the value for the member information
%
%-----------------------------------------------------------------------
function value = get(game, memberName, player)

switch memberName
    case 'Size'
        value = [];
    case 'NumActions'
        value = game.numActions;
    case 'NumPlayers'
        value = 2;
    case 'State'
        value = {game.curState};
    case 'Payoffs'
        value = game.rewardVal;
    case 'GameStateDim'
        value = [game.numStates];
    case 'Score'
        value = zeros(1,2);
    case 'GamesPlayed'
        value = game.gamesPlayed;
    case 'QuitNow'
        value = 0;
    case 'StatusString'
       value = sprintf(...
               '  Game(%d): state(%d -> %d), actions(%d,%d), agvReward (%s)',...
                       game.gamesPlayed, game.prevState, game.curState, ...
                       game.actions(1), game.actions(2), game.avgReward);
    case 'AvgReward'
        value = game.avgReward;
    otherwise
        error([memberName,' Is not a valid member name']);
end
