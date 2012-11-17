%-----------------------------------------------------------------------
% Funciton: 
%
% Description:
%
% Returns:
%
%-----------------------------------------------------------------------
function reg_mat_all_actions = getRegret(player, state)

reg_mat_all_actions = zeros(player.numActions);  

strat = player.StratTable(state{:});

reg_mat_legal_only = get(strat{1}, 'regret');


moves = get(strat{1}, 'moves');
moves = cat(1,moves{:});

reg_mat_all_actions(moves,moves) = reg_mat_legal_only;


