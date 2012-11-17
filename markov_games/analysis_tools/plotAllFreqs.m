function plotAllFreqs(F,T, stateDims, subplotDim)
% I've separated the functions as generating the cumulative frequency
% matrices is expensive and I'm forcing the user to choose subplotDim 
%  typical calling syntax is:
%   [f,t] = cumStateFreqs(qhist, [3 3 3 3], 4);
%   full = length(f) - sum(cellfun('isempty', f))  %% find out how many
%                                                  % nonempty state info we
%                                                  % have to pick some subplotDim
%
%   plotAllFreqs(f,t, [3 3 3 3], [8 7])            % assuming we have <56 
%                                                  % nonempty states




MAXPOINTS = 2000;	% max number of points to plot per line

c = 1;					% counter of nonempty graphs
state = cell(1,length(stateDims));	% for grabbing state ID for titles

for i = 1:length(F)
  if ~isempty(F{i})
    
    % graph granularity (without this, plotting takes very, very long)
    itinc = max(1, floor(length(T{i})/MAXPOINTS));

    subplot(subplotDim(1), subplotDim(2), c); 
    plot(T{i}(1:itinc:end), F{i}(1:itinc:end,:)); 
    
    [state{:}] = ind2sub(stateDims, i); % matlab syntax for variable 
    stateList = cat(1, state{:})';  

    title(num2str(stateList)) % use state ID
                                                        % for title
    axis off;	% reduce clutter
    c = c + 1;
  end
end
