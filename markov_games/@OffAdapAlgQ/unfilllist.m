function w = unfilllist(player, strat, l)
% eliminate the entries from a list corresponding to illegal actions
%  then returns the smaller list


  v = get(strat, 'dist');		% get the distribution for the
                                        % states the strat knows about
  moves = get(strat, 'moves');
  moves = cat(1,moves{:});		% convert from cell

  w = l(moves);
