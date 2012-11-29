%-----------------------------------------------------------------------
% File: simululate
%
% Description:
%   run a simululation
%
%-----------------------------------------------------------------------
function [simul, totalGameVals] = simululate(simul)

global InternalDebug;

disp(['Q-learning simulation']);
% get team, player, and stat information
numActions = get(simul.game, 'NumActions');
stateDim = get(simul.game, 'GameStateDim');
if isa(simul.game, 'SFBP')
    curStates = zeros(1,simul.numTeams);
    for i = 1:simul.numTeams
        curStates(i) = get(simul.game, 'State', i);
    end
    curState = 1;
else
    curState = get(simul.game, 'State');
end
stateLen = length(curState);


% value information for the simul.game
gameVals = zeros(1,simul.numTeams);
totalGameVals = zeros(1,simul.numTeams);

% simul.game over flag set by each simul.game
isGameOver = 1;

if strcmp(get(simul.paramSet, 'ExploreType'), 'Fixed') == 1 & ...
   get(simul.paramSet, 'InitExplore') == 1
    disp(['Exploration is random']);
    randomExplore = 1;
else
    randomExplore = 0;
end

isCorrEQ = 0;
isNashQ = 0;
areMinimax = 0;
isGrid = 0;
isInformed = 0;
knowsOtherPol = 0;  
if isa(simul.teams{1}, 'CorrEQ') == 1
    isCorrEQ = 1;
elseif isa(simul.teams{1}, 'NashQ') == 1
    isNashQ = 1;
elseif isa(simul.teams{1}, 'MinimaxQ') == 1 & ...
       isa(simul.teams{2}, 'MinimaxQ') == 1 
    areMinimax = 1;
elseif isa(simul.teams{1}, 'NaiveHedgeQ') == 1 | ...
       isa(simul.teams{1}, 'NaiveAdapAlgQ') == 1 
    knowsOtherPol = 1;  
elseif isa(simul.teams{1}, 'Hedge') == 1 | ...
       isa(simul.teams{1}, 'AdapAlgQ') == 1 | ...
       isa(simul.teams{1}, 'OffAdapAlgQ') == 1 
    isInformed = 1;
    oldsimul.game = simul.game;			% informed strategies need to know the simul.game
                                        % before having moved to
                                        % calculate all payoffs
end

if (isNashQ | isCorrEQ) & isa(simul.game, 'Exist')
   simul.policyHist = 'long';
end
    
%Open History Files
[histFID, history, qErrFID] = openHistory(simul, stateLen, numActions);

[simul.paramSet, explore] = newExplore(simul.paramSet);
oppTeam = [2 1];
for iteration = 1:simul.numIter
    
    %-----------
    % Simulation 
    %   (1) - Choose Action
    %-----------
    if strcmp(simul.runMode, 'train') % train mode
    %if 1
        if randomExplore == 1
            if InternalDebug == 1
                disp(['   - All players Exploring...']);
            end
            if simul.numTeams == 2
                [actions(1), actions(2)] = randAction(1, simul.game, curState, numActions);
            else
                for i = 1:simul.numTeams
                    actions(i) = randAction(i, simul.game, curState, numActions);
                end    
            end
        else
            if isCorrEQ
                if explore > rand
                    if InternalDebug == 1
                        disp(['   - Player 1 & 2 Exploring...']);
                    end
                    [actions(1), actions(2)] = randAction(1, simul.game, curState, numActions);
                else
                    %disp(['- Warning: CorrEQ:chooseAction currently does not work for independent agents']);
                    if strcmp(get(simul.teams{1},'CEType'),'libertarian')  == 1
                        for tNum = 1:simul.numTeams
                            [retAct(1), retAct(2)] = chooseAction(simul.teams{tNum}, curState, simul.runMode);
                            actions(tNum) = retAct(tNum);
                        end
                    else
                        [actions(1), actions(2)] = chooseAction(simul.teams{1}, curState, simul.runMode);
                    end
                end
            else
                for tNum = 1:simul.numTeams
                    if explore > rand
                        if InternalDebug == 1
                            disp(['   - Player ', int2str(tNum), ...
                                 ' Exploring...']);
                        end
                        actions(tNum) = randAction(tNum, simul.game, curState, numActions);
                    else
                        if isa(simul.game, 'SFBP') == 1
                            actions(tNum) = chooseAction(simul.teams{tNum}, {curStates(tNum)}, simul.runMode);
                        else
                            actions(tNum) = chooseAction(simul.teams{tNum}, curState, simul.runMode);
                        end
                    end
                end
            end
            [simul.paramSet, explore] = newExplore(simul.paramSet);
        end
    else   % test mode
        if isCorrEQ
            if strcmp(get(simul.teams{1},'CEType'),'libertarian')  == 1
                for tNum = 1:simul.numTeams
                    [retAct(1), retAct(2)] = ...
                        chooseAction(simul.teams{tNum}, curState, simul.runMode);
                    actions(tNum) = retAct(tNum);
                end
            else
                [actions(1), actions(2)] = chooseAction(simul.teams{1}, curState, simul.runMode);
            end
        else
            for tNum = 1:simul.numTeams
                if isa(simul.game, 'SFBP') == 1
                    actions(tNum) = chooseAction(simul.teams{tNum}, {curStates(tNum)}, 'test');
                else
                    actions(tNum) = chooseAction(simul.teams{tNum}, curState, 'test');
                end
            end
        end
        for i = 1:stateLen
            history(i) = curState{i};
        end
        history(stateLen + 1) = actions(1);
        history(stateLen + 2) = actions(2);
        score = get(simul.game, 'Score');
        history(stateLen + 3) = score(1);
        history(stateLen + 4) = score(2);
        history(stateLen + 5) = gameVals(1);
        history(stateLen + 6) = gameVals(2);
        % @betsy and @sodomka hack
        if length(histFID) == 1
            fprintf(histFID, '%15.5e ', history);
            fprintf(histFID, '\n');
        else
            fprintf(histFID(1), '%15.5e ', history(1,:));
            fprintf(histFID(1), '\n');
            
            fprintf(histFID(2), '%15.5e ', history(2,:));
            fprintf(histFID(2), '\n');
        end
    end

    %-----------
    % Simulation 
    %   (2) - Simulation Action observe Rewards
    %-----------
    % if previus round was the end-of-simul.game, clear out the simul.game values
    if isGameOver == 1
        gameVals = zeros(1,simul.numTeams);
    end

    % simululate actions and observe rewards
    rewards = zeros(1,simul.numTeams);
    teamVec = randperm(simul.numTeams);

    for tNum = teamVec
        [simul.game, rewards(tNum)] = move(simul.game, tNum, actions(tNum));
        if get(simul.game, 'QuitNow') == 1
            break;
        end
    end
    % check for endgame information, simulultaneous actions rewards, etc.
    [simul.game, isGameOver, addReward] = checkStatus(simul.game);  % possible reset
    rewards = rewards + addReward;

    % acumulate values, rewards etc (debug and analysis)
    gameVals = gameVals + rewards;
    totalGameVals = totalGameVals + rewards;
    if isGameOver == 1
        if strcmp(simul.runMode,'test') & InternalDebug == 1
            disp(['Game vals: Player 1 (', num2str(gameVals(1)), ...
                  ') Player 2 (', num2str(gameVals(2)), ')']);
        end
    end

    % DEBUG ONLY
    if mod(iteration, simul.DisplayIter) == 0
        disp(['Iteration ', int2str(iteration), ': ', ...
              get(simul.game, 'StatusString')]);
        if InternalDebug == 1
            disp([' next actions: ', ...
                  int2str(actions(1)), ' , ', int2str(actions(2))]);
        end
    end
    % get the new state
    newState = get(simul.game, 'State');

    %-----------
    % Simulation 
    %   (3) - Update Q-values
    %       - calculates V at newState and policy at newState
    %-----------
    if strcmp(simul.runMode, 'train')
    %if 1
        % update q-values/whatever for each player
        otherPolicy = [];
        %for tNum = 1:simul.numTeams
        qErr = zeros(1,2);
        for tNum = 1:simul.numTeams
            if isa(simul.game, 'SFBP') == 1
                curState = {curStates(tNum)};
                newState = {get(simul.game, 'State', tNum)};
            end
            % History logging
            [history, qPrev] = setHistPrev(simul, history, stateLen, curState, newState, ...
                                           actions, iteration, tNum);
            opp = oppTeam(tNum);
            % Update Q-values
            if (isNashQ | isCorrEQ)
                [simul.teams{tNum}, qNew] = update(simul.teams{tNum}, rewards(tNum), ...
                                 curState, newState, actions, isGameOver, ...
                                 get(simul.teams{opp}, 'QTable'), otherPolicy);

                % error calculations for chicken
                if isa(simul.game, 'Chicken')
                    [dummy, newV] = calcV(simul.teams{tNum}, curState, ...
                                        get(simul.teams{opp}, 'QTable'), otherPolicy);
                    qErr(tNum) = qValueError(simul.game, simul.teams{tNum}, curState, newV);
                end

                % keep track of policy since we only use one
                otherPolicy = get(simul.teams{tNum}, 'Policy');
            elseif knowsOtherPol == 1
                [simul.teams{tNum}, qNew] = update(simul.teams{tNum}, rewards(tNum), ...
                                 curState, newState, actions, isGameOver, ...
                                 get(simul.teams{opp}, 'StratTable')); 
            elseif isInformed == 1
                [simul.teams{tNum}, qNew] = update(simul.teams{tNum}, rewards(tNum), ...
                                 curState, newState, actions, isGameOver, ...
                                 get(simul.teams{opp}, 'StratTable'), oldsimul.game); 
                if tNum == simul.numTeams	% after last player, keep track of this 
                                % simul.game for next loop (so as to keep
                                % this update code under the informed condition)
             		oldsimul.game = simul.game;
                end
            else
                [simul.teams{tNum}, qNew] = update(simul.teams{tNum}, rewards(tNum), ...
                            curState, newState, actions, isGameOver);
                if isa(simul.game, 'Chicken')
                    [dummy, newV] = calcV(simul.teams{tNum}, curState);
                    qErr(tNum) = qValueError(simul.game, simul.teams{tNum}, curState, newV);
                end
            end
            if isa(simul.game, 'Chicken')
                fprintf(qErrFID, '%15.10e ', qErr);
                fprintf(qErrFID, '\n');
            end

            % Calc additional history information
            [history] = setHistNew(simul, stateLen, numActions, curState, actions, ...
                                   tNum, history, qPrev);

            % Output history information
            if simul.numTeams > 2
                fprintf(histFID, '%15.5e ', history);
                fprintf(histFID, '\n');
            else
                fprintf(histFID(tNum), '%15.5e ', history(tNum,:));
                fprintf(histFID(tNum), '\n');
            end

            if isa(simul.game, 'SFBP') == 1
                curStates(tNum) = newState{1};
            end
        end
    end
    % newstate
    if isa(simul.game, 'SFBP') == 0
        curState = newState;
    end
end



% File cleanup
switch simul.runMode
    case {'test','train'}
        disp(['testmode']);
        if size(histFID,2) > 1
            fclose(histFID(1));
            fclose(histFID(2));
        else
            fclose(histFID);
        end
    %case 'train'
    %    fclose('all');
end

% output some final score stuff
score = get(simul.game, 'Score');
disp(['Total number of games completed: ', num2str(get(simul.game,'GamesPlayed'))]);
if simul.numTeams == 2
    disp(['Final score: Player 1 (', num2str(score(1)), ...
          ') Player 2 (', num2str(score(2)), ')']);
    disp(['Total game vals: Player 1 (', num2str(totalGameVals(1)), ...
          ')  Player 2 (', num2str(totalGameVals(2)), ')']);
end
