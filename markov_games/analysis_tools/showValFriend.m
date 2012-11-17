function showValFriend(team1, team2, stateDims)

if ~ isa(team1, 'Friend') | ~ isa(team2, 'Friend')
    error(['must pass two Friend players']);
end

qt1 = get(team1, 'QTable');
qt2 = get(team2, 'QTable');


numStates = prod(stateDims);
stateLen = length(stateDims);
state = num2cell(zeros(1, stateLen + 2));

for curState = 1:numStates
    [state{:}] = ind2sub(stateDims, curState); % matlab syntax for variable 
    state{stateLen + 1} = ':';
    state{stateLen + 2} = ':';
    qtable1 = squeeze(qt1(state{:}));
    qtable2 = squeeze(qt2(state{:}));
    if sum(sum(qtable1)) ~= 0
        val1 = max(max(qtable1));
        val2 = max(max(qtable2));
        disp(['state(', num2str(cat(1,state{1:stateLen})'), ')', ...
              '     P1 Value = ', num2str(val1, '%6.4f'), ...
              '     P2 Value = ', num2str(val2, '%6.4f')]);
%            qtable1
%            ptable1
    end
end
