%-----------------------------------------------------------------------
% Funciton: initPolicy
%
%   returns a game grid with the valid actions for this team
%   and hasball status.
%       only handles action set that is a numActions or numActions^2
%
%-----------------------------------------------------------------------
function [qTable, policy] = initTables(game, team, tableType)

% U,D,R,L
numActions = get(game, 'NumActions');
switch tableType
case 'SimpleState'
    qTable = ones([game.width, game.length, numActions]);
    policy = ones([game.width, game.length, numActions]);
    qTable(game.width, :, 1) = 0; % can't move north
    qTable(1, :, 2) = 0;  % can't move south
    qTable(:, game.length, 3) = 0; % can't move east
    qTable(:, 1, 4) = 0; % can't move west

    for row = 1:game.width
        for col = 1:game.length
            policy(row,col, :) = squeeze(qTable(row,col,:)) ...
                                 / sum(squeeze(qTable(row,col,:)));
        end
    end
case 'StateSingleAction'
    qTable = ones([game.width, game.length, game.width, game.length, ...
                   numActions]);
    policy = ones([game.width, game.length, game.width, game.length, ...
                  numActions]);

    if team == 1
        qTable(game.width, :, :, :, 1) = 0; % can't move north
        qTable(1, :, :, :, 2) = 0;  % can't move south
        qTable(:, game.length, :, :, 3) = 0; % can't move east
        qTable(:, 1, :, :, 4) = 0; % can't move west
    else
        qTable(:, :, game.width, :, 1) = 0; % can't move north
        qTable(:, :, 1, :, 2) = 0;  % can't move south
        qTable(:, :, :, game.length, 3) = 0; % can't move east
        qTable(:, :, :, 1, 4) = 0; % can't move west
    end

    for row = 1:game.width
        for col = 1:game.length
            for row2 = 1:game.width
                for col2 = 1:game.length
                    policy(row,col,row2,col2, :) = ...
                        squeeze(qTable(row,col,row2,col2,:)) /  ...
                        sum(squeeze(qTable(row,col,row2,col2,:)));
                    
                end
            end
        end
    end
case {'StateDoubleAction', 'StateDoubleJointAction'}
    qTable = ones([game.width, game.length, game.width, game.length, ...
                      ones(1, 2) .* numActions]);

    % qTable is always (state, oppAction, teamAction)
    % state is always (p1x, p1y, p2x, p2y)
    if team == 1
        qTable(game.width, :, :, :, :, 1) = 0; % can't move north
        qTable(1, :, :, :, :, 2) = 0;  % can't move south
        qTable(:, game.length, :, :, :, 3) = 0; % can't move east
        qTable(:, 1, :, :, :, 4) = 0; % can't move west
        qTable(:, :, game.width, :, 1, :) = 0; % can't move north
        qTable(:, :, 1, :, 2, :) = 0;  % can't move south
        qTable(:, :, :, game.length, 3, :) = 0; % can't move east
        qTable(:, :, :, 1, 4, :) = 0; % can't move west
    else
        qTable(:, :, game.width, :, :, 1) = 0; % can't move north
        qTable(:, :, 1, :, :, 2) = 0;  % can't move south
        qTable(:, :, :, game.length, :, 3) = 0; % can't move east
        qTable(:, :, :, 1, :, 4) = 0; % can't move west
        qTable(game.width, :, :, :, 1, :) = 0; % can't move north
        qTable(1, :, :, :, 2, :) = 0;  % can't move south
        qTable(:, game.length, :, :, 3, :) = 0; % can't move east
        qTable(:, 1, :, :, 4, :) = 0; % can't move west
    end

    if strcmp(tableType, 'StateDoubleAction') == 1
        policy = ones([game.width, game.length, game.width, game.length, ...
                      numActions]);
        for row = 1:game.width
            for col = 1:game.length
                for row2 = 1:game.width
                    for col2 = 1:game.length
                        nz = ...
                          find(sum(squeeze(qTable(row,col,row2,col2,:,:)), 2));
                        policy(row,col,row2,col2, :) = ...
                            squeeze(qTable(row,col,row2,col2,nz(1),:)) /  ...
                            sum(squeeze(qTable(row,col,row2,col2,nz(1),:)));
                    end
                end
            end
        end
    else
        policy = ones([game.width, game.length, game.width, game.length, ...
                  ones(1,2) .* numActions]);
        for row = 1:game.width
            for col = 1:game.length
                for row2 = 1:game.width
                    for col2 = 1:game.length
                        policy(row,col,row2,col2, :, :) = ...
                            squeeze(qTable(row,col,row2,col2,:,:)) /  ...
                            sum(sum(squeeze(qTable(row,col,row2,col2,:,:))));
                    end
                end
            end
        end
    end
otherwise
    error([tableType,' Is not a valid tableType']);
end
