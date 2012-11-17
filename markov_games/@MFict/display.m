%-----------------------------------------------------------------------
% File:
%
% Description:
%
%-----------------------------------------------------------------------
function display(player)

disp(['Player ', num2str(player.team), ':']);
disp('Counts: ');
disp(player.Counts)

if (player.Counts > 0)
    dists = player.Counts ./ repmat(sum(player.Counts), player.numStates, 1);
else
    dists = zeros(player.numStates, player.numActions);
end
disp('Dists: ');
disp(dists);
