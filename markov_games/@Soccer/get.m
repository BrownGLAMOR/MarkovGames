%-----------------------------------------------------------------------
% Funciton: get(memberName)
%
% Description: returns the value for the member information
%
%-----------------------------------------------------------------------
function value = get(game, memberName)

switch memberName
    case 'Size'
        value = [game.width game.length];
    case 'NumActions'
        value = length(game.actions);
    case 'NumPlayers'
        value = length(game.position);
    case 'State'
        value = {game.position{1}(1), game.position{1}(2), ...
                 game.position{2}(1), game.position{2}(2), game.hasBall};
    case 'GameStateDim'
        value = [game.width game.length game.width game.length 2];
    case 'OnePlayerIndex'
        value = [1 2 5];
    case 'OnePlayerStateDim'
        value = [game.width game.length 2];
    case 'Score'
        value = game.score;
    case 'GamesPlayed'
        value = game.gamesPlayed;
    case 'QuitNow'
        if game.reset == 2
            value = 1;
        else
            value = 0;
        end
    case 'ValidPositions'
        value = game.ballValidPositions;
    case 'InitPositions'
        value = game.initPosition;
    case 'GoalPenalty'
        value = game.goalPenalty;
    case 'StatusString'
        if game.hasBall == 1
            stg = sprintf(...
         '  Games(%d): *Player* 1 (%d, %d),  Player  2 (%d, %d): %d to %d', ...
                      game.gamesPlayed,...
                      game.position{1}(1), game.position{1}(2), ...
                      game.position{2}(1), game.position{2}(2), ...
                      game.score(1), game.score(2));
        else
            stg = sprintf(...
        '  Games(%d):  Player  1 (%d, %d), *Player* 2 (%d, %d): %d to %d', ...
                      game.gamesPlayed, ...
                      game.position{1}(1), game.position{1}(2), ...
                      game.position{2}(1), game.position{2}(2), ...
                      game.score(1), game.score(2));
        end
        value = stg;
    otherwise
        error([memberName,' Is not a valid member name']);
end
