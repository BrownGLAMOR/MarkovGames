%-----------------------------------------------------------------------
% function plotFreqState()
%
%-----------------------------------------------------------------------
function plotFreqState(Ag, AgInd, AcInd, stateDims, state, goodMoves, moveNames, lineMarker, maxPoints)

if nargin < 8
  lineMarker = {'r-','r--','b-.','b:','ro-','rd-','b*-', 'bs-'};
end
if nargin < 9
    maxPoints = 2000;
end
stateInd = sub2ind(stateDims, state{:});
disp(['State Index: ', num2str(stateInd)]);
actionCol = length(stateDims) + 2;                % index of my action in the row

% matlab graphing sucks!!!
%set(0, 'DefaultAxesColorOrder', 'default');
%set(0,'DefaultAxesLineStyleOrder', 'default');
%color_ord = get(0, 'DefaultAxesColorOrder');
%line_ord = {'-.','-'};
%set(0,'DefaultAxesLineStyleOrder', {'-','-d','-.',':','-o','--','-*'});
%set(0, 'DefaultAxesColorOrder', color_ord([6],:));

numColor = length(lineMarker);
curCol = 1;
for i = 1:2
    %set(0,'DefaultAxesLineStyleOrder', line_ord{i});
    numActions = size(AcInd{i}, 2); % assume symmetric actions

    tmpfreq = accumfreq(Ag{i}{stateInd}(:, actionCol), numActions);
    freq = tmpfreq(:,goodMoves{i});
    inds = AgInd{i}{stateInd};

    itinc = max(1, floor(length(AgInd{i}{stateInd})/maxPoints));

    first = 1;
    for moveIx = 1:length(goodMoves{i})
        plot(AgInd{i}{stateInd}(1:itinc:end), freq(1:itinc:end,moveIx), lineMarker{curCol});   % ,colStr{i}); 
        curCol = curCol + 1;
        if i == 1 & first == 1
            hold;
            first = 0;
        end
    end
end


legend(moveNames{:});
