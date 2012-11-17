%-----------------------------------------------------------------------
% function plotRegState(AgInd, Ac, AcInd, stateDims, state, plotCol, yvals)
%
%-----------------------------------------------------------------------
function plotRegState(Ag, AcInd, stateDims, state, goodMoves, moveNames, regType, lineMarker, maxPoints)

if nargin < 8
  lineMarker = {'r-','r--','b-.','b:','ro-','rd-','b*-', 'bs-'};
end
% assume symmetric actions
numActions = size(AcInd, 2);

stateInd = sub2ind(stateDims, state{:});
disp(['State Index: ', num2str(stateInd)]);

firstCol = length(stateDims) + 5 + numActions + 1;
lastCol = firstCol + numActions * numActions - 1;
clear rg;
rg{1} = Ag{1}{stateInd}(:,[firstCol:lastCol]);
rg{2} = Ag{2}{stateInd}(:,[firstCol:lastCol]);

plotRegs(rg, regType, goodMoves, moveNames, 1, lineMarker, maxPoints);
