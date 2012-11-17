%-----------------------------------------------------------------------
% Funciton: checkState
%
% Performs the action 
%
%-----------------------------------------------------------------------
function goodState = checkState(game, state)

% actions 1=U, 2=D, 3=R, 4=L
goodState = (state{1} <= game.width & state{2} <= game.length & ...
             state{3} <= game.width & state{4} <= game.length & ...
             (state{1} ~= game.goal{1}(1) | state{2} ~= game.goal{1}(2)) &  ...
             (state{3} ~= game.goal{2}(1) | state{4} ~= game.goal{2}(2)) & ...
             (state{1} ~= state{3} | state{2} ~= state{4}));
