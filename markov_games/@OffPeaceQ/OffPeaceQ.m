function me = OffPeaceQ(teamNum, game, paramSet)

  baseStratQ = OffAdapAlgQ(teamNum, game, 'peace', paramSet);
  
  me.name = 'OffPeaceQ';
  
  me = class(me, 'OffPeaceQ', baseStratQ);
