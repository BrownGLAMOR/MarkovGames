%-----------------------------------------------------------------------
% Funciton: checkAction
%
% Performs the action 
%
%-----------------------------------------------------------------------
function goodAction = checkAction(game, state, team, action)

goodAction = 1;
if strcmp(game.gameType, 'waiting') == 1 & game.waiting(team) == 1 & action ~= 1
    goodAction = 0;
end
    
%if state == 2 
%    if action == 2
%        goodAction == 0;
%    end
%end
