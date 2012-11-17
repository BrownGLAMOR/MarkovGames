%-----------------------------------------------------------------------
% function [qh, Ag, AgInd, Ac, AcInd] = ...
%    loadPlot(histFileName, stateDims, numPoints, plotCol, qh)
%
%-----------------------------------------------------------------------
function [qh, Ag, AgInd, Ac, AcInd] = ...
    loadPlot(histFileName, stateDims, numPoints, plotCol, qh)

if nargin < 5
    qh = load(histFileName);
end
if nargin < 4
    plotCol = size(qh, 2);
end
if nargin < 3
    numPoints = max(10000, size(qh, 1));
end
disp(['Plotting num points: ', num2str(numPoints)]);

[Ag, AgInd, Ac, AcInd] = filterStateAction(qh, stateDims);
if plotCol <= size(qh,2)
    plotStates(Ag, AgInd, stateDims, plotCol, numPoints);
end
