function [F, T] = cumStateFreqs(qhist, stateDims, numActions)
% [F, T] = cumStateFreqs(qhist, stateDims, numActions)
%   for now, we assume numActions max number of actions over all states

[A,T] = filterStateAction(qhist, stateDims);
actionCol = length(stateDims) + 2;                % index of my action in the row

F = cell(1, length(A));

for i = 1:length(A)
  F{i} = accumfreq(A{i}(:, actionCol), numActions);
end

