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
    case 'NumStates'
        value = (game.width * game.length)^2;
        value = value - (game.width * game.length);    % players cannot occupy the same position (and ignore shared goals)
        value = value - ((game.width * game.length) - 1) * 2;  % ignore situation where one player is in the goal
        if all(game.goal{1} == game.goal{2}) ~= 1
            value = value + 1;                         % if players have different goals, then we overcounted by one 
        end
    case 'State'
        value = {game.position{1}(1), game.position{1}(2), ...
                 game.position{2}(1), game.position{2}(2)};
    case 'StartState'
        value = {game.initPosition{1}(1), game.initPosition{1}(2), ...
                 game.initPosition{2}(1), game.initPosition{2}(2)};
    case 'GoalState'
        value = game.goal;
    case 'GameStateDim'
        value = [game.width game.length game.width game.length];
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
    case 'StatusString'
        value = sprintf(...
            '  Games(%d): Player 1 (%d, %d),  Player  2 (%d, %d): %d to %d', ...
                  game.gamesPlayed,...
                  game.position{1}(1), game.position{1}(2), ...
                  game.position{2}(1), game.position{2}(2), ...
                  game.score(1), game.score(2));
    case 'NextState'
        value = sprintf('  Player 1 (%d, %d),  Player  2 (%d, %d)', ...
                  game.nextPosition{1}(1), game.nextPosition{1}(2), ...
                  game.nextPosition{2}(1), game.nextPosition{2}(2));
    otherwise
        error([memberName,' Is not a valid member name']);
end
