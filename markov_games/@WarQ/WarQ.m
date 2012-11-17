function me = WarQ(teamNum, game, paramSet)

  baseStratQ = AdapAlgQ(teamNum, game, 'war', paramSet);
  
  me.name = 'WarQ';
  
  me = class(me, 'WarQ', baseStratQ);
