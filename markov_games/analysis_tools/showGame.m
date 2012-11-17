%-----------------------------------------------------------------------
% Funciton: 
%
% Description:
%
% Returns:
%
%-----------------------------------------------------------------------
function showGame(hist, width, length, game)

if nargin < 3
    length = 5;
    width = 4;
end
if nargin < 4
    game = 'soccer';
end

figure;
axis([0 length+1 0 width+1]);
grid on;
set(gca, 'NextPlot', 'replacechildren', ...
         'XTick', [1:length], 'YTick', [1:width]);

length = size(hist, 1);
for i = 1:length
    cla
    hold
    if strcmp(game, 'soccer') == 0
        stg =  ...
        sprintf('ix(%d): Player 1: (%d, %d) %d   Player 2 :  (%d, %d) %d', ...
              i, hist(i, 1), hist(i, 2), hist(i, 7), ...
                 hist(i, 3), hist(i, 4), hist(i, 8));
        plot(hist(i, 2), hist(i, 1), 'bo')
        plot(hist(i, 4), hist(i, 3), 'b*')
    else
        if hist(i, 5) == 1
            stg = ...
            sprintf('ix(%d): *Player 1*: (%d, %d)   Player 2 :  (%d, %d)', ...
                  i, hist(i, 1), hist(i, 2), hist(i, 3), hist(i, 4));
            plot(hist(i, 2), hist(i, 1), 'ro')
            plot(hist(i, 4), hist(i, 3), 'b*')
        else
            stg = ...
            sprintf('ix(%d):  Player 1 : (%d, %d)  *Player 2*:  (%d, %d)', ...
                  i, hist(i, 1), hist(i, 2), hist(i, 3), hist(i, 4));
            plot(hist(i, 2), hist(i, 1), 'bo')
            plot(hist(i, 4), hist(i, 3), 'r*')
        end
    end
    disp(stg)
    hold
    pause
end
