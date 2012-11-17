%-----------------------------------------------------------------------
% File: calcV
%
% Description:
%       encapsulate the V calculation for a state
%
%-----------------------------------------------------------------------
function [player, V] = calcV(player, newState, oppQvalues, otherPolicy);
qStateRef = newState;           
qStateRef{player.sLen + 1} = ':';
qStateRef{player.sLen + 2} = ':';

pStateRef = newState;
pStateRef{player.sLen + 1} = ':';


initQtable = squeeze(player.initQvalues(qStateRef{:}));
origQt = squeeze(player.Qvalues(qStateRef{:}));

if isempty(otherPolicy) | player.updateAllPolicies == 1
    origOppQt = squeeze(oppQvalues(qStateRef{:}));
    nzRows = find(sum(initQtable'));
    numRows = length(nzRows);
    nzCols = find(sum(initQtable));
    numCols = length(nzCols);
    qt = origQt(nzRows, nzCols);
    oppQt = origOppQt(nzCols, nzRows);

    numPolicy = numRows * numCols;
    f = zeros(numPolicy, 1);

    Z = nashcomp(qt',oppQt);
    
    % find best nash

    switch player.neType
    case {'first','coord'}
        p1pol = Z(1,1:numCols);
        p2pol = Z(1,numCols+1:end);
        V = p2pol * (qt * p1pol');
    case 'second'
        p1pol = Z(2,1:numCols);
        p2pol = Z(2,numCols+1:end);
        V = p2pol * (qt * p1pol');
    case 'best'
        maxV = -100000;
        bestp1pol = 0;
        bestp2pol = 0;
        for i = 1:numCols
            p1pol = Z(i,1:numCols);
            p2pol = Z(i,numCols+1:end);
            V = p2pol * (qt * p1pol');
            if V > maxV
                maxV = V;
                bestp1pol = p1pol;
                bestp2pol = p2pol;
            end
        end
        V = maxV;
        p1pol = bestp1pol;
        p2pol = bestp2pol;
    end
    % create a joint policy...
    newPolicy1 = zeros(1, player.numActions);
    newPolicy2 = zeros(1, player.numActions);
    newPolicy1(nzCols) = p1pol;
    newPolicy2(nzRows) = p2pol;
    player.Policy{1}(pStateRef{:}) = newPolicy1;
    player.Policy{2}(pStateRef{:}) = newPolicy2;

else
    % use the other player's policy (transposed)
    newPolicy1 = squeeze(otherPolicy{1}(pStateRef{:}));
    newPolicy2 = squeeze(otherPolicy{2}(pStateRef{:}));
    player.Policy{1}(pStateRef{:}) = newPolicy2;
    player.Policy{2}(pStateRef{:}) = newPolicy1;
    p1pol = newPolicy1;
    p2pol = newPolicy2;
    % if using policy from other player, we have the opposite
    % player numbers 
    if size(p1pol,1) == 1
        %(row vectors from squeeze command)
        V = p1pol * (origQt * p2pol');
    else
        V = p1pol'* (origQt * p2pol);
    end
end
