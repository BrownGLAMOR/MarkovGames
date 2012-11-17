function me = OnInformHedgeQ(teamNum, game, paramSet)

  baseStratQ = OffAdapAlgQ(teamNum, game, 'hedge', paramSet);
  
  me.name = 'OnInformHedgeQ';

  me = class(me, 'OnInformHedgeQ', baseStratQ);
