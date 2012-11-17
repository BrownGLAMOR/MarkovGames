function me = OffNaiveHartMCQ(teamNum, game, paramSet)

  baseStratQ = OffNaiveAdapAlgQ(teamNum, game, 'naivehartmc', paramSet);
  
  me.name = 'OffNaiveHartMCQ';

  me = class(me, 'OffNaiveHartMCQ', baseStratQ);
