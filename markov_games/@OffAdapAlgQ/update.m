%-----------------------------------------------------------------------
% Funciton: update
%
% Description:  Update the Q-value table for this player
%               Q(gamestate, opponent_action, team_action)
%
%-----------------------------------------------------------------------
function [player, newQ] = update(player, reward, curState, newState, ...
                                actions, isGameOver, oppStrats, curGame)

% decay learning rate
player.numUpdates = player.numUpdates + 1;

curStrat = player.StratTable{curState{:}};
curOppStrat = oppStrats{curState{:}};

%%%% for complete information, iterate over adjacent states

myLegalActs = get(curStrat, 'actions'); 
myLegalActs = cat(1,myLegalActs{:});	% convert from cell

oppLegalActs = get(curOppStrat, 'actions'); % 2 player brittle
oppLegalActs = cat(1,oppLegalActs{:});	% convert from cell
oppCurDist = filldist(player, curOppStrat);

% randomly select order of actions
playerOrder = randperm(player.numPlayers);

%V = zeros(1, player.numActions);
V = zeros(player.numActions, player.numActions);
%rewards = zeros(1, player.numActions);
rewards = zeros(player.numActions, player.numActions);

% iterate over action pairs
for myAct = myLegalActs'	
  for oppAct = oppLegalActs'

    tmpGame = curGame;
    for p = playerOrder
      if p == player.team
	[tmpGame, reward] = move(tmpGame, p, myAct);	
      else
	tmpGame = move(tmpGame,  p, oppAct);
      end
    end
  
    % get information from hypothetical move
    [tmpGame, isGameOver, addReward] = checkStatus(tmpGame);
  
    reward = reward + addReward(player.team);
  
    % the state for the j action profile :
    jState = get(checkStatus(tmpGame), 'State'); 
    
    if isGameOver == 1    	
%      V(myAct) = V(myAct) + 0;
      V(oppAct,myAct) = 0;
%      rewards(myAct) = rewards(myAct) + reward;
      rewards(oppAct, myAct) = reward;
      if reward > 0
	a = 4;
      end
    else
      
      qStateRef = jState;
      qStateRef{player.sLen + 1} = ':';
      qStateRef{player.sLen + 2} = ':';
      Qmat = squeeze(player.Qvalues(qStateRef{:}));
      
      % calculate 'expected V' by using our and opponents' dists
      oppNextDist = filldist(player, oppStrats{jState{:}});
      myNextDist = filldist(player, player.StratTable{jState{:}});
      
%      V(myAct) = V(myAct) + oppCurDist(oppAct) .* (oppNextDist' * Qmat * ...
%						   myNextDist);    
      V(oppAct, myAct) = oppNextDist' * Qmat * myNextDist;
%      rewards(myAct) = rewards(myAct) + oppCurDist(oppAct) * reward;
      rewards(oppAct, myAct) = reward;      
    end	
  end
end




qStateRef = curState;
qStateRef{player.sLen + 1} = ':';
qStateRef{player.sLen + 2} = ':';

alphaRef = curState;
alphaRef{player.sLen + 1} = actions(player.opponent);
alphaRef{player.sLen + 2} = actions(player.team);

[player.paramSet, alpha] = newAlpha(player.paramSet, alphaRef);

% Calculate New Qs
curQ = squeeze(player.Qvalues(qStateRef{:}));
newQ = rewards + player.gamma .* V;
Qupdate = (1 - alpha) * curQ + alpha .* newQ;
player.Qvalues(qStateRef{:}) = Qupdate;

if mod(player.numUpdates,100) == 0
  if player.team == 1
    a = 3;
  end
end

% calculate expected rewards over opponents actions
adapPayoffs = oppCurDist' * Qupdate;  
  
% Update Strat weights
player.StratTable{curState{:}} = update(curStrat, ...
	unfilllist(player, curStrat, adapPayoffs),  ...
	mapaction(player,player.StratTable{curState{:}}, actions)); 
  
pStateRef = curState;

pStateRef{player.sLen+1} = ':';

%pStateRef{player.sLen+1} = ':';

oldPol = player.Policy(pStateRef{:});
newPol = filldist(player, player.StratTable{curState{:}});

player.Policy(pStateRef{:}) = newPol;

