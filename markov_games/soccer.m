%-----------------------------------------------------------------------
% Function: soccer()
%
% Description:
%       Trains soccer for trainIter number of iterations.
%       Returns the team objects (with optimal policies and Q-values).
%
%-----------------------------------------------------------------------
function game = soccer(width, length, goalPenalty, allowStealing, randStart)

if nargin < 5
    randStart = 1;
end
if nargin < 4
    allowStealing = 1;
end
game = Soccer(width, length, goalPenalty, allowStealing, randStart);
