function me = PeaceQ(teamNum, game, paramSet, stratParams)
  if nargin < 4
   stratParams = []
  end 


  baseStratQ = AdapAlgQ(teamNum, game, 'peace', paramSet, stratParams);
  
  me.name = 'PeaceQ';
  
  me = class(me, 'PeaceQ', baseStratQ);
