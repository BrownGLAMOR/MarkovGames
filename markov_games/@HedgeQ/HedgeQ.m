function me = HedgeQ(teamNum, game, paramSet, nu, delta)

  if nargin < 4
    nu = .05;
  end

  if nargin < 5
    delta = [];
  end

  stratParams = [nu delta];
  
  baseStratQ = AdapAlgQ(teamNum, game, 'hedge', paramSet, stratParams);
  
  me.name = 'HedgeQ';

  me = class(me, 'HedgeQ', baseStratQ);
