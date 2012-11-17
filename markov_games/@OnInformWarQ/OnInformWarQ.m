function me = OnInformWarQ(teamNum, game, paramSet)

  baseStratQ = OffAdapAlgQ(teamNum, game, 'war', paramSet);
  
  me.name = 'OnInformWarQ';

  me = class(me, 'OnInformWarQ', baseStratQ);
