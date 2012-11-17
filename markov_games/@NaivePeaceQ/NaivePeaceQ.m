%-----------------------------------------------------------------------

function me = NaivePeaceQ(teamNum, game, paramSet)
  
  baseStratQ = NaiveAdapAlgQ(teamNum, game, 'NaivePeace', paramSet);
  
  me.name = 'NaivePeaceQ';

  
  me = class(me, 'NaivePeaceQ', baseStratQ);

