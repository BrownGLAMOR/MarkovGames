%-----------------------------------------------------------------------
% Funciton: checkAction
%
% Performs the action 
%
%-----------------------------------------------------------------------
function goodAction = checkAction(game, state, team, action)

goodAction = 1;

if state{:} == 1
    if team == 2 & action == 2
        goodAction = 0;
    end
else
    if team == 1 & action == 2
        goodAction = 0;
    end
end
