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

[player, V, rewards] = calcVs(player, curState, curGame, actions);

qStateRef = curState; % table ref to [curState opp_action :]
qStateRef{player.sLen + 1} = actions(player.opponent);
qStateRef{player.sLen + 2} = ':';

alphaRef = curState;  % table ref to [curState opp_action my_action]
alphaRef{player.sLen + 1} = actions(player.opponent);
alphaRef{player.sLen + 2} = actions(player.team);

[player.paramSet, alpha] = newAlpha(player.paramSet, alphaRef);

% update empirical frequency table
player.empFreqs(alphaRef{:}) = player.empFreqs(alphaRef{:}) + 1;


% Calculate New Qs
curQ = squeeze(player.Qvalues(qStateRef{:}));
newQ = rewards + player.gamma * V;
Qupdate = (1 - alpha) * curQ + alpha * newQ';
player.Qvalues(qStateRef{:}) = Qupdate;

% Update Strat weights
player.StratTable{curState{:}} = update(curStrat, ...
	unfilllist(player, curStrat, Qupdate)',  ...
	mapaction(player,player.StratTable{curState{:}}, actions)); 

pStateRef = curState;
pStateRef{player.sLen+1} = ':';

oldPol = player.Policy(pStateRef{:});
newPol = filldist(player, player.StratTable{curState{:}});

player.Policy(pStateRef{:}) = newPol;


