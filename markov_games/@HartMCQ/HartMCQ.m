function me = HartMCQ(teamNum, game, paramSet, stratParams)

  if nargin < 4
    stratParams = []
  end 

  baseStratQ = AdapAlgQ(teamNum, game, 'HMC', paramSet, stratParams);
  
  me.name = 'HartMCQ';
  
  me = class(me, 'HartMCQ', baseStratQ);
