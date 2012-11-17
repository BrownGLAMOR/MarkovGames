function me = OffHedgeQ(teamNum, game, paramSet)

  baseStratQ = OffAdapAlgQ(teamNum, game, 'hedge', paramSet);
  
  me.name = 'OffHedgeQ';
  
  me = class(me, 'OffHedgeQ', baseStratQ);
