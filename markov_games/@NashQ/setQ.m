%-----------------------------------------------------------------------
% File: setQ
%
% Description:
%       set a q-values manually (using alpha, etc).
%
%-----------------------------------------------------------------------
function [player] = setQ(player, state, actions, newQ)

qStateRef = state;
qStateRef{player.sLen + 1} = actions(player.opponent);
qStateRef{player.sLen + 2} = actions(player.team);
curQ = player.Qvalues(qStateRef{:});

[player.paramSet, alpha] = newAlpha(player.paramSet, qStateRef);
player.Qvalues(qStateRef{:}) = (1 - alpha) * curQ + (alpha * newQ);
