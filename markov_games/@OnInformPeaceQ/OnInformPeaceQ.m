function me = OnInformPeaceQ(teamNum, game, paramSet)

  baseStratQ = OffAdapAlgQ(teamNum, game, 'peace', paramSet);
  
  me.name = 'OnInformPeaceQ';

  me = class(me, 'OnInformPeaceQ', baseStratQ);
