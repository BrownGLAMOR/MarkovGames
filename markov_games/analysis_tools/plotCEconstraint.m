%-----------------------------------------------------------------------
% File: plotCEconstraint
%
% Description:
%   plots the 3D CE policy solution space for a 2x2 game
%
%   gameMat1 and gameMat2 must be 2x2 game
%   gameMat1 - row player
%   gameMat1 - col player
%
%-----------------------------------------------------------------------
function [v, p] = plotCEconstraint(gameMat1, gameMat2, color)

if nargin < 3
    color = 'red';
end
if size(gameMat1) ~= [2,2]
    error('plotCEconstraint only works on 2x2 games');
end
c1TLC = gameMat1(1,1) - gameMat1(2,1);
c1TRC = gameMat1(1,2) - gameMat1(2,2);
disp(['Player 1 C1 = (', num2str(c1TLC), '* piTL) + (', ...
      num2str(c1TRC), '* piTR) >= 0']);
c2BLC = gameMat1(2,1) - gameMat1(1,1);
c2BRC = gameMat1(2,2) - gameMat1(1,2);
disp(['Player 1 C2 = (', num2str(c2BLC), '* piBL) + (', ...
      num2str(c2BRC), '* piBR) >= 0']);

c3TLC = gameMat2(1,1) - gameMat2(1,2);
c3BLC = gameMat2(2,1) - gameMat2(2,2);
disp(['Player 2 C1 = (', num2str(c3TLC), '* piTL) + (', ...
      num2str(c3BLC), '* piBL) >= 0']);

c4TRC = gameMat2(1,2) - gameMat2(1,1);
c4BRC = gameMat2(2,2) - gameMat2(2,1);
disp(['Player 2 C2 = (', num2str(c4TRC), '* piTR) + (', ...
      num2str(c4BRC), '* piBR) >= 0']);

[piTL,piTR,piBL] = meshgrid(0:.01:1,0:.01:1,0:.01:1);   

v = ((c1TLC * piTL) + (c1TRC * piTR) >= 0 & ...
     (c2BLC* piBL) + (c2BRC * (1 - piTL - piTR - piBL)) >= 0 & ...
     (c3TLC * piTL) + (c3BLC * piBL) >=0 & ...
     (c4TRC * piTR) + (c4BRC * (1 - piTL - piTR - piBL)) >= 0 & ...
     piTL+piTR+piBL <= 1 & ...
     piTL >= 0 & ...
     piTR >= 0 & ...
     piBL >= 0);

p = patch(isosurface(piTL,piTR,piBL,v,.5),'FaceColor',color,'EdgeColor','none');

% remaining is for a pretty picture
isonormals(piTL,piTR,piBL,v,p);
view(3)
camlight
lighting phong
