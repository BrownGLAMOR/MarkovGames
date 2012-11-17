function me = OnInformHartMCQ(teamNum, game, paramSet)

  baseStratQ = OffAdapAlgQ(teamNum, game, 'hmc', paramSet);
  
  me.name = 'OnInformHartMCQ';

  me = class(me, 'OnInformHartMCQ', baseStratQ);
