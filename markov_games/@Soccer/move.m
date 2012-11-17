%-----------------------------------------------------------------------
% Funciton: Player.move
%
% Performs the action 
%
%-----------------------------------------------------------------------
function [game, reward] = move(game, team, action)

global InternalDebug;
opponent = game.oppVec(team);
reward = 0;
switchBall = 0;

% actions 1=N, 2=S, 3=E, 4=W, 5=stay

goodAction = game.ballValidPositions(game.position{team}(1), ...
                                     game.position{team}(2), team, action);
%if goodAction > 1 & team == game.hasBall
%    % goal
%    game.reset = 2;
%    teamScored = goodAction - 1;  
%    game.hasScored = teamScored;
%    % (NOW in checkStatus.m) reward = game.goalValue;
%    game.score(teamScored) = game.score(teamScored) + 1;
%    if InternalDebug == 1
%        sstring = get(game, 'StatusString');
%        disp(['  *** Player ', int2str(teamScored), ' scored --', sstring]);
%    end
%else
switch action
    case 1
        if game.position{team} + [1 0] == game.position{opponent}
            switchBall = 1;
        else
            game.position{team}(1) = game.position{team}(1) + 1;
        end
    case 2
        if game.position{team} - [1 0] == game.position{opponent}
            switchBall = 1;
        else
            game.position{team}(1) = game.position{team}(1) - 1;
        end
    case 3
        if game.position{team} + [0 1] == game.position{opponent}
            switchBall = 1;
        else
            game.position{team}(2) = game.position{team}(2) + 1;
        end
    case 4
        if game.position{team} - [0 1] == game.position{opponent}
            switchBall = 1;
        else
            game.position{team}(2) = game.position{team}(2) - 1;
        end
    case 5
    otherwise
        error([action,' Is not a valid Game action']);
end

% if we don't allow stealing, we can only switch the ball if 
% we have it (loosing the ball)
if (game.allowStealing == 1 | game.hasBall == team) & switchBall == 1
    % switch ball to other player
    game.hasBall = game.oppVec(game.hasBall);

    if InternalDebug == 1
        sstring = get(game, 'StatusString');
        if game.hasBall == team
           disp(['  --- Player ', int2str(team), ...
                 ' stole ball --', sstring])
        else
           disp(['  --- Player ', int2str(team), ...
                 ' lost ball --', sstring])
        end
    end

end
% if player with ball is in a goal, point 
% scored depending on goal
teamScored = 0;
if game.position{game.hasBall}(2) == 1
    teamScored = 1;
end
if game.position{game.hasBall}(2) == game.length
    teamScored = 2;
end
if teamScored > 0
    game.reset = 2;
    game.hasScored = teamScored;
    game.score(teamScored) = game.score(teamScored) + 1;
    % (NOW in checkStatus.m) reward = game.goalValue;
    if InternalDebug == 1
        sstring = get(game, 'StatusString');
        disp(['  *** Player ', int2str(teamScored), ...
              ' scored --', sstring]);
    end
end
%    end
