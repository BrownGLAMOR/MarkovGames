%-----------------------------------------------------------------------
% File: setQ
%
% Description:
%       set a q-values manually (using alpha, etc).
%
%-----------------------------------------------------------------------
function [player] = setQ(player, state, actions, newQ)

qStateRef = state;
qStateRef{player.sLen + 1} = actions(player.team);
[player.paramSet, alpha] = newAlpha(player.paramSet, qStateRef);
curQ = player.Qvalues(qStateRef{:});
player.Qvalues(qStateRef{:}) = (1 - alpha) * curQ + alpha * newQ;
