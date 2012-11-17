%-----------------------------------------------------------------------
% Funciton: 
%   function plotStates(Ag, AgInd, stateDims, plotCol, numPoints, yvals);
%
% Description:
%    Creates subplots for each of the Ag cells.
%    Plots the plotColumn column
% 
%    numPoints
%      > 0  -> 1:numPoints
%      < 0  -> (length + numPoints):end
%-----------------------------------------------------------------------
function plotStates(Ag,AgInd, stateDims, plotCol, numPoints, yvals)


% I've separated the functions as generating the cumulative frequency
% matrices is expensive and I'm forcing the user to choose subplotDim 
%  typical calling syntax is:
%   [f,t] = cumStateFreqs(qhist, [3 3 3 3], 4);
%   full = length(f) - sum(cellfun('isempty', f)) %% find out how many
%                                                 % nonempty state info we
%                                                 % have to pick some subplotDim
%
%   plotAllFreqs(f,t, [3 3 3 3], [8 7])           % assuming we have <56 
%                                                 % nonempty states


if nargin < 5
    numPoints = 2000;
end
disp(['Plotting (numPoints): ', num2str(numPoints)]);


c = 1;					% counter of nonempty graphs
state = cell(1,length(stateDims));	% for grabbing state ID for titles

numStates = 0;
for i = 1:length(Ag)
    if ~isempty(Ag{i})
        numStates = numStates + 1;
    end
end
if numStates < 20
    square = sqrt(numStates);
    subplotDim = [ceil(square), round(square)];
else
    subplotDim = [9, ceil(numStates / 9)];
end

for i = 1:length(Ag)
  if ~isempty(Ag{i})

    subplot(subplotDim(1), subplotDim(2), c); 

    % graph granularity (without this, plotting takes very, very long)
    if numPoints < 0
        startPoint = max(1,length(AgInd{i}) + numPoints);
        plot(AgInd{i}(startPoint:end), ...
             abs(Ag{i}(startPoint:end,plotCol)), '.-');
        if nargin > 5
            axis([-inf, inf, yvals(1), yvals(2)]);
        end
%        axis off;
    else
        endPoint = min(length(AgInd{i}), numPoints);
        plot(AgInd{i}(1:endPoint), abs(Ag{i}(1:endPoint,plotCol)), '.-');
	%legend('Stay', 'Move');
        if nargin > 5
            axis([-inf, inf, yvals(1), yvals(2)]);
        end
%        axis off;
    end
    
    [state{:}] = ind2sub(stateDims, i); % matlab syntax for variable 
    stateList = cat(1, state{:})';  
    title(num2str(stateList)) % use state ID

                                                        % for title
%    axis off;	% reduce clutter
    c = c + 1;
  end
end
