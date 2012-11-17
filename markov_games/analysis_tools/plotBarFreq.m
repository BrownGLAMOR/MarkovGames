%-----------------------------------------------------------------------
% Funciton: function plotBarFreq(Freq)
%
% Description:
%
%-----------------------------------------------------------------------
function plotBarFreq(Freqs, graphType)

numPlayer = size(Freqs,2);
cols = 10;
rows = ceil(numPlayer / cols);
[numIter, numAct] = size(Freqs{1});
colors = 'rbgkmcy';

if nargin < 2 | strcmp(graphType, 'individual')
    for player = 1:numPlayer
        subplot(rows, cols, player);
        pStr = ['plot('];
        for act = 1:numAct
            pStr = [pStr, '1:', num2str(numIter), ',Freqs{', num2str(player), ...
                    '}(:,', num2str(act), '), ''', colors(act), ''','];
        end
        pStr(length(pStr)) = ')';
        eval(pStr);
    end
end

if nargin < 2
    figure;
end
if nargin < 2 | strcmp(graphType, 'combined')
    hold;
    for player = 1:numPlayer
        plot(1:numIter, Freqs{player}(:,1), '-.');
    end
    hold;
    axis([0 numIter 0 1]);
    xlabel('Iteration number', 'FontSize', 14);
    ylabel('Attendance Frequency', 'FontSize', 14);
end
