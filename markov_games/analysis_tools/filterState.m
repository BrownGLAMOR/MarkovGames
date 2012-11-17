%-----------------------------------------------------------------------
% Funciton: 
%
% Description:
%
%-----------------------------------------------------------------------
function [newMatrix] = filterState(histMatrix, state)

numIter = size(histMatrix, 1);
stateSize = size(state, 2);
newMatrix = zeros(size(histMatrix));
newIx = 0;
for i = 1:numIter
    if histMatrix(i, 1:stateSize) == state
        newIx = newIx + 1;
        newMatrix(newIx, :) = histMatrix(i, :);
    end
end
newMatrix = newMatrix(1:newIx, :);
