%-----------------------------------------------------------------------
% Funciton: 
%
% Description:
%
% Returns:
%
%-----------------------------------------------------------------------
function values = mmEQ(policy, qtable)

values = - (qtable * policy');
