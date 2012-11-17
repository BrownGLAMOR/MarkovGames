%-----------------------------------------------------------------------
% File: filterHist
%
% Description:
%   filter a 2player history file, converting actions sets to 
%   start from 1 through the number of actions used.
%   
%
%-----------------------------------------------------------------------
function [qhist_new] = filterHist(origQhist, state, numActions, p1Actions, p2Actions)

qhist = filterState(origQhist, state);
stateSize = size(state, 2);

if nargin < 4
    p1Actions = unique(qhist(:,stateSize+1));
    p2Actions = unique(qhist(:,stateSize+2));
end

for i = 1:length(p1Actions)
    qhist(find(qhist(:,stateSize+1) == p1Actions(i)), stateSize+1) = i;
end

for i = 1:length(p2Actions)
    qhist(find(qhist(:,stateSize+2) == p2Actions(i)), stateSize+2) = i;
end

if length(p1Actions) == 2 & length(p2Actions) == 2
    % state act act qprev qnew qdiff act11 act21 act12 act22
    stateOffset = stateSize +5;
    qhist_new = zeros(size(qhist,1),stateSize + 9);
    qhist_new(:,1:stateOffset) = qhist(:,1:stateOffset);

    for i = 1:2
        otherAction = p1Actions(i);
        for j = 1:2
            myAction = p2Actions(j);
            qhist_new(:,stateOffset + (i - 1) * 2 + j) = ...
                        qhist(:,stateOffset + (otherAction - 1) * numActions + myAction);
        end
    end
else
    qhist_new = qhist;
end
