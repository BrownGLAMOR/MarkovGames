%-----------------------------------------------------------------------
% File: valiter
%
% Description:
%   run a value-iteration type simulation
%   (!!! NOT SURE IF THIS WORKS WITH the SFBP game !!!)
%
%-----------------------------------------------------------------------
function simul = valiter(simul)

global InternalDebug;

disp(['Value-iteration (-style) simulation']);
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
dummyTeams = simul.teams;
oppTeam = [2 1];
begStr = ['['];
endStr = ['['];
for ttNum = 1:simul.numTeams
    begStr = [begStr,'actions(',num2str(ttNum),')'];
    endStr = [endStr, num2str(numActions)];
    if (ttNum ~= simul.numTeams)
        begStr = [begStr,','];
        endStr = [endStr,','];
    end
end
actionStr = [begStr, '] = ind2sub(', endStr, '], ']; 
for iteration = 1:simul.numIter
    
    % save the teams before update occurs
    savedTeams = simul.teams;

    % for each action pair at this state
    %-----------
    % ValueIteration
    %   (1) - simulate all action profiles at this state
    %-----------
    numActionProfiles = (numActions^simul.numTeams);
    for aProfileIx = 1:numActionProfiles
        % start with the current game state for each action profile simulation
        tmpGame = simul.game;

        %-----------
        % ValueIteration
        %   (1 cont) - grab action profile
        %-----------
        eval([actionStr, num2str(aProfileIx), ');']);
        badAction = 0;
        for ttNum = 1:simul.numTeams;
            if (checkAction(tmpGame, get(tmpGame,'State'), ttNum, actions(ttNum)) == 0)
                badAction = 1;
                break;
            end
        end
        if (badAction > 0)
            continue;
        end


        %-----------
        % ValueIteration
        %   (2) - Simulation Action observe Rewards
        %-----------

        % simululate actions and observe rewards
        rewards = zeros(1,simul.numTeams);
        teamVec = randperm(simul.numTeams);

        for tNum = teamVec
            [tmpGame, rewards(tNum)] = move(tmpGame, tNum, actions(tNum));
            if get(tmpGame, 'QuitNow') == 1
                break;
            end
        end
        % check for endgame information, simulultaneous actions rewards, etc.
        [tmpGame, isGameOver, addReward] = checkStatus(tmpGame);  % possible reset
        rewards = rewards + addReward;

        % get the new state
        newState = get(tmpGame, 'State');

        %-----------
        % ValueIteration
        %   (3) - Update Q-values
        %       - calculates V at newState and policy at newState
        %-----------
        % update q-values/whatever for each player
        otherPolicy = [];
        %for tNum = 1:simul.numTeams
        qErr = zeros(1,2);
        for tNum = 1:simul.numTeams
            if isa(tmpGame, 'SFBP') == 1
                curState = {curStates(tNum)};
                newState = {get(tmpGame, 'State', tNum)};
            end
            % History logging
            [history, qPrev] = setHistPrev(simul, history, stateLen, curState, ...
                                           newState, actions, iteration, tNum);

            opp = oppTeam(tNum);
            % Update Q-values
            if (isNashQ | isCorrEQ)
                [dummyTeams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
                                 curState, newState, actions, isGameOver, ...
                                 get(savedTeams{opp}, 'QTable'), otherPolicy);
                simul.teams{tNum} = setQ(simul.teams{tNum}, curState, actions, qNew);

                % error calculations for chicken
                % this method is incorrect for value iteration
                %if isa(tmpGame, 'Chicken')
                %    [dummy, newV] = calcV(simul.teams{tNum}, curState, ...
                %                        get(simul.teams{opp}, 'QTable'), otherPolicy);
                %    qErr(tNum) = qValueError(tmpGame, simul.teams{tNum}, curState, newV);
                %end

                % keep track of policy since we only use one
                otherPolicy = get(savedTeams{tNum}, 'Policy');
            elseif knowsOtherPol == 1
                [simul.teams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
                                 curState, newState, actions, isGameOver, ...
                                 get(savedTeams{opp}, 'StratTable')); 
            elseif isInformed == 1
                [simul.teams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
                                 curState, newState, actions, isGameOver, ...
                                 get(savedTeams{opp}, 'StratTable'), oldgame); 
                if tNum == simul.numTeams	% after last player, keep track of this 
                                % simul.game for next loop (so as to keep
                                % this update code under the informed condition)
                    oldgame = simul.game;
                end
            else
                [simul.teams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
                            curState, newState, actions, isGameOver);
                simul.teams{tNum} = setQ(simul.teams{tNum}, curState, actions, qNew);
                %if isa(tmpGame, 'Chicken')
                %    [dummy, newV] = calcV(savedTeams{tNum}, curState);
                %    qErr(tNum) = qValueError(tmpGame, savedTeams{tNum}, curState, newV);
                %end
            end
            %if isa(tmpGame, 'Chicken')
            %    fprintf(qErrFID, '%15.10e ', qErr);
            %    fprintf(qErrFID, '\n');
            %end

            % Calc additional history information
            [history] = setHistNew(simul, stateLen, numActions, curState, actions, ...
                                   tNum, history, qPrev);

            % Output history informatio
            if simul.numTeams > 2
                fprintf(histFID, '%15.5e ', history);
                fprintf(histFID, '\n');
            else
                fprintf(histFID(tNum), '%15.5e ', history(tNum,:));
                fprintf(histFID(tNum), '\n');
            end
        end
    end

    %-----------
    % ValueIteration
    %   (4) - Recalc policy at this state
    %-----------
    otherPolicy = [];
    for tNum = 1:simul.numTeams
        if isa(simul.game, 'SFBP') == 1
            curState = {curStates(tNum)};
        end
        opp = oppTeam(tNum);
        % Update Q-values
        if (isNashQ | isCorrEQ)
            simul.teams{tNum} = calcV(simul.teams{tNum}, curState, ...
                                       get(simul.teams{opp}, 'QTable'), otherPolicy);
            % keep track of policy since we only use one
            otherPolicy = get(savedTeams{tNum}, 'Policy');
        elseif knowsOtherPol == 1
            %[simul.teams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
            %                 curState, newState, actions, isGameOver, ...
            %                 get(savedTeams{opp}, 'StratTable')); 
        elseif isInformed == 1
            %[simul.teams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
            %                 curState, newState, actions, isGameOver, ...
            %                 get(savedTeams{opp}, 'StratTable'), oldgame); 
            %if tNum == simul.numTeams	% after last player, keep track of this 
                            % simul.game for next loop (so as to keep
                            % this update code under the informed condition)
            %    oldgame = simul.game;
            %end
        else
            simul.teams{tNum} = calcV(simul.teams{tNum}, curState);
        end
    end


    %-----------
    % ValueIteration
    %   (5) - Choose action and move to next state
    %-----------
    if randomExplore == 1
        if InternalDebug == 1
            disp(['   - All players Exploring...']);
        end
        if simul.numTeams == 2
            [actions(1), actions(2)] = ...
                            randAction(1, simul.game, curState, numActions);
        else
            for i = 1:simul.numTeams
                actions(i) = randAction(i, simul.game, curState, numActions);
            end    
        end
    else
        if isCorrEQ == 1
            if explore > rand
                if InternalDebug == 1
                    disp(['   - Player 1 & 2 Exploring...']);
                end
                [actions(1), actions(2)] = ...
                            randAction(1, simul.game, curState, numActions);
            else
                disp(['- Warning: CorrEQ:chooseAction currently does not work for independent agents']);
                [actions(1), actions(2)] = ...
                    chooseAction(simul.teams{1}, curState, simul.runMode);
            end
        else
            for tNum = 1:simul.numTeams
                if explore > rand
                    if InternalDebug == 1
                        disp(['   - Player ', int2str(tNum), ...
                             ' Exploring...']);
                    end
                    actions(tNum) = ...
                            randAction(tNum, simul.game, curState, numActions);
                else
                    if isa(simul.game, 'SFBP') == 1
                        actions(tNum) = ...
                            chooseAction(simul.teams{tNum}, {curStates(tNum)}, simul.runMode);
                    else
                        actions(tNum) = ...
                            chooseAction(simul.teams{tNum}, curState, simul.runMode);
                    end
                end
            end
        end
        [simul.paramSet, explore] = newExplore(simul.paramSet);
    end
    %-----------
    % Simulation 
    %   (2) - Simulation Action observe Rewards
    %-----------
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
    % DEBUG ONLY
    if mod(iteration, simul.DisplayIter) == 0
        disp(['Iteration ', int2str(iteration), ': ', ...
              get(simul.game, 'StatusString')]);
        if InternalDebug == 1
            disp([' next actions: ', ...
                  int2str(actions(1)), ' , ', int2str(actions(2))]);
        end
    end

    newState = get(simul.game, 'State');
    % newstate
    if isa(tmpGame, 'SFBP') == 0
        curState = newState;
    end
end

% File cleanup
switch simul.runMode
    case 'test'
        fclose(histFID);
        disp(['tesmode: ']);
    case 'train'
        fclose('all');
end
