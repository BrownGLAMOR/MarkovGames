%-----------------------------------------------------------------------
% File: calcV
%
% Description:
%
%-----------------------------------------------------------------------
function [player, V] = calcV(player, newState);

global DeterministicMode;
global NonDeterministicMode;
global NoBiasDeterministicMode;
global PolicyTieTolerance;

qStateRef = newState;
qStateRef{player.sLen + 1} = ':';
validMoves = find(squeeze(player.initQvalues(qStateRef{:})));
qTable = squeeze(player.Qvalues(qStateRef{:}));
qTable = qTable(validMoves);
if player.ndMode == DeterministicMode
    pol = zeros(1,length(qTable));
    [V act] = max(qTable);
    pol(act) = 1;
else
    % make everything positive (just like happy pills)
    minQ = min(qTable);
    if minQ < 0
        qTable = qTable - minQ;
    end
    if sum(qTable) < 1e-6
        pol = zeros(1,length(qTable));
        [V act] = max(qTable);
        pol(act) = 1;
    else
        pol = zeros(1,length(qTable));
        pol(:) = qTable / sum(qTable); % turn translated q-values into probs
    end
    if player.ndMode == NoBiasDeterministicMode 
        maxPol = max(pol);  
        noTie = find(pol + PolicyTieTolerance < maxPol);
        pol(noTie) = 0;  % zero out policies that are not tied with max
        % find nonZero entries, choose uniformly from equal policies
        pol = pol / sum(pol);
        % else full non-deterministic q-learning
    end
    % note, non-determinisitc Q-learning is approximately "SARSA" 
    % (sarsa would sample, here we are taking expectation w.r.t. the action set)
    if size(qTable,1) == 1
        V = pol' * qTable;
    else
        V = pol * qTable;
    end
end
policy = zeros(player.numActions,1);
policy(validMoves) = pol;
player.Policy(qStateRef{:}) = policy;
