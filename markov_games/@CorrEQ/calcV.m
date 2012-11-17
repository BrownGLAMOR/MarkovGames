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
pStateRef{player.sLen + 2} = ':';


initQtable = squeeze(player.initQvalues(qStateRef{:}));
origQt = squeeze(player.Qvalues(qStateRef{:}));


perturbEps = get(get(player, 'ParamSet'), 'PerturbEps');
if isempty(otherPolicy) | player.updateAllPolicies == 1 | perturbEps > 0
    origOppQt = squeeze(oppQvalues(qStateRef{:}));
    nzRows = find(sum(initQtable'));
    numRows = length(nzRows);
    nzCols = find(sum(initQtable));
    numCols = length(nzCols);
    qt = origQt(nzRows, nzCols);
    oppQt = origOppQt(nzCols, nzRows);

    if perturbEps > rand
        newPol = rand(size(qt));
        newPol = newPol ./ sum(sum(newPol));    % normalize
        newPolicy = zeros(player.numActions, player.numActions);
        newPolicy(nzRows,nzCols) = newPol;
        player.Policy(pStateRef{:}) = newPolicy;
        V = sum(sum(origQt .* newPolicy));
        return;
    end

    numPolicy = numRows * numCols;
    f = zeros(numPolicy, 1);

    numConst = numCols * (numCols - 1) + numRows * (numRows - 1);
    curConst = 0;
    egalCompConst = 0;
    switch player.ceType
    case 'lax'
        % leave the zeros as they are
        A = zeros(numConst, numPolicy);
        e = ones(numConst, 1);
    case 'utilitarian'
        % maximize sum
        A = zeros(numConst, numPolicy);
        e = ones(numConst, 1);
        curF = 0;
        for act = 1:numCols
            for oppAct = 1:numRows
                curF = curF + 1;
                f(curF) = qt(oppAct, act) + oppQt(act, oppAct);
            end
        end
    case 'egalitarian'
        % maximize society min
        % max A s.t.
        % V_{p1} - A > 0
        % V_{p2} - A > 0
        numConst = numConst + 2;    % added constraints
        A = zeros(numConst, numPolicy + 1);
        e = ones(numConst, 1);
        f =[zeros(numPolicy, 1); 1];

        % max the min V over all players
        % player
        newConst = zeros(numRows, numCols);
        for act = 1:numCols
            for oppAct = 1:numRows
                newConst(oppAct, act) = qt(oppAct, act);
            end
        end
        curConst = curConst + 1;
        %e(curConst) = 1;   % default
        A(curConst, :) = [reshape(newConst, 1, numPolicy), -1];

        % oppenent
        newConst = zeros(numRows, numCols);
        for act = 1:numCols
            for oppAct = 1:numRows
                newConst(oppAct, act) = oppQt(act, oppAct);
            end
        end
        curConst = curConst + 1;
        %e(curConst) = 1;
        A(curConst, :) = [reshape(newConst, 1, numPolicy), -1];
    case 'republican'
        % code follows
        A = zeros(numConst, numPolicy);
        e = ones(numConst, 1);
        f1 = zeros(numPolicy, 1);
        f2 = zeros(numPolicy, 1);

        % player
        curF = 0;
        for act = 1:numCols
            for oppAct = 1:numRows
                curF = curF + 1;
                f1(curF) = qt(oppAct, act);
            end
        end

        % opponent 
        curF = 0;
        for act = 1:numCols
            for oppAct = 1:numRows
                curF = curF + 1;
                f2(curF) = oppQt(act, oppAct);
            end
        end

    case 'libertarian'
        % maximize own (selfish)
        A = zeros(numConst, numPolicy);
        e = ones(numConst, 1);
        curF = 0;
        for act = 1:numCols
            for oppAct = 1:numRows
                curF = curF + 1;
                f(curF) = qt(oppAct, act);
            end
        end
    otherwise
        error(['(update) Unknown CE player type: ', player.ceType]);
    end

    %subject to
    % agent 
    for act = 1:numCols
        for disobAct = 1:numCols
            if disobAct ~= act
                newConst = zeros(numRows, numCols);
                for oppAct = 1:numRows
                    newConst(oppAct, act) = ...
                                   qt(oppAct, act) - qt(oppAct, disobAct);
                end
                curConst = curConst + 1;
                % e(curConts) = 1;    % not necessary due to init of e
                A(curConst, 1:numPolicy) = reshape(newConst, 1, numPolicy);
            end
        end
    end

    % opponent 
    for oppAct = 1:numRows
        for disobAct = 1:numRows
            if disobAct ~= oppAct
                newConst = zeros(numRows, numCols);
                for act = 1:numCols
                    newConst(oppAct, act) = ...
                                oppQt(act, oppAct) - oppQt(act, disobAct);
                end
                curConst = curConst + 1;
                % e(curConts) = 1;    % not necessary due to init of e
                A(curConst, 1:numPolicy) = reshape(newConst, 1, numPolicy);
            end
        end
    end
    % zero out very small values
    %aId = find(abs(A) < 1e-8);
    %A(aId) = 0;

    % rescaling A
    %maxA = max(max(A));
    %minA = min(min(A));
    %diffA = maxA - minA;
    %if (diffA > 0)
    %    A = A ./ diffA;
    %end
    %A = round(A * 1e4) / 1e4;

    b = zeros(numConst, 1);     % all constraints compared to 0
    if strcmp(player.ceType, 'egalitarian')
        %A = [A; ones(1, numPolicy), 0];     % add probability constraint
        pc = [ones(1, numPolicy), 0];
        lb = [zeros(1,numPolicy), -1e10];   % extra constraint to max min (non prob)
        ub = [ones(1,numPolicy), 1e10];
        colInt = zeros(1, numPolicy + 1);
    else
        %A = [A; ones(1, numPolicy)];        % prob constraint
        pc = ones(1, numPolicy);
        lb = zeros(1,numPolicy);
        ub = ones(1,numPolicy);
        colInt = zeros(1, numPolicy);
    end
    b = [b; 1]; % prob constraint must equal 1.0
    e = [e; 0]; %greater than constraints except for prob which is an equality constraint

%        ge = [1:numConst]';
%        [jointV, policy, lambda, status, colstat, it] = ...
%                                   lp_cplex(- f, A, b, lb, ub, [], ge, 10000);

%        if status == 1

    % following are for lp_solve version


    %oldopt = optimset('linprog');
    %opt = optimset(oldopt, 'Display', 'off');
    %prevPol = squeeze(player.Policy(pStateRef{:}));
    warning off;
    switch player.ceType
    case 'republican'
        A = [A; pc];
        [V1, p1, d1] = lp_solve(f1, A, b, e, lb, ub, colInt);
        [V2, p2, d2] = lp_solve(f2, A, b, e, lb, ub, colInt);
        % Aeq * X = Beq
        %[p1, V1] = linprog(-f1, A, b, pc, 1, lb, ub, prevPol, opt);
        %[p2, V2] = linprog(-f2, A, b, pc, 1, lb, ub, prevPol, opt);
        if V1 > V2
            V = V1;
            policy = p1;
        else
            V = V2;
            policy = p2;
        end
    otherwise
        A = [A; pc];
        [V, policy, duals] = lp_solve(f, A, b, e, lb, ub, colInt);
        %[policy, V] = linprog(-f, A, b, pc, 1, lb, ub, prevPol, opt);
    end
    warning on;

    if any(policy) ~= 0
        newPol = reshape(policy(1:numPolicy), numRows, numCols);
        newPolicy = zeros(player.numActions, player.numActions);
        newPolicy(nzRows,nzCols) = newPol;

        player.Policy(pStateRef{:}) = newPolicy;
        V = sum(sum(qt .* newPol));
    else
        disp(['WARNING: unable to solve LP, using old policy']);
        %warning('unable to solve LP, using old policy');
        prevPol = squeeze(player.Policy(pStateRef{:}));
        V = sum(sum(qt .* prevPol(nzRows,nzCols)));
    end
else
    % use the other player's policy (transposed)
    newPolicy = squeeze(otherPolicy(pStateRef{:}))';
    player.Policy(pStateRef{:}) = newPolicy;
    V = sum(sum(origQt .* newPolicy));
end
