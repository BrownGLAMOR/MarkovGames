%-----------------------------------------------------------------------
% function [qAcInd, qAc] = plotQstate(Ag, AgInd, numActions, actionCol, ...
%                                       stateNum, plotCol)
%
%-----------------------------------------------------------------------
function [qAcInd, qAc] = plotQstate(Ag, AgInd, numActions, actionCol, ...
                                      stateNum, plotCol, yvals)

qAcInd = cell(numActions);
qAc = cell(numActions);

for i = 1:numActions
    rows = find(Ag{stateNum}(:, actionCol) == i);
    qAc{i} = Ag{stateNum}(rows, :);
    qAcInd{i} = rows;
end

numPoints = max(AgInd{stateInd});

for i = 1:numActions
    subplot(numActions,1, i);
    plot(AgInd{stateInd}(qAcInd{i}), abs(qAc{i}(:,plotCol)));
    axis([0,numPoints, yvals(1), yvals(2)]);
end
