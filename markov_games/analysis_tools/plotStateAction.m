%-----------------------------------------------------------------------
% function plotStateAction(AgInd, Ac, AcInd, stateDims, state, plotCol, yvals)
%
%-----------------------------------------------------------------------
function plotStateAction(AgInd, Ac, AcInd, stateDims, state, plotCol, yvals, xpose, goodMoves,moves)

if nargin < 8
    xpose = 'notranspose';
end

% assume symmetric actions
numActions = size(AcInd, 2);

if nargin < 9
    rowMoves = 1:numActions;
    colMoves = 1:numActions;
else
        rowMoves = goodMoves{1};
        rowMovesName = moves{1};
        colMoves = goodMoves{2};
        colMovesName = moves{2};
end

stateInd = sub2ind(stateDims, state{:});
disp(['State Index: ', num2str(stateInd)]);


numPoints = max(AgInd{stateInd});

numRow = length(rowMoves);
numCol = length(colMoves);
for i = rowMoves
    for j = colMoves
        rowMoveIx = find(rowMoves == i);
        colMoveIx = find(colMoves == j);
        subplot(numRow,numCol,sub2ind([numCol,numRow], colMoveIx,rowMoveIx));
        if strcmp(xpose,'transpose') == 1
            if length(plotCol) > 0
                %plot(AgInd{stateInd}(AcInd{stateInd,j,i}), sum(Ac{stateInd,j,i}(:,plotCol),2),'r');
                plot(AcInd{stateInd,j,i}, sum(Ac{stateInd,j,i}(:,plotCol),2),'r');
            else
                %plot(AgInd{stateInd}(AcInd{stateInd,j,i}), abs(Ac{stateInd,j,i}(:,plotCol)),'r');
                plot(AcInd{stateInd,j,i}, abs(Ac{stateInd,j,i}(:,plotCol)),'r');
            end
        else
            if length(plotCol) > 0
                %plot(AgInd{stateInd}(AcInd{stateInd,i,j}), sum(Ac{stateInd,i,j}(:,plotCol),2),'r');
                plot(AcInd{stateInd,i,j}, sum(Ac{stateInd,i,j}(:,plotCol),2),'r');
            else
                %plot(AgInd{stateInd}(AcInd{stateInd,i,j}), abs(Ac{stateInd,i,j}(:,plotCol)),'r');
                plot(AcInd{stateInd,i,j}, abs(Ac{stateInd,i,j}(:,plotCol)),'r');
            end
        end
        if nargin > 6
            axis([0,numPoints, yvals(1), yvals(2)]);
        end
        if (nargin < 10)
            title([num2str(i) ',' num2str(j)]);
        else
            title([rowMovesName{rowMoveIx}, ',', colMovesName{colMoveIx}]);
        end
    end
end
