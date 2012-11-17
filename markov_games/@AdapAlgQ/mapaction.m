function mappedactions = mapaction(player, strat, actions)
% map Markov Game actions -> legal hedge actions
%   e.g.  for grid game, we have actions 1-4, but strat may only be
%   allowed to play 2 or 4
% NOTE only maps my action. does NOT map opponents action.  this would be 
% bad for fictitous play type strategies.  if needed, just pass in
% opponents strat and do the same mapping.

  i = actions(player.team);
  
  moves = get(strat, 'moves');

  mappedactions = actions;
  mappedactions(player.team) = find(cat(1,moves{:}) == i);

  a = 1;
