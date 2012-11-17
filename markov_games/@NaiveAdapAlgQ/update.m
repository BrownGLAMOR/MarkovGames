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

% because each adapalg strategy only knows about its legal actions, we
% have to pad the list for illegal actions (UNADJUSTED VERSION)
oppDist = filldist(player, oppStrats{newState{:}},1);
myDist = filldist(player, player.StratTable{newState{:}}, 1);

if isGameOver == 1			
    V = 0;
else
  qStateRef = newState;           
    
  qStateRef{player.sLen + 1} = ':';
  qStateRef{player.sLen + 2} = ':';
  Qmat = squeeze(player.Qvalues(qStateRef{:}));

  V = oppDist' * Qmat * myDist;
end

% update adapalg weight

qStateRef = curState;
qStateRef{player.sLen + 1} = actions(player.opponent);
qStateRef{player.sLen + 2} = actions(player.team);

[player.paramSet, alpha] = newAlpha(player.paramSet, qStateRef);



curQ = player.Qvalues(qStateRef{:});
newQ = reward + player.gamma * V;
Qupdate = (1 - alpha) * curQ + alpha * newQ;
player.Qvalues(qStateRef{:}) = Qupdate;

player.StratTable{curState{:}} = update(player.StratTable{curState{:}}, ...
	Qupdate, mapaction(player, player.StratTable{curState{:}}, actions));


pStateRef = curState;
pStateRef{player.sLen+1} = ':';

oldPol = player.Policy(pStateRef{:});
newPol = filldist(player, player.StratTable{curState{:}});

player.Policy(pStateRef{:}) = newPol;


