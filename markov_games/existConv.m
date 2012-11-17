%-----------------------------------------------------------------------
% function existConv(numTests, algType, numIter, diffThresh)
%
%
%-----------------------------------------------------------------------
function existConv(numTests, algType, numIter, diffThresh, plotType)


if nargin < 4
    diffThresh = .00001;
end
if nargin < 3
    numIter = 1000;
end
plotAll = 0;
plotBad = 0;
if nargin > 4
    switch plotType
        case 'All'
            plotAll = 1;
        case 'Bad'
            plotBad = 1;
        case 'None'
        otherwise
            error(['Incorrect plotType (', plotType, ')']);
    end
end
    
numToCheck = 20;  % number of qHist rows (from end) to check 
checkCol = 6;     % column of qHist with q-value diffs

eval(['!mkdir experiments/Exist/noConverge/', algType]);
eval(['!rm -rf experiments/Exist/noConverge/', algType, '/*']);

curNC = 0;
for testNum = 1:numTests
    runExp('Exist',algType,numIter, 2, []);
    outputName = ['experiments/Exist/Exist-', algType, '-', ...
                  int2str(numIter), '-uniformAlpha'];
    noConverge = 0;
    for i = 1:2
        qh = load([outputName, '-qhist', int2str(i), '.txt']);
        %sumDiffs = sum(abs(qh(numIter - numToCheck:end, checkCol)));
        sumDiffs = mean(abs(qh(numIter - numToCheck:end, checkCol)));
        testTitle = ['Test ', int2str(testNum), ' agent ', int2str(i)];
        disp([testTitle, ' sumDiff: ', num2str(sumDiffs)]);
        if plotAll == 1
            figure;
            plot(abs(qh(:,checkCol)));
            title(testTitle);
        end
        if sumDiffs > diffThresh
            noConverge = noConverge + 1;
            if plotBad ==1 & plotAll == 0
                figure;
                plot(abs(qh(:,checkCol)));
                title(testTitle);
            end
        end
    end
    if noConverge > 0
        curNC = curNC + 1;
        %copy .mat and qhist files to dir
        eval(['!mkdir experiments/Exist/noConverge/',algType,'/',...
              int2str(curNC)]);
        copyStr = ['!mv ', outputName, '* experiments/Exist/noConverge/',...
                   algType, '/', int2str(curNC)];
        eval(copyStr);
    end
end
