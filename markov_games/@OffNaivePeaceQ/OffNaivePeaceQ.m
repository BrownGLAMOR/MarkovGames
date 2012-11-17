function me = OffNaivePeaceQ(teamNum, game, paramSet)

  baseStratQ = OffNaiveAdapAlgQ(teamNum, game, 'NaivePeace', paramSet);
  
  me.name = 'OffNaivePeaceQ';

  me = class(me, 'OffNaivePeaceQ', baseStratQ);
