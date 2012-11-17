%-----------------------------------------------------------------------
% Class: NaiveHedgeQ (Constructor)
%
%-----------------------------------------------------------------------

function me = NaiveHartMCQ(teamNum, game, paramSet)
  
  baseStratQ = NaiveAdapAlgQ(teamNum, game, 'NaiveHartMC', paramSet);
  
  me.name = 'NaiveHartMCQ';

  
  me = class(me, 'NaiveHartMCQ', baseStratQ);

