%-----------------------------------------------------------------------
% Class: NaiveHedgeQ (Constructor)
%
%-----------------------------------------------------------------------

function me = NaiveHedgeQ(teamNum, game, paramSet)
  me.nu = .05;
  
  baseStratQ = NaiveAdapAlgQ(teamNum, game, 'NaiveHedge', paramSet, me.nu);
  
  me.name = 'NaiveHedgeQ';

  
  me = class(me, 'NaiveHedgeQ', baseStratQ);

