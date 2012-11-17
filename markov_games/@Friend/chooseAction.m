%-----------------------------------------------------------------------
% File: chooseAction
%
% Description:
%
%-----------------------------------------------------------------------
function chosenAction = chooseAction(player, curState, mode)

global PolicyTieTolerance;

qStateRef = curState;
qStateRef{player.sLen +1} = ':';
qStateRef{player.sLen +2} = ':';
qt = squeeze(player.Qvalues(qStateRef{:}));

minQ = min(min(qt));
if minQ < 0
    qt = qt - minQ;
end
if sum(sum(qt)) < 1e-6
    pol = zeros(size(qt));
else
    % turn translated q-values into probs
    pol = qt ./ sum(sum(qt));
end

maxPol = max(max(pol));  
noTie = find(pol + PolicyTieTolerance < maxPol);
pol(noTie) = 0;
% find nonZero entries, choose uniformly from equal policies
nonZero = find(pol);
if isempty(nonZero)
    nonZero = 1:(size(pol,1) * size(pol,2));
end
choice = ceil(rand * length(nonZero));
[oAct, aAct] = ind2sub(size(pol), nonZero(choice));

chosenAction = aAct;
