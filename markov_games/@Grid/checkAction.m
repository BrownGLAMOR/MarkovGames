%-----------------------------------------------------------------------
% Funciton: checkAction
%
% Performs the action 
%
%-----------------------------------------------------------------------
function goodAction = checkAction(game, state, team, action)

% actions 1=U, 2=D, 3=R, 4=L
if team == 1
    goodAction = game.validPositions(state{1}, state{2}, action);
else
    goodAction = game.validPositions(state{3}, state{4}, action);
end
