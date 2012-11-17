function w = filldist(player, strat, unadjust)
% pad the list with 0s for illegal actions

if nargin == 2
  unadjust = 0;
end

  w = zeros(player.numActions, 1);

  if unadjust == 1
    v = get(strat, 'unadjust');
  else
    v = get(strat, 'dist');		% get the distribution for the
                                        % states the strat knows about
  end
  
  
  moves = get(strat, 'moves');
  
  moves = cat(1,moves{:});		% convert from cell

  w(moves) = v;

%  for i = 1:length(moves)
%    w(moves{i}) = v(i);
%  end
%					 