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
        value = length(game.actions);
    case 'NumPlayers'
        value = game.popSize;
    case 'State'
        switch game.gameType 
        case 'waiting'
            if nargin > 2
                % state == 2; if waiting
                % state == 1; if not waiting
                value = game.waiting(player) + 1;
            else 
                value = 1;
            end
        case 'crowdMarkov'
            if game.lastNumInBar > game.capacity
                value = 2;
            else
                value = 1;
            end
        otherwise
            value = 1;
        end
    case 'Type'
        value = game.gameType;
    case 'Payoffs'
        value = game.payoffs;
    case 'GameStateDim'
        value = [game.numStates];
    %case 'OnePlayerStateDim'
    %    value = [game.width game.length 2];
    case 'Score'
        value = 0;
    case 'GamesPlayed'
        value = game.gamesPlayed;
    case 'QuitNow'
        value = 0;
    case 'StatusString'
        if strcmp(game.gameType, 'waiting') == 1
            value = sprintf(...
              '  Games(%d): numInBar %d; agvReward: %d; numWaiting %d', ...
              game.gamesPlayed, game.lastNumInBar, game.avgReward, ...
              sum(game.waiting)); 
        else
            value = sprintf('  Games(%d): numInBar %d; avgReward %d', ...
                            game.gamesPlayed, game.lastNumInBar, ...
                            game.avgReward);
        end
    case 'AvgReward'
        value = game.avgReward;
    otherwise
        error([memberName,' Is not a valid member name']);
end
