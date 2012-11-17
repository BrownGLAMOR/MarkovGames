%-----------------------------------------------------------------------
% File:
%
% Description:
%
%-----------------------------------------------------------------------
function display(player)

string = sprintf('Player %d: alpha = %d, gamma = %d', ...
                 player.team, player.alpha, player.gamma);
disp(string)

disp('Qvalue:')
disp(player.Qvalues)
