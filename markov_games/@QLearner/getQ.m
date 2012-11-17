%-----------------------------------------------------------------------
% Funciton: 
%
% Description:
%
% Returns:
%
%-----------------------------------------------------------------------
function value = getQ(player, state, actions)

qStateRef = state;           
qStateRef{player.sLen + 1} = actions(player.team);

value = player.Qvalues(qStateRef{:});
