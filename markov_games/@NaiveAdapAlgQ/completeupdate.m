% in progress
%-----------------------------------------------------------------------
% Funciton: update
%
% Description:  Update the Q-value table for this player
%               Q(gamestate, opponent_action, team_action)
%
%-----------------------------------------------------------------------
function [player, newQ] = update(player, reward, curState, newState, ...
                                actions, isGameOver, oppStrats, otherPolicy)

% decay learning rate
player.numUpdates = player.numUpdates + 1;
alpha = getAlpha(player.paramSet);



if isGameOver == 1
    V = 0;
else
    qStateRef = newState;           
    
    pStateRef = curState;
    pStateRef{player.sLen + 1} = ':';
    nonZero = find(squeeze(player.Policy(pStateRef{:}))');

    %%%% for completely informed Hedge, iterate over adjacent states
    
    %first, set opponents' actions
    for i = 1:length(actions)
      if i ~= player.team
	oppgame = move(player.game,  i, actions(i));
      end
    end
    
    V = zeros(1, player.numActions);
    for j = nonZero
      [tmpgame, reward] = move(oppgame, player.team, j);
      
      
      qStateRef = get(checkStatus(tmpgame), 'State');      
      qStateRef{player.sLen + 1} = ':';
      qStateRef{player.sLen + 2} = ':';
      Qmat = squeeze(player.Qvalues(qStateRef{:}));
      
      if ~isempty(otherPolicy)
	
	%V = policy * rewards * otherPolicy
	%     otherWeights = hedgedist(squeeze(otherPolicy(1,1,1,1,:)));
      else
	;
      end
      
      oppDist = get(oppStrats{newState{:}}, 'dist');
      myDist = get(player.StratTable{newState{:}}, 'dist');
    
      V(j) = oppDist * Qmat * myDist';
      

    end
end
blaoeuthn
% update hedge weight
pStateRef = curState;
pStateRef{player.sLen + 1} = actions(player.team);
updateWeight = player.Policy(pStateRef{:}) + reward;
player.Policy(pStateRef{:}) = updateWeight;

qStateRef = curState;
qStateRef{player.sLen + 1} = actions(player.opponent);
qStateRef{player.sLen + 2} = actions(player.team);
curQ = player.Qvalues(qStateRef{:});
newQ = reward + player.gamma * V;
player.Qvalues(qStateRef{:}) = (1 - alpha) * curQ + alpha * newQ;



