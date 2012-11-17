function me = OffWarQ(teamNum, game, paramSet)

  baseStratQ = OffAdapAlgQ(teamNum, game, 'war', paramSet);
  
  me.name = 'OffWarQ';
  
  me = class(me, 'OffWarQ', baseStratQ);
