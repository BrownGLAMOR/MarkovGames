%-----------------------------------------------------------------------
% Class: AdapAlgQ (Constructor)
%
%
%-----------------------------------------------------------------------
function player = OffAdapAlgQ(teamNum, game, stratName, paramSet)

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

player = class(player, 'OffAdapAlgQ');

% use a counter for variable multidimensional statespace
counter = num2cell(ones(1, length(player.stateDim)));
maxed = 0;
%Iterate over states to initialize adaptive strategies
% better way -- use ind2sub dcgfixthis
while not(maxed)       
  pStateRef = counter;

  pStateRef{player.sLen+1} = ':';

  % find legal moves
  nonZero = find(squeeze(player.Policy(pStateRef{:}))');
  
  % adap strategies expect vector of everybody's moves (though they only
  % use their own)
  moves = num2cell(repmat(0,1,player.numPlayers));    
  moves{teamNum} = num2cell(nonZero);
  
  % make bogus game -- carries move information to strategy
  gm(1,1,:) = [1 1];			% for hartMC (need some game matrix)
  subG = Game('', '', moves, gm);  
  
  % init strategy
  player.StratTable{pStateRef{:}} = ...
                 makeplayer(teamNum, subG, stratName, .05); % hardcode nu!  yeah!!

  [counter, maxed] = inclist(player, counter, player.stateDim);  
end
