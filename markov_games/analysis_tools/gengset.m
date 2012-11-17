%-----------------------------------------------------------------------
% funciton: gengset
%
%-----------------------------------------------------------------------
function gengset(location, games, teams, teamlabels, numIter, gType, pEps, plotScale, convList, gsName, axisVals)

lineMarker = {'k-','k--','k-.','k:','k+-','kx-','kv-','ks-'};
if nargin < 5
  numIter = 1000;
end
if nargin < 6
  gType = 'other';
end
if nargin < 7
  pEps = 0;
end
if nargin < 8
  plotScale = 1000;
end
if nargin < 9 
  convList = {'max'};
end
if nargin < 10
  gsName = 'graphSet';
end
if nargin < 11
  axisVals = [-inf,inf,0,.1];
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
tData = cell(size(teams,2),2);
for g = 1:size(games,2)
  gametype = games{g};
  for t = 1:size(teams,2)
    teamtype = teams{t};
    disp([' ']);
    disp(['Game: ', gametype, '  Team: ',teamtype]);
    oName = [gametype,'-',teamtype]
    if pEps > 0
      oName = [oName, '-pturb', num2str(pEps)];
    end
    oName = strrep(oName, '0.','_');
    tData{t,1} = load([location, oName,'-qhist1.txt']);
    %tData{t,2}= load([location, oName,'-qhist2.txt']);
  end

  fname = [location, 'graphs/',gsName,'-',gametype];
  for ci = 1:size(convList,2)
    convType = convList{ci};
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
    case 'maxmax'
      ylb = 'Max';
    case 'maxslide'
      ylb = 'Sliding Max';
    end
    % plot standard q-value convergence graphs
    iterPerPoint = numIter / plotScale;

    plotFrom = 1;
    plotTo = numIter;
    plotShow = max(numIter - 50000, numIter - (numIter/10));
    plotFromPoint = ceil(plotFrom / iterPerPoint);
    plotToPoint = ceil(plotTo / iterPerPoint);
    plotShowPoint = ceil(plotShow / iterPerPoint);
    for pl = 1:1
      figure;
      hold;
      for t = 1:size(teams,2)
        cv = convinfo(tData{t,pl}, numIter, statelen + 5, plotScale, convType);
        plot(iterPerPoint * [plotFromPoint:plotShowPoint], cv(plotFromPoint:plotShowPoint), lineMarker{t});
      end
      hold;
      set(gca, 'FontSize', 14);
      axis(axisVals);
      if (size(teamlabels) > 1)
        legend(teamlabels{:},1);
      end
      xlabel('Number of Iterations', 'FontSize', 18);
      ylabel([ylb, ' Q-Value Difference'], 'FontSize', 18);
      %eval(['title(''', games{g}, ' (player ', num2str(pl),') - Iterations ', ...
      %   num2str(plotFrom), '-', num2str(plotTo), ''', ''FontSize'', 20)']);
      eval(['print -deps ',fname,'-',num2str(plotFrom),'-',num2str(plotShow/1000),'k-QConv-', convType, '-p',num2str(pl),'.eps']);
      close;

      plotFrom = 5000;
      plotTo = numIter;
      plotShow = max(numIter - 50000, numIter - (numIter/10));
      plotFromPoint = ceil(plotFrom / iterPerPoint);
      plotToPoint = ceil(plotTo / iterPerPoint);
      plotShowPoint = ceil(plotShow / iterPerPoint);
      figure;
      hold;
      for t = 1:size(teams,2)
        cv = convinfo(tData{t,pl}, numIter, statelen + 5, plotScale, convType);
        plot(iterPerPoint * [plotFromPoint:plotShowPoint], cv(plotFromPoint:plotShowPoint), lineMarker{t});
      end
      axis(axisVals);
      set(gca, 'FontSize', 14);
      if (size(teamlabels) > 1)
        legend(teamlabels{:},1);
      end
      xlabel('Number of Iterations', 'FontSize', 18);
      ylabel([ylb, ' Q-Value Difference'], 'FontSize', 18);
      %eval(['title(''', games{g}, ' (player ', num2str(pl),') - Iterations ', ...
      %   num2str(plotFrom), '-', num2str(plotTo), ''', ''FontSize'', 20)']);
      eval(['print -deps ',fname,'-',num2str(plotFrom/1000),'k-',num2str(plotShow/1000),'k-QConv-', convType, '-p',num2str(pl),'.eps']);
      close;

      if numIter > 100000
        plotFrom = 100000;
      else
        if numIter > 1000
        plotFrom = 1000;
        else
        plotFrom = 1;
        end
      end
      plotTo = numIter;
      plotShow = max(numIter - 50000, numIter - (numIter/10));
      plotFromPoint = ceil(plotFrom / iterPerPoint);
      plotToPoint = ceil(plotTo / iterPerPoint);
      plotShowPoint = ceil(plotShow / iterPerPoint);
      figure;
      hold;
      for t = 1:size(teams,2)
        cv = convinfo(tData{t,pl}, numIter, statelen + 5, plotScale, convType);
        plot(iterPerPoint * [plotFromPoint:plotShowPoint], cv(plotFromPoint:plotShowPoint), lineMarker{t});
      end
      axis(axisVals);
      set(gca, 'FontSize', 14);
      if (size(teamlabels) > 1)
        legend(teamlabels{:},1);
      end
      xlabel('Number of Iterations', 'FontSize', 18);
      ylabel([ylb, ' Q-Value Difference'], 'FontSize', 18);
      %eval(['title(''', games{g}, ' (player ', num2str(pl),') - Iterations ', ...
      %   num2str(plotFrom), '-', num2str(plotTo), ''', ''FontSize'', 20)']);
      eval(['print -deps ',fname,'-',num2str(plotFrom/1000),'k-',num2str(plotShow/1000),'k-QConv-', convType, '-p',num2str(pl),'.eps']);
      close;
    end
  end
end
