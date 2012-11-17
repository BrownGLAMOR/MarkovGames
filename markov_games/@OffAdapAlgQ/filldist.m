function w = filldist(player, strat)
% pad the list with 0s for illegal actions

  w = zeros(player.numActions, 1);

  v = get(strat, 'dist');		% get the distribution for the
                                        % states the strat knows about
  moves = get(strat, 'moves');
  moves = cat(1,moves{:});		% convert from cell

  w(moves) = v;
  