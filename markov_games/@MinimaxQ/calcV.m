%-----------------------------------------------------------------------
% File: calcV
%
% Description:
%   the V calculation
%
%-----------------------------------------------------------------------
function [player, V] = calcV(player, newState);

qStateRef = newState;           
qStateRef{player.sLen + 1} = ':';
qStateRef{player.sLen + 2} = ':';
pStateRef = newState;
pStateRef{player.sLen + 1} = ':';
% use linear programming to find optimal policy
% remove null-move rows and columns
initQ = squeeze(player.initQvalues(qStateRef{:}));
nzRows = find(sum(initQ'));
numRows = length(nzRows);
nzCols = find(sum(initQ));
numCols = length(nzCols);
qTable = squeeze(player.Qvalues(qStateRef{:}));
nzQvalues = qTable(nzRows, nzCols);

% zero out very small values
zId = find(abs(nzQvalues) < 1e-8);
nzQvalues(zId) = 0;

prevPol = squeeze(player.Policy(pStateRef{:}));
if size(prevPol,1) == 1
    prevPol = prevPol';
end
prevV = min(nzQvalues * prevPol(nzCols));


% => maximize V subject to Qx >= V
f =[zeros(numCols, 1); 1];
A =[nzQvalues];

% rescaling A
maxA = max(max(A));
minA = min(min(A));
diffA = maxA - minA;
if (diffA > 0)
    A = A ./ diffA;
end

A = round(A * 1e4) / 1e4;

A = [A ones(1,numRows)' .* -1]; 
b = zeros(numRows, 1);
e = ones(numRows, 1);


% equality constraints
A = [A; [ones(1, numCols) 0]];
b = [b; 1];
e = [e; 0];
lb = [zeros(1, numCols), -1e6];
ub = [ones(1, numCols), 1e6];
colInt = zeros(1,numCols + 1);

ge = [1:numRows]';
%[negV, policy, lambda, status, colstat, it] = ...
%                            lp_cplex(- f, A, b, lb, ub, [], ge, 10000);
%V = - negV;
[V, policy, duals] = lp_solve(f, A, b, e, lb, ub, colInt);
if exist('policy') > 0

%if status == 1
    if (diffA > 0)
        V = V * diffA;
    end
    newPol = zeros(1, player.numActions);
    newPol(nzCols) = policy(1:numCols);
    player.Policy(pStateRef{:}) = newPol;
    altV = min(nzQvalues * newPol(nzCols)');
    if (abs(altV - V) > .001)
        disp(['WARNING: different V''s V=', num2str(V), ' altV=', ...
              num2str(altV)]);
    end
else
    disp(['WARNING: unable to solve LP, using old policy']);
    V = prevV;
end
