%-----------------------------------------------------------------------
% Funciton: checkAction
%
% Performs the action 
%
%-----------------------------------------------------------------------
function goodAction = checkAction(game, state, team, action)

% actions 1=N, 2=S, 3=E, 4=W, 5=stay
position{1} = [state{1} state{2}];
position{2} = [state{3} state{4}];
goodAction = game.ballValidPositions(position{team}(1), ...
                                     position{team}(2), team, action);
% don't check if we have the ball any more, all players can move
% into the goal
%if goodAction == 2 & team == state{5}
if goodAction > 0
    goodAction = 1;
end
