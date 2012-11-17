%-----------------------------------------------------------------------
% Class: NaiveAdapAlgQ.m
%
%
%-----------------------------------------------------------------------

function player = NaiveAdapAlgQ(teamNum, game, stratName, paramSet, adapParams)

if nargin == 4
  adapParams = [];
end

player.team = teamNum;
oppVec = [2 1];
player.opponent = oppVec(teamNum);
player.paramSet = paramSet;

player.gamma = get(paramSet, 'Gamma');

player.game = game;
player.numPlayers = get(game, 'NumPlayers');
player.numActions = get(game, 'NumActions');
player.stateDim = get(game, 'GameStateDim');
player.paramSet = set(paramSet, 'GameDims', ...
              [player.stateDim, player.numActions, player.numActions]);

player.sLen = length(player.stateDim);
% length of state array
[player.Qvalues, player.Policy] = ...
                            initTables(game, teamNum, 'StateDoubleAction');
player.Qvalues = player.Qvalues .* 0;

player.numUpdates = 0;

if length(player.stateDim) == 1
  player.StratTable = cell(player.stateDim,1);
else
  player.StratTable = cell(player.stateDim);
end


player.explore = .05;

player = class(player, 'NaiveAdapAlgQ');

counter = num2cell(ones(1, length(player.stateDim)));
maxed = 0;

%Iterate over states
while not(maxed)       
  pStateRef = counter;
  
  pStateRef{player.sLen+1} = ':';

  nonZero = find(squeeze(player.Policy(pStateRef{:}))');
  moves = num2cell(repmat(0,1,player.numPlayers));
  moves{teamNum} = num2cell(nonZero);
  subG = Game('', '', moves);  
  player.StratTable{pStateRef{:}} = ...
                 makeplayer(teamNum, subG, stratName, [adapParams player.explore]);
  [counter, maxed] = inclist(player, counter, player.stateDim);
  
end
