%-----------------------------------------------------------------------
% function: [AgentMat, ActionMat, Freqs, Attend] = 
%                       filterBar(histMatrix, numPlayers, playerInd)
%
%
% Description:
%
% Returns:
%
%-----------------------------------------------------------------------
function [AgentMat, ActionMat, Freqs, Attend] = filterBar(histMatrix, ...
                                                    numPlayers, playerInd)

[histLen, numCols] = size(histMatrix);
numIter = histLen / numPlayers;
actionInd = playerInd + 2;
AgentMat = cell(1,numPlayers);
ActionMat = cell(numPlayers,2);
Freqs = cell(1,numPlayers);
numActions = max(histMatrix(:,actionInd));

for i = 1:numPlayers
  %[state{:}] = ind2sub(stateDims, i); % matlab syntax for variable 
  %                                           % argout
  %stateList = cat(1, state{:})';  
  
  %matchMat = repmat(stateList, length(histMatrix), 1);
  matchMat = repmat([i], histLen, 1);

  matches = histMatrix(:,playerInd) == matchMat;
  %rowMatched = all(matches');
  %rows = find(rowMatched);
  rows = find(matches);

  %numMatches = sum(rowMatched);
  
  AgentMat{i} = histMatrix(rows, :);
  for j = 1:numActions
      ActionMat{i,j} = zeros(numIter, numCols);
      matchId = find(AgentMat{i}(:,actionInd) == j);
      ActionMat{i,j} = AgentMat{i}(matchId, :);
  end
  Freqs{i} = accumfreq(AgentMat{i}(:, actionInd)', numActions);
end

Attend = zeros(numIter, numActions);
actInd = repmat(1:numActions, numPlayers, 1);
for i = 1:numIter
    for act = 1:numActions
        Attend(i, act) = ...
          sum(histMatrix((i-1)*numPlayers+1:i*numPlayers,actionInd) == ...
                                                                actInd(:,act));
    end
end
    
