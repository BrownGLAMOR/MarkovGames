%-----------------------------------------------------------------------
% Class: Random (Constructor)
%
%
%-----------------------------------------------------------------------
function player = Random(teamNum, game, paramSet)

player.team = teamNum;
if (teamNum == 1)
    player.opponent = 2;
else
    player.opponent = 1;
end

player.game = game;
player.numActions = get(game, 'NumActions');

%player.Policy = ones([get(game, 'Size') 1 player.numActions]);
[qt, player.Policy] = initTables(game, teamNum, 'StateSingleAction');

player = class(player, 'Random');
