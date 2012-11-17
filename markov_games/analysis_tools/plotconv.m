%-----------------------------------------------------------------------
% 
% function plotconv([cvQQ; cvMM; cvFF; cvCC], numIter, numIntervals, plotType, graphTitle, yTYpe, legloc)
%
%-----------------------------------------------------------------------
function plotconv(cvVec, numIter, numIntervals, plotType, graphTitle, ...
                  yType, legloc, legvec)


plotInts = numIntervals;
partSize = numIter / numIntervals;

%figure;
if plotType < 3
    if nargin < 5
        legloc = 3;
    end
    switch plotType 
    case 1
        plot(partSize * (1:plotInts), cvVec(1, 1:plotInts), '-', ...
         partSize * (1:plotInts), cvVec(2, 1:plotInts), '-o', ...
         partSize * (1:plotInts), cvVec(3, 1:plotInts), '-^', ...
         partSize * (1:plotInts), cvVec(4, 1:plotInts), '-+', 'MarkerSize', 4);
    case 2
        plot(partSize * (1:plotInts), cvVec(1, 1:plotInts), '-', ...
         partSize * (1:plotInts), cvVec(2, 1:plotInts), '-o', ...
         partSize * (1:plotInts), cvVec(3, 1:plotInts), '-^', 'MarkerSize', 4);
    end


    titleStr = ['title(''', graphTitle, ''',''FontSize'',20)'];
    eval(titleStr);
    xlabel('Simulation Iteration', 'FontSize', 16);
    switch yType
    case 'mean'
        ylabel('Mean Q-value Difference', 'FontSize', 16);
    case 'rms'
        ylabel('RMS Q-value Difference', 'FontSize', 16);
    case 'std'
        ylabel('Standard-Dev Q-value Difference', 'FontSize', 16);
    case 'max'
        ylabel('Max Q-value Difference', 'FontSize', 16);
    otherwise
        error(['bad yType']);
    end
    if nargin < 8
        %legend('Hedge-Q', 'Foe-Q', 'Friend-Q', 'Correlated-Q', legloc);
        switch plotType 
        case 1
            legend('Q','Foe-Q', 'Friend-Q', 'uCE-Q', legloc);
        case 2
            legend('Q','Foe-Q', 'Friend-Q', legloc);
        end
    else
        legend(legvec{1}, legvec{2}, legvec{3}, legvec{4}, legloc);
    end
else
    subplot(2,2,1);
    plot(partSize * (1:plotInts), cvVec(1, 1:plotInts));
    title('Q');

    subplot(2,2,2);
    plot(partSize * (1:plotInts), cvVec(2, 1:plotInts));
    title('Foe-Q');

    subplot(2,2,3);
    plot(partSize * (1:plotInts), cvVec(3, 1:plotInts));
    title('Friend-Q');

    subplot(2,2,4);
    plot(partSize * (1:plotInts), cvVec(4, 1:plotInts));
    title('Correlated-Q');
end
