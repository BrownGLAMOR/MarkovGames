%-----------------------------------------------------------------------
% File: calcV
%
% Description:
%   calculate V at current state
%
%-----------------------------------------------------------------------
function [player, V] = calcV(player, newState);

global PolicyTieTolerance;

qStateRef = newState;
qStateRef{player.sLen + 1} = ':';
qStateRef{player.sLen + 2} = ':';
pStateRef = newState;
pStateRef{player.sLen + 1} = ':';
V = max(max(squeeze(player.Qvalues(qStateRef{:}))));

qt = squeeze(player.Qvalues(qStateRef{:}));
pol = qt;
[maxRow, maxRowIx] = max(pol);
[maxVal, maxColIx] = max(maxRow);

len = size(qt,2);
myPol = zeros(1,player.numActions);
if (maxVal == 0)
    myPol(ceil(rand * player.numActions)) = 1;
else
    noTie = find(pol + PolicyTieTolerance < maxVal);
    pol(noTie) = 0;
    pol = sum(pol,1);
    myPol(:) = (pol ~= 0);
    myPol = (myPol ./ sum(myPol));
end
player.Policy(pStateRef{:}) = myPol;
