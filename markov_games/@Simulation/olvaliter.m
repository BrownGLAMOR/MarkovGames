%-----------------------------------------------------------------------
% File: olvaliter
%
% Description: off-line value iteration
%   run a value-iteration simulation
%   in order to run "true" value iteration, the game must provide an
%   explicit description of the state-transition distributions.
%
%
%  DOUBLE-WARNING: hacked for grid games right now...
%
%-----------------------------------------------------------------------
function simul = olvaliter(simul)

global InternalDebug;

disp(['Value-iteration (off-line) simulation']);
% get team, player, and stat information
numActions = get(simul.game, 'NumActions');
stateDim = get(simul.game, 'GameStateDim');

if isa(simul.game, 'SFBP')
  disp(['  ERROR: SFBP NOT supported']);
else
  curState = get(simul.game, 'State');
end
stateLen = length(curState);

% value information for the simul.game
gameVals = zeros(1,simul.numTeams);
totalGameVals = zeros(1,simul.numTeams);

isGameOver = 1; % simul.game over flag set by each simul.game
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

dummyTeams = simul.teams;
oppTeam = [2 1];
begStr = ['['];
endStr = ['['];
for ttNum = 1:simul.numTeams
  % Make sure alpha is fixed
  if (get(get(simul.teams{ttNum},'ParamSet'), 'AlphaType') ~= 'Fixed')
    error(['ERROR: olvaliter requires a fixed alpha setting']);
  end
  
  begStr = [begStr,'actions(',num2str(ttNum),')'];
  endStr = [endStr, num2str(numActions)];
  if (ttNum ~= simul.numTeams)
    begStr = [begStr,','];
    endStr = [endStr,','];
  end
end
actionStr = [begStr, '] = ind2sub(', endStr, '], ']; 

numStates = prod(stateDim);
curStateIx = 0;
[curState{:}] = ind2sub(stateDim, curStateIx);
% save the teams before update occurs
savedTeams = simul.teams;
numValIter = 0;
numGoodStates = 0;
for iteration = 1:simul.numIter
  curStateIx = curStateIx + 1;
  if (curStateIx > numStates)
    savedTeams = simul.teams;
    curStateIx = 1;
    numValIter = numValIter + 1;
    disp(['*** Value Iteration round: ', num2str(numValIter), ' number of "good" states: ', num2str(numGoodStates)]);
    numGoodStates = 0;
  end
  [curState{:}] = ind2sub(stateDim, curStateIx);
  while (~ checkState(simul.game, curState))
    curStateIx = curStateIx + 1;
    if (curStateIx > numStates)
      % save the teams before update occurs
      break;
    end
    prevState = curState;
    [curState{:}] = ind2sub(stateDim, curStateIx);
    if InternalDebug == 1
      disp(['  At an invalid state (', num2str(cell2mat(prevState)), ') trying next state: ', num2str(curStateIx), ' (', num2str(cell2mat(curState)), ')']);
    end
  end
  if (curStateIx > numStates)
    continue;
  end
  numGoodStates = numGoodStates + 1;

  % set the game state
  simul.game = set(simul.game, 'State', curState);
  if InternalDebug == 1
    disp(['Processing state: ', num2str(curStateIx), ': ', num2str(cell2mat(curState))]);
  end


  % for each action pair at this state
  %-----------
  % ValueIteration
  %   (1) - simulate all action profiles at this state
  %-----------
  numActionProfiles = (numActions^simul.numTeams);
  for aProfileIx = 1:numActionProfiles
    % start with the current game state for each action profile simulation

    %-----------
    % ValueIteration
    %   (1 cont) - grab action profile
    %-----------
    eval([actionStr, num2str(aProfileIx), ');']);
    badAction = 0;
    for ttNum = 1:simul.numTeams
      if (checkAction(simul.game, get(simul.game,'State'), ttNum, actions(ttNum)) == 0)
        badAction = 1;
        break;
      end
    end
    if (badAction > 0)
      continue;
    end

    %-----------
    % ValueIteration
    %   (2) - Get information for action pair
    %-----------

    if InternalDebug == 1
      disp([' -- Trying action profile:', num2str(actions)]);
    end
    for ttNum = 1:simul.numTeams;
      playerInfo{ttNum} = nextStates(simul.game, ttNum, actions(ttNum));
      if InternalDebug == 1
        disp(['  Player ', num2str(ttNum), ' has ', num2str(size(playerInfo{ttNum},2)), ' next states']);
      end
    end

    % Loop through all possible next states
    % currently only handles two-player games
    pinfo = {};
    firstState = 1;
    for p1Moves = 1:size(playerInfo{1},2);
      pinfo{1} = playerInfo{1}{p1Moves};
      for p2Moves = 1:size(playerInfo{2},2)
        pinfo{2} = playerInfo{2}{p2Moves};
        [newState, isGameOver, pinfo] = getPairRewards(simul.game, curState, pinfo);
        moveProb = pinfo{1}{2} * pinfo{2}{2};
        rewards(1) = pinfo{1}{3};
        rewards(2) = pinfo{2}{3};
        if pinfo{1}{4} == 1
          if InternalDebug == 1
            disp(['    player 1 went through side barrier ']);
          end
        end
        if pinfo{2}{4} == 1
          if InternalDebug == 1
            disp(['    player 2 went through side barrier ']);
          end
        end
        if InternalDebug == 1
          disp(['  new state: ', num2str(cell2mat(newState)), ' w/ prob: ', num2str(moveProb), ' reward: ', num2str(rewards)]);
        end

        %-----------
        % ValueIteration
        %   (3) - Update Q-values
        %     - calculates V at newState and policy at newState
        %-----------
        % update q-values/whatever for each player
        otherPolicy = [];
        %for tNum = 1:simul.numTeams
        qErr = zeros(1,2);
        for tNum = 1:simul.numTeams
          % History logging
          [history, qPrev] = setHistPrev(simul, history, stateLen, curState, ...
                           newState, actions, iteration, tNum);

          opp = oppTeam(tNum);
          % Accumulate the expected q-value (only applys to probabilistic state transitions)
          if (firstState == 1)
            oldQ = 0;
          else
            oldQ = getQ(simul.teams{tNum}, curState, actions);
          end

          % Update Q-values
          if (isNashQ | isCorrEQ)
            [dummyTeams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
                     curState, newState, actions, isGameOver, ...
                     get(savedTeams{opp}, 'QTable'), otherPolicy);
            qNew = oldQ + qNew * moveProb;
            if InternalDebug == 1
              disp(['    new q-value: ', num2str(qNew), ' w/ prob: ', num2str(moveProb)]);
            end
            simul.teams{tNum} = setQ(simul.teams{tNum}, curState, actions, qNew);

            % keep track of policy since we only use one
            otherPolicy = get(savedTeams{tNum}, 'Policy');
          elseif knowsOtherPol == 1
            [dummyTeams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
                     curState, newState, actions, isGameOver, ...
                     get(savedTeams{opp}, 'StratTable')); 
          elseif isInformed == 1
            [dummyTeams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
                     curState, newState, actions, isGameOver, ...
                     get(savedTeams{opp}, 'StratTable'), oldgame); 
            if tNum == simul.numTeams	% after last player, keep track of this 
                    % simul.game for next loop (so as to keep
                    % this update code under the informed condition)
              oldgame = simul.game;
            end
          else
            [dummyTeams{tNum}, qNew] = update(savedTeams{tNum}, rewards(tNum), ...
                  curState, newState, actions, isGameOver);
            if InternalDebug == 1
              disp(['    new q-value: ', num2str(qNew), ' w/ prob: ', num2str(moveProb)]);
            end
            qNew = oldQ + qNew * moveProb;
            simul.teams{tNum} = setQ(simul.teams{tNum}, curState, actions, qNew);
          end
          % Calc additional history information
          [history] = setHistNew(simul, stateLen, numActions, curState, actions, tNum, history, qPrev);

          % Output history information
          if simul.numTeams > 2
            fprintf(histFID, '%15.5e ', history);
            fprintf(histFID, '\n');
          else
            fprintf(histFID(tNum), '%15.5e ', history(tNum,:));
            fprintf(histFID(tNum), '\n');
          end
        end
        firstState = 0;
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
      otherPolicy = get(simul.teams{tNum}, 'Policy');
    elseif knowsOtherPol == 1
      %[simul.teams{tNum}, qNew] = update(simul.teams{tNum}, rewards(tNum), ...
      %         curState, newState, actions, isGameOver, ...
      %         get(simul.teams{opp}, 'StratTable')); 
    elseif isInformed == 1
      %[simul.teams{tNum}, qNew] = update(simul.teams{tNum}, rewards(tNum), ...
      %         curState, newState, actions, isGameOver, ...
      %         get(simul.teams{opp}, 'StratTable'), oldgame); 
      %if tNum == simul.numTeams	% after last player, keep track of this 
              % simul.game for next loop (so as to keep
              % this update code under the informed condition)
      %  oldgame = simul.game;
      %end
    else
      simul.teams{tNum} = calcV(simul.teams{tNum}, curState);
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

end

% File cleanup
switch simul.runMode
  case 'test'
    fclose(histFID);
    disp(['tesmode: ']);
  case 'train'
    fclose('all');
end
