%-----------------------------------------------------------------------
% File: calcV
%
% Description:
%       encapsulate the V and reward calculation for a state
%
%-----------------------------------------------------------------------
function [player, V, rewards] = calcVs(player, curState, curGame, actions, oppStrats);

curStrat = player.StratTable{curState{:}};

%%%% for complete information, iterate over adjacent states

legalActions = get(curStrat, 'actions'); 
legalActions = cat(1,legalActions{:});	% convert from cell

% randomly select order of actions
playerOrder = randperm(player.numPlayers);


V = zeros(1, player.numActions);
rewards = zeros(1, player.numActions);
for j = legalActions'		% iterate over our actions
  
  tmpGame = curGame;
  for p = playerOrder
    if p == player.team
      [tmpGame, reward] = move(tmpGame, p, j);	
    else
      tmpGame = move(tmpGame,  p, actions(p));
    end
  end
  
  % get information from hypothetical move
  [tmpGame, isGameOver, addReward] = checkStatus(tmpGame);
  
  % ??
  reward = reward + addReward(player.team);
    
  % the state for the j action profile :
  jState = get(checkStatus(tmpGame), 'State'); 

  if isGameOver == 1    	
    V(j) = 0;
    rewards(j) = reward;
  else

    qStateRef = jState;
    qStateRef{player.sLen + 1} = ':';
    qStateRef{player.sLen + 2} = ':';
    Qmat = squeeze(player.Qvalues(qStateRef{:}));

    if (player.useWeightsForVCalc)
       % calculate 'expected V' by using our and opponents' weight dists
       oppDist = filldist(player, oppStrats{jState{:}});
       myDist = filldist(player, player.StratTable{jState{:}});
 
       V(j) = oppDist' * Qmat * myDist;    

    else  
       % use empirical frequencies
       jointDist = squeeze(player.empFreqs(qStateRef{:}));
       jointDist = jointDist ./ max(1,sum(jointDist(:)));

       V(j) = sum(jointDist(:) .* Qmat(:));
    end
    rewards(j) = reward;
  end	
end


























