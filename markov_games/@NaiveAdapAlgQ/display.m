%-----------------------------------------------------------------------
% File:
%
% Description:
%
%-----------------------------------------------------------------------
function display(player)

string = sprintf('Player %d: gamma = %d', player.team, player.gamma);
disp(string)

disp('Qvalue:')
disp(player.Qvalues)
disp('Policy:')
disp(player.Policy)
