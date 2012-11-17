%-----------------------------------------------------------------------
% File: qValueError
%
% Description:
%   Using the current Q-values, compute the error in the current estimates.
%
%-----------------------------------------------------------------------
function qErr = qValueError(game, team, curState, newV)

% for now, we assume all state action pairs lead to the next state

teamNum = get(team, 'Team');
sLen = 1; %chicken

qStateRef = curState;
qStateRef{sLen + 1} = ':';
qStateRef{sLen + 2} = ':';
qValues = get(team, 'QTable');
curQt = squeeze(qValues(qStateRef{:}));
if teamNum == 1
    % convert from team2 X team1 to  team1 X team2
    curQt = curQt';
end

% calculate the the new q-values for all state-action pairs using V
gamma = get(team, 'Gamma');
normGamma = get(team, 'NormGamma');
switch normGamma
    case 'NoGammaNorm'
        newQt = game.rewardVal{teamNum} + (gamma * newV);
    case 'GammaNorm'
        newQt = ((1-gamma) * game.rewardVal{teamNum}) + (gamma * newV);
    otherwise
        error(['Unknown gamma norm']);
end

qError = abs(newQt - curQt);
qErr = sum(sum(qError));

%disp(['Player(', num2str(teamNum), ') Error: ', num2str(sum(sum(qError)))]);
