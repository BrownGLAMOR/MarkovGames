%-----------------------------------------------------------------------
% funciton: gengraphs
%
%-----------------------------------------------------------------------
function gengraphs(location, games, teams, teamlabels, variterlist, graphType, numIter, ...
                   gType, pEps, expStr, plotScale, convList)

if nargin < 7
    numIter = 1000;
end
if nargin < 6
    graphType = 'all';
end
if nargin < 5
    variterlist = [10:100];
end
if nargin < 8
    gType = 'other';
end
if nargin < 9
    pEps = 0;
end
if nargin < 10
    expStr = '-NG-alpha1-eps1';
end
if nargin < 11
    plotScale = 1000;
end
if nargin < 12
    convList = {'max'};
end
valiter_str = '';
numAction = 2;
switch gType
case 'grid'
    statelen = 4;
case 'soccer'
    statelen = 5;
case 'other'
    statelen = 1;
otherwise
    error(['Unknown game type: ', gType]);
end
valiter = 0;
for g = 1:size(games,2)
    gametype = games{g};
    for t = 1:size(teams,2)
        teamtype = teams{t};
        disp([' ']);
        disp(['Game: ', gametype, '  Team: ',teamtype]);
        oName = [gametype,'-',teamtype,valiter_str,'-',num2str(numIter),expStr];
        if pEps > 0
            oName = [oName, '-pturb', num2str(pEps)];
        end
        oName = strrep(oName, '0.','_');
        qh1 = load([location, oName,'-qhist1.txt']);
        qh2 = load([location, oName,'-qhist2.txt']);

        fname = [location, 'graphs/', oName];

        switch graphType
        case {'all','q','qval'}
            for ci = 1:size(convList,2)
                convType = convList{ci};
                % plot standard q-value convergence graphs
                cv1 = convinfo(qh1, numIter, statelen + 5, plotScale, convType);
                cv2 = convinfo(qh2, numIter, statelen + 5, plotScale, convType);
                iterPerPoint = numIter / plotScale;

                plotFrom = 1;
                plotTo = 100000;
                plotFromPoint = ceil(plotFrom / iterPerPoint);
                plotToPoint = ceil(plotTo / iterPerPoint);
                plot(iterPerPoint * [plotFromPoint:plotToPoint], cv1(plotFromPoint:plotToPoint), 'r-', ...
                     iterPerPoint * [plotFromPoint:plotToPoint], cv2(plotFromPoint:plotToPoint), 'b-.');
                % axis([-inf,inf,0,.1]);
                set(gca, 'FontSize', 14);
                axis([-inf,inf,0,inf]);
                legend({'Player 1', 'Player 2'},1);
                xlabel('Number of Iterations', 'FontSize', 18);
                switch convType
                case 'mean'
                    ylb = 'Mean';
                case 'meanback'
                    ylb = 'Mean';
                case 'meanslide'
                    ylb = 'Sliding Mean';
                case 'std'
                    ylb = 'Standard Deviation';
                case 'stdback'
                    ylb = 'Standard Deviation';
                case 'stdslide'
                    ylb = 'Sliding Standard Deviation';
                case 'rms'
                    ylb = 'RMS';
                case 'rmsback'
                    ylb = 'RMS';
                case 'rmsslide'
                    ylb = 'Sliding RMS';
                case 'max'
                    ylb = 'Max';
                case 'maxback'
                    ylb = 'Max';
                case 'maxslide'
                    ylb = 'Sliding Max';
                end
                ylabel([ylb, ' Q-Value Difference'], 'FontSize', 18);
                eval(['title(''', teamlabels{t}, '-', gametype, ' - Iterations ', ...
                     num2str(plotFrom), '-', num2str(plotTo), ''', ''FontSize'', 20)']);
                eval(['print -deps ',fname,'-1-100k-QConv-',convType, '.eps']);
                close;

                plotFrom = 1;
                plotTo = 10000;
                plotFromPoint = ceil(plotFrom / iterPerPoint);
                plotToPoint = ceil(plotTo / iterPerPoint);
                plot(iterPerPoint * [plotFromPoint:plotToPoint], cv1(plotFromPoint:plotToPoint), 'r-', ...
                     iterPerPoint * [plotFromPoint:plotToPoint], cv2(plotFromPoint:plotToPoint), 'b-.');
                %axis([-inf,inf,0,.01]);
                axis([-inf,inf,0,1]);
                set(gca, 'FontSize', 14);
                legend({'Player 1', 'Player 2'},1);
                xlabel('Number of Iterations', 'FontSize', 18);
                ylabel([ylb, ' Q-Value Difference'], 'FontSize', 18);
                eval(['title(''', teamlabels{t}, '-', gametype, ' - Iterations ', ...
                     num2str(plotFrom), '-', num2str(plotTo), ''', ''FontSize'', 20)']);
                eval(['print -deps ',fname,'-1-10k-QConv-', convType, '.eps']);
                close;

                plotFrom = 5000;
                plotTo = 200000;
                plotFromPoint = ceil(plotFrom / iterPerPoint);
                plotToPoint = ceil(plotTo / iterPerPoint);
                plot(iterPerPoint * [plotFromPoint:plotToPoint], cv1(plotFromPoint:plotToPoint), 'r-', ...
                     iterPerPoint * [plotFromPoint:plotToPoint], cv2(plotFromPoint:plotToPoint), 'b-.');
                %axis([-inf,inf,0,.01]);
                axis([-inf,inf,0,1]);
                set(gca, 'FontSize', 14);
                legend({'Player 1', 'Player 2'},1);
                xlabel('Number of Iterations', 'FontSize', 18);
                ylabel([ylb, ' Q-Value Difference'], 'FontSize', 18);
                eval(['title(''', teamlabels{t}, '-', gametype, ' - Iterations ', ...
                     num2str(plotFrom), '-', num2str(plotTo), ''', ''FontSize'', 20)']);
                eval(['print -deps ',fname,'-10k-200k-QConv-', convType, '.eps']);
                close;

                plotFrom = 100000;
                plotTo = 200000;
                plotFromPoint = ceil(plotFrom / iterPerPoint);
                plotToPoint = ceil(plotTo / iterPerPoint);
                plot(iterPerPoint * [plotFromPoint:plotToPoint], cv1(plotFromPoint:plotToPoint), 'r-', ...
                     iterPerPoint * [plotFromPoint:plotToPoint], cv2(plotFromPoint:plotToPoint), 'b-.');
                %axis([-inf,inf,0,.01]);
                axis([-inf,inf,0,.1]);
                set(gca, 'FontSize', 14);
                legend({'Player 1', 'Player 2'},1);
                xlabel('Number of Iterations', 'FontSize', 18);
                ylabel([ylb, ' Q-Value Difference'], 'FontSize', 18);
                eval(['title(''', teamlabels{t}, '-', gametype, ' - Iterations ', ...
                     num2str(plotFrom), '-', num2str(plotTo), ''', ''FontSize'', 20)']);
                eval(['print -deps ',fname,'-100k-200k-QConv-', convType, '.eps']);
                close;
            end
        case {'all', 'qval','val','polspace'}
            switch gType
            case 'grid'
                qh1 = filterHist(qh1,[3,1,1,1],4);
                qh2 = filterHist(qh2,[3,1,1,1],4);
            case 'soccer'
                qh1 = filterState(qh1,[2,3,2,2,1]);
                qh2 = filterState(qh2,[2,3,2,2,1]);
            case 'other'
            end
            qlist1 = accumQvals(qh1, numAction, statelen, valiter);
            qlist2 = accumQvals(qh2, numAction, statelen, valiter);
            iterlist = [variterlist(1):min(min(variterlist(end), size(qlist1, 1)), size(qlist2,1))];
            fname = [location, 'graphs/',teamtype, '-',gametype,'-',num2str(iterlist(1)),...
                     '-',num2str(iterlist(end))];
            if pEps > 0
                fname = [fname, '-pturb', num2str(pEps)];
                fname = strrep(fname, '0.','_');
            end
        case {'all','polspace'}
            figure;
            plot3(qlist1(iterlist,5),qlist1(iterlist,7),qlist1(iterlist,6), 'b--+');
            hold;
            plot3(qlist1(iterlist(1),5),qlist1(iterlist(1),7),qlist1(iterlist(1),6),...
                  'kd', 'MarkerFaceColor','g', 'MarkerSize', 10);
            plot3(qlist1(iterlist(end),5),qlist1(iterlist(end),7),qlist1(iterlist(end),6),...
                  'ko', 'MarkerFaceColor', 'g', 'MarkerSize', 10);
            set(gca, 'FontSize', 14);
            axis([0 1 0 1 0 1]);
            grid on;
            box on;
            hold;
            eval(['title(''', teamlabels{t}, '-', gametype, ' - Iterations ', ...
                 num2str(iterlist(1)), '-', num2str(iterlist(end)), ''', ''FontSize'', 20)']);
            eval(['print -depsc ',fname, '-C.eps']);
            eval(['print -deps ',fname, '.eps']);
            close;
        case {'all','qval','val'}
            figure;
            plot(iterlist,qlist1(iterlist,9),'b',iterlist,qlist2(iterlist,9),'b--');
            set(gca, 'FontSize', 14);
            legend({'Player 1', 'Player 2'},1);
            xlabel('Number of Iterations', 'FontSize', 18);
            ylabel('Value', 'FontSize', 18);
            %legend('Player 1','Player 2');
            eval(['title(''', teamlabels{t}, '-', gametype, ' - Iterations ', ...
                 num2str(iterlist(1)), '-', num2str(iterlist(end)), ''', ''FontSize'', 20)']);
            eval(['print -deps ',fname,'-ValueConv.eps']);
            close;
        otherwise
            error(['Unknown graph type: ', graphType]);
        end
    end
end
