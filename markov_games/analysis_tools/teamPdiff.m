function teamPdiff(teams1, teams2, stateDims, cmpdiff)

if nargin < 4
    cmpdiff = 1e-6;
end
if isa(teams1{1}, 'CorrEQ')
    if isa(teams2{1}, 'MinimaxQ') == 0
        error(['must pass a CE player and a MM player']);
    end
    disp(['First arg is CorrEQ']);
    ceP = get(teams1{1}, 'Policy');
    mmP1 = get(teams2{1}, 'Policy');
    mmP2 = get(teams2{2}, 'Policy');
elseif isa(teams2{1}, 'CorrEQ')
    if isa(teams1{1}, 'MinimaxQ') == 0
        error(['must pass a CE player and a MM player']);
    end
    disp(['First arg is MinimaxQ']);
    ceP = get(teams2{1}, 'Policy');
    mmP1 = get(teams1{1}, 'Policy');
    mmP2 = get(teams1{2}, 'Policy');
else
    error(['must pass a CE player and a MM player']);
end


numStates = prod(stateDims);
stateLen = length(stateDims);
state = num2cell(zeros(1, stateLen + 2));

for curState = 1:numStates
    [state{:}] = ind2sub(stateDims, curState); % matlab syntax for variable 
    state{stateLen + 1} = ':';
    state{stateLen + 2} = ':';
    cePol = squeeze(ceP(state{:}));
    mm1Pol = squeeze(mmP1(state{:}));
    mm2Pol = squeeze(mmP2(state{:}));
    mmPol = mm2Pol * mm1Pol';

    diff = abs(cePol - mmPol);
    if any(any(diff > cmpdiff))
        warning 'diff exists';
        cat(1,state{1:stateLen})'
        [mvec,row] = max(diff);
        [maxdiff, col] = max(mvec);
        disp(['max diff: abs(', num2str(cePol(row(col), col)), ' - ', ...
              num2str(mmPol(row(col), col)), ') = ', num2str(maxdiff)]);
        cePol
        mmPol
        %diff
    end
end
