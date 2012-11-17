function [p1, p2, q1,q2] = getSoccerData(teamSets, state, stateGroup)

if nargin > 2
    switch stateGroup
    case 'block'
    case 'side'
    case 'angle'
    end
end

numSets = length(teamSets);

for i = 1:numSets
    switch class(teamSets{i}{1})
    case 'MinimaxQ'
        pol1 = get(teamSets{i}{1}, 'Policy');
        pol2 = get(teamSets{i}{2}, 'Policy');
        qt1 = get(teamSets{i}{1}, 'QTable');
        qt2 = get(teamSets{i}{2}, 'QTable');
        p1 = squeeze(pol1(state{:}))';
        p2 = squeeze(pol2(state{:}))';
        disp(['p1 = ', num2str(p1)]);
        disp(['p2 = ', num2str(p2)]);
        disp(['---- Joint policy']);
        disp(p2' * p1);
        disp(['---- Q table player 1']);
        disp(squeeze(qt1(state{:})));
        disp(['---- Q table player 2']);
        disp(squeeze(qt2(state{:}))');
    case 'CorrEQ'
        pol = get(teamSets{i}{1}, 'Policy');
        qt1 = get(teamSets{i}{1}, 'QTable');
        qt2 = get(teamSets{i}{2}, 'QTable');
        disp(['---- Joint Policy ']);
        disp(squeeze(pol(state{:})));
        disp(['---- Q table player 1']);
        disp(squeeze(qt1(state{:})));
        disp(['---- Q table player 2']);
        disp(squeeze(qt2(state{:}))');
    case 'Friend'
    case 'QLearner'
    otherwise
        error(['Unknown type: ', class(teams{i})]);
    end
end


