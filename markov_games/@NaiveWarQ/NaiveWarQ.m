%-----------------------------------------------------------------------

function me = NaiveWarQ(teamNum, game, paramSet)
  
  baseStratQ = NaiveAdapAlgQ(teamNum, game, 'NaiveWar', paramSet);
  
  me.name = 'NaiveWarQ';

  
  me = class(me, 'NaiveWarQ', baseStratQ);

