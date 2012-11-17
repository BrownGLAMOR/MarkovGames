%-----------------------------------------------------------------------
% funciton: compq
%        compare Q-values for all n^2 dataset combinations at the given state
%
%-----------------------------------------------------------------------
function qdiff = compq(goodData, dataset, gameType, stateToPlot)

switch gameType
case {'soccer','s','soc'}
    disp(['Generating comparisons for SOCCER game']);
    stateDims = [2,4,2,4,2];
    if nargin < 4
        stateToPlot= {1,3,1,2,2};
    end
    expdir = ['experiments/soccer/'];
case {'grid','g'}
    disp(['Generating comparisons for GRID game']);
    stateDims = [3,3,3,3];
    if nargin < 4
        stateToPlot= {3,1,1,1};
    end
    expdir = ['experiments/grid/'];
end

plotCol = length(stateDims) + 4;        % for the current action column

stateRef = stateToPlot;
stateRef{length(stateToPlot) + 1}  = ':';
stateRef{length(stateToPlot) + 2}  = ':';
% load good data first
for gix = 1:length(goodData)
    slashPos = strfind(goodData{gix}, '/');
    if isempty(slashPos) == 0
        goodData{gix} = goodData{gix}(slashPos(end)+1:end);
    end
    gName = [expdir goodData{gix}];
    disp(['Loading Reference data for ' goodData{gix}]);
    load(gName);
    gteams = get(simul,'Teams');
    gq{1} = get(gteams{1},'QTable');
    gq{2} = get(gteams{2},'QTable');
    clear simul;

    for dix = 1:length(dataset)
        slashPos = strfind(dataset{dix}, '/');
        if isempty(slashPos) == 0
            dataset{dix} = dataset{dix}(slashPos(end)+1:end);
        end
        oName = [expdir dataset{dix}];
        disp(['Loading Data for ' dataset{dix}]);
        load(oName);
        dteams = get(simul,'Teams');
        dq{1} = get(dteams{1},'QTable');
        dq{2} = get(dteams{2},'QTable');
        clear simul;
        qdiff{gix}(dix, 1) = min(sum(sum(abs(squeeze(gq{1}(stateRef{:})) - squeeze(dq{1}(stateRef{:}))))),...
                                 sum(sum(abs(squeeze(gq{1}(stateRef{:}))' - squeeze(dq{1}(stateRef{:}))))));
        qdiff{gix}(dix, 2) = min(sum(sum(abs(squeeze(gq{2}(stateRef{:})) - squeeze(dq{2}(stateRef{:}))))),...
                                 sum(sum(abs(squeeze(gq{2}(stateRef{:}))' - squeeze(dq{2}(stateRef{:}))))));
        %qdiff{gix}
    end
end
