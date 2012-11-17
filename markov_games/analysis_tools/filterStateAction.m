%-----------------------------------------------------------------------
% function [Ag, AgInd, Ac, AcInd] = filterStateAction(histMatrix, stateDims)
%
% Description:
%   Splits histMatrix into submatricies for each state.
%
% Returns:
% Ag{s} a the submatrix for state s
% AgInd{s} is the iteration at which action A{s} was played
%
%-----------------------------------------------------------------------
function [Ag, AgInd, Ac, AcInd] = filterStateAction(histMatrix, stateDims)

numStates = prod(stateDims);

% allocate the output cell arrays.  we don't know in advance the size of
% each A{s} (depends on how often it was reached!) so we can't preallocate
% it.
Ag = cell(1,numStates);
AgInd = cell(1,numStates);

c = ones(1,numStates);			% counter for how current entry
nD = length(stateDims);			% how many indices define a state

if nargout > 2
    if nargout < 4
        error(['AgInd get the Ac you need 4 output args']);
    end
    oppActionInd = nD + 1;
    actionInd = nD + 2;
    numActions = max(histMatrix(:,actionInd));
    Ac = cell(numStates,numActions, numActions);
    AcInd = cell(numStates,numActions, numActions);
end

%init matrices
[histLen, numCols] = size(histMatrix);
state = num2cell(zeros(1, nD));

for i = 1:numStates
  [state{:}] = ind2sub(stateDims, i); % matlab syntax for variable 
                                             % argout
  stateList = cat(1, state{:})';  
  
  matchStateMat = repmat(stateList, histLen, 1);

  matches = histMatrix(:,1:nD) == matchStateMat;
  if nD > 1
    rowMatched = all(matches');
  else
    rowMatched = matches;
  end
  rows = find(rowMatched);
    

  numMatches = sum(rowMatched);
  
  Ag{i} = histMatrix(rows, :);
  AgInd{i} = rows;
  agentLen = size(Ag{i},1);
  if nargout > 2
      for j = 1:numActions
          for k = 1:numActions
              matchActMat = repmat([j,k], agentLen, 1);
              matches = Ag{i}(:, [oppActionInd,actionInd]) == matchActMat;
              rowMatched = all(matches');
              rows = find(rowMatched);
              Ac{i,j, k} = Ag{i}(rows, :);
              AcInd{i,j, k} = AgInd{i}(rows);
          end
      end
  end
end
