%-----------------------------------------------------------------------
% function: plotRes
%       Plot the results for an interesting state for the grid/soccer games
%       pass in the partial filenames of the datasets
%
% like:
%   dataset = { 'grid3-DELPEACE200-500000-alpha1-eps_01',       'grid3-PEACE-1000000-alpha1-eps_01', ...
%               'grid1-DELHMC200-500000-alpha1-eps_01',         'grid1-HMC-1000000-alpha1-eps_01',...
%               'grid3-DELHMC200-500000-alpha1-eps_01',         'grid3-HMC-1000000-alpha1-eps_01'};
%-----------------------------------------------------------------------
function plotRes(dataset, gameType, withRegrets, withQValues)

numPlotPoints = 100;   % used for plotting regrets and frequencies

if nargin < 2
    gameType = 'grid';
end
if nargin < 3
    withRegrets = 1;
end
if nargin < 4
    withQValues = 1;
end

switch gameType
case {'soccer','s','soc'}
    disp(['Generating results for SOCCER game']);
    %lineMarker = {'r-','r--','r-.','r:','b-','b--','b-.','b:'};
    lineMarker = {'k-','k--','k-.','k:','k+-','kx-','kv-','ks-'};
    stateDims = [2,4,2,4,2];
    %stateToPlot= {2,3,2,2,2};
    %goodMoves = {2:5,2:5};
    %partmoves = {{'South','East','West','Stick'}, {'South','East','West','Stick'}};
    %allmoves = {{'P1:South','P1:East','P1:West','P1:Stick','P2:South','P2:East','P2:West','P2:Stick'}};
    stateToPlot= {1,3,1,2,2};
    goodMoves = {[1 3:5],[1 3:5]};
    partmoves = {{'North','East','West','Stick'}, {'North','East','West','Stick'}};
    allmoves = {{'P1:North','P1:East','P1:West','P1:Stick','P2:North','P2:East','P2:West','P2:Stick'}};
    expdir = ['experiments/soccer/'];
case {'grid','g'}
    disp(['Generating results for GRID game']);
    %lineMarker = {'r-','r--','b-.','b:'};
    lineMarker = {'k-','k--','k-.','k:','k+-','kx-','kv-','ks-'};
    stateDims = [3,3,3,3];
    stateToPlot= {3,1,1,1};
    goodMoves = {[2,3],[1,3]};
    partmoves = {{'P1Center','P1Side'},{'P2Center', 'P2Side'}};
    allmoves = {'P1:Center','P1:Side','P2:Center','P2:Side'};
    expdir = ['experiments/grid/'];
end



plotCol = length(stateDims) + 4;        % for the current action column
for dix = 1:length(dataset)
    slashPos = strfind(dataset{dix}, '/');
    if isempty(slashPos) == 0
        dataset{dix} = dataset{dix}(slashPos(end)+1:end);
    end
    oName = [expdir dataset{dix}];
    disp(['Loading Data for ' dataset{dix}]);
    qh1 = load(strcat(oName,'-qhist1.txt'));
    [Ag1, AgInd1, Ac1, AcInd1] = filterStateAction(qh1, stateDims);
    clear qh1;
    if withQValues
        disp(['   Plotting P1 Q-values for ' dataset{dix}]);
        figure; 
        plotStateAction(AgInd1,Ac1,AcInd1,stateDims,stateToPlot,plotCol, [0,1],'transpose',goodMoves, partmoves);
        eval(['print -depsc2 ' expdir 'graphs/' dataset{dix} '-q1.eps']);
        close;
    end

    qh2 = load(strcat(oName,'-qhist2.txt'));
    [Ag2, AgInd2, Ac2, AcInd2] = filterStateAction(qh2, stateDims);
    clear qh2;
    if withQValues
        disp(['   Plotting P2 Q-values for ' dataset{dix}]);
        figure;
        plotStateAction(AgInd2,Ac2,AcInd2,stateDims,stateToPlot,plotCol, [0,1],'no',goodMoves, partmoves);
        eval(['print -depsc2 ' expdir 'graphs/' dataset{dix} '-q2.eps']);
        close;
    end

    if withRegrets
        disp(['   Plotting Regrets for ' dataset{dix}]);
        figure;
        plotRegState({Ag1,Ag2},AcInd1,stateDims,stateToPlot,goodMoves,allmoves, 'internal',lineMarker, numPlotPoints);
        eval(['print -depsc2 ' expdir 'graphs/' dataset{dix} '-regsI.eps']);
        close;
        figure;
        plotRegState({Ag1,Ag2},AcInd1,stateDims,stateToPlot,goodMoves,allmoves, 'external',lineMarker, numPlotPoints);
        eval(['print -depsc2 ' expdir 'graphs/' dataset{dix} '-regsE.eps']);
        close;
    else
        disp(['   No regrets to plot']);
    end

    disp(['   Plotting Frequencies for ' dataset{dix}]);
    figure;
    plotFreqState({Ag1,Ag2},{AgInd1,AgInd2},{AcInd1, AcInd2},stateDims,stateToPlot,goodMoves,allmoves, lineMarker, numPlotPoints);
    eval(['print -depsc2 ' expdir 'graphs/' dataset{dix} '-freqs.eps']);
    close;
end
