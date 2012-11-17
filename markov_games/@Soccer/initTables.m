%-----------------------------------------------------------------------
% Funciton: initPolicy
%
%   returns a game grid with the valid actions for this team
%   and hasball status.
%       only handles action set that is a numActions or numActions^2
%
%-----------------------------------------------------------------------
function [qTable, policy] = initTables(game, team, tableType)

% actions 1=N, 2=S, 3=E, 4=W, 5=stay
numActions = get(game, 'NumActions');
switch tableType
case 'SimpleState'
    qTable = ones([game.width, game.length, 2, numActions]);
    policy = ones([game.width, game.length, 2, numActions]);
    qTable(game.width, :, :, 1) = 0; % can't move north
    qTable(1, :, :, 2) = 0;  % can't move south
    qTable(:, game.length, :, 3) = 0; % can't move east
    qTable(:, 1, :, 4) = 0; % can't move west

    if game.width > 2
        qTable(2, [1, game.length], :, 2) = 0;
        qTable(game.width - 1, [1, game.length], :, 1) = 0;
        qTable([1,game.width], 2, :, 4) = 0;
        qTable([1,game.width], game.length - 1, :, 3) = 0;
    end
    for row = 1:game.width
        for col = 1:game.length
            for hasBall = 1:2
                policy(row,col, hasBall, :) = ...
                    squeeze(qTable(row,col,hasBall,:)) / ...
                    sum(squeeze(qTable(row,col,hasBall,:)));
            end
        end
    end
case 'StateSingleAction'
    qTable = ones([game.width, game.length, game.width, game.length, 2, ...
                   numActions]);
    policy = ones([game.width, game.length, game.width, game.length, 2, ...
                  numActions]);

    if team == 1
        qTable(game.width, :, :, :, :, 1) = 0; % can't move north
        qTable(1, :, :, :, :, 2) = 0;  % can't move south
        qTable(:, game.length, :, :, :, 3) = 0; % can't move east
        qTable(:, 1, :, :, :, 4) = 0; % can't move west
        if game.width > 2
            qTable(2, [1, game.length], :, :, :, 2) = 0;
            qTable(game.width - 1, [1, game.length], :, :, :, 1) = 0;
            qTable([1,game.width], 2, :, :, :, 4) = 0;
            qTable([1,game.width], game.length - 1, :, :, :, 3) = 0;
        end
    else
        qTable(:, :, game.width, :, :, 1) = 0; % can't move north
        qTable(:, :, 1, :, :, 2) = 0;  % can't move south
        qTable(:, :, :, game.length, :, 3) = 0; % can't move east
        qTable(:, :, :, 1, :, 4) = 0; % can't move west
        if game.width > 2
            qTable(:, :, 2, [1, game.length], :, 2) = 0;
            qTable(:, :, game.width - 1, [1, game.length], :, 1) = 0;
            qTable(:, :, [1,game.width], 2, :, 4) = 0;
            qTable(:, :, [1,game.width], game.length - 1, :, 3) = 0;
        end
    end

    for row = 1:game.width
        for col = 1:game.length
            for row2 = 1:game.width
                for col2 = 1:game.length
                    for hasBall = 1:2
                        policy(row,col,row2,col2,hasBall, :) = ...
                            squeeze(qTable(row,col,row2,col2,hasBall,:)) /  ...
                            sum(squeeze(qTable(row,col,row2,col2,hasBall,:)));
                    end
                end
            end
        end
    end
case {'StateDoubleAction', 'StateDoubleJointAction'}
    qTable = ones([game.width, game.length, game.width, game.length, 2, ...
                      ones(1, 2) .* numActions]);

    % state is (p1x,p1y,p2x,p2y,hasBall)
    % qTable is (state, oppAction, teamAction)
    if team == 1
        qTable(game.width, :, :, :, :, :, 1) = 0; % can't move north
        qTable(1, :, :, :, :, :, 2) = 0;  % can't move south
        qTable(:, game.length, :, :, :, :, 3) = 0; % can't move east
        qTable(:, 1, :, :, :, :, 4) = 0; % can't move west
        if game.width > 2
            qTable(2, [1, game.length], :, :, :, :, 2) = 0;
            qTable(game.width - 1, [1, game.length], :, :, :, :, 1) = 0;
            qTable([1, game.width], 2, :, :, :, :, 4) = 0;
            qTable([1, game.width], game.length - 1, :, :, :, :, 3) = 0;
        end

        qTable(:, :, game.width, :, :, 1, :) = 0; % can't move north
        qTable(:, :, 1, :, :, 2, :) = 0;  % can't move south
        qTable(:, :, :, game.length, :, 3, :) = 0; % can't move east
        qTable(:, :, :, 1, :, 4, :) = 0; % can't move west
        if game.width > 2
            qTable(:, :, 2, [1, game.length], :, 2, :) = 0;
            qTable(:, :, game.width - 1, [1, game.length], :, 1, :) = 0;
            qTable(:, :, [1, game.width], 2, :, 4, :) = 0;
            qTable(:, :, [1, game.width], game.length - 1, :, 3, :) = 0;
        end
    else
        qTable(game.width, :, :, :, :, 1, :) = 0; % can't move north
        qTable(1, :, :, :, :, 2, :) = 0;  % can't move south
        qTable(:, game.length, :, :, :, 3, :) = 0; % can't move east
        qTable(:, 1, :, :, :, 4, :) = 0; % can't move west
        if game.width > 2
            qTable(2, [1, game.length], :, :, :, 2, :) = 0;
            qTable(game.width - 1, [1, game.length], :, :, :, 1, :) = 0;
            qTable([1,game.width], 2, :, :, :, 4, :) = 0;
            qTable([1,game.width], game.length - 1, :, :, :, 3, :) = 0;
        end

        qTable(:, :, game.width, :, :, :, 1) = 0; % can't move north
        qTable(:, :, 1, :, :, :, 2) = 0;  % can't move south
        qTable(:, :, :, game.length, :, :, 3) = 0; % can't move east
        qTable(:, :, :, 1, :, :, 4) = 0; % can't move west
        if game.width > 2
            qTable(:, :, 2, [1, game.length], :, :, 2) = 0;
            qTable(:, :, game.width - 1, [1, game.length], :, :, 1) = 0;
            qTable(:, :, [1,game.width], 2, :, :, 4) = 0;
            qTable(:, :, [1,game.width], game.length - 1, :, :, 3) = 0;
        end
    end

    if strcmp(tableType, 'StateDoubleAction') == 1
        policy = ones([game.width, game.length, game.width, game.length, 2, ...
                      numActions]);
        for row = 1:game.width
            for col = 1:game.length
                for row2 = 1:game.width
                    for col2 = 1:game.length
                        for hasBall = 1:2
                            nz = find(sum(squeeze(...
                                qTable(row,col,row2,col2,hasBall, :,:)), 2));
                            policy(row,col,row2,col2, hasBall, :) = ...
                             squeeze(...
                              qTable(row,col,row2,col2,hasBall, nz(1),:)) / ...
                             sum(squeeze(...
                                qTable(row,col,row2,col2,hasBall, nz(1),:)));
                        end
                    end
                end
            end
        end
    else
        policy = ones([game.width, game.length, game.width, game.length, 2, ...
                      ones(1, 2) .* numActions]);
        for row = 1:game.width
            for col = 1:game.length
                for row2 = 1:game.width
                    for col2 = 1:game.length
                        for hasBall = 1:2
                            policy(row,col,row2,col2, hasBall, :, :) = ...
                             squeeze(...
                              qTable(row,col,row2,col2,hasBall, :,:)) /  ...
                             sum(sum(squeeze(...
                                  qTable(row,col,row2,col2,hasBall, :,:))));
                        end
                    end
                end
            end
        end
    end
otherwise
    error([tableType,' Is not a valid tableType']);
end
