function teamQdiff(teams1, teams2, stateDims, cmpdiff)

if nargin < 4
    cmpdiff = 1e-6;
end
t1p1qt = get(teams1{1}, 'QTable');
t1p2qt = get(teams1{2}, 'QTable');

t2p1qt = get(teams2{1}, 'QTable');
t2p2qt = get(teams2{2}, 'QTable');


numStates = prod(stateDims);
stateLen = length(stateDims);
state = num2cell(zeros(1, stateLen + 2));

for player = 1:2
for curState = 1:numStates
    [state{:}] = ind2sub(stateDims, curState); % matlab syntax for variable 
    state{stateLen + 1} = ':';
    state{stateLen + 2} = ':';
    if player == 1
        t1qt = squeeze(t1p1qt(state{:}));
        t2qt = squeeze(t2p1qt(state{:}));
    else
        t1qt = squeeze(t1p2qt(state{:}));
        t2qt = squeeze(t2p2qt(state{:}));
    end

    diff = abs(t1qt - t2qt);
    if any(any(diff > cmpdiff))
        %warning 'diff exists';
        %cat(1,state{1:stateLen})'
        [mvec,row] = max(diff);
        [maxdiff, col] = max(mvec);
        disp(['state(', num2str(cat(1,state{1:stateLen})'), ')' ...
             'max diff: abs(', num2str(t1qt(row(col), col)), ' - ', ...
              num2str(t2qt(row(col), col)), ') = ', num2str(maxdiff)]);
        %diff
    end
end
end
