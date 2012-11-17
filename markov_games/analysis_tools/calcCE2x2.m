%-----------------------------------------------------------------------
% File: calcCE2x2
%
% Description:
%   Compute the max(?) CE for a 2-player 2x2 game
%
%   gameMat1 and gameMat2 must be 2x2 game
%   gameMat1 - row player
%   gameMat2 - col player
%
% Note:
%   currently only computes UTILITARIAN CEQM
%
%-----------------------------------------------------------------------
function [policy, v] = calcCE2x2(gameMat1, gameMat2, showDEBUG)

if nargin < 3
    showDEBUG = 0;
end

if size(gameMat1) ~= [2,2]
    error('calcCE2x2 only works on 2x2 games');
end

c1TLC = gameMat1(1,1) - gameMat1(2,1);
c1TRC = gameMat1(1,2) - gameMat1(2,2);
c2BLC = gameMat1(2,1) - gameMat1(1,1);
c2BRC = gameMat1(2,2) - gameMat1(1,2);

c3TLC = gameMat2(1,1) - gameMat2(1,2);
c3BLC = gameMat2(2,1) - gameMat2(2,2);

c4TRC = gameMat2(1,2) - gameMat2(1,1);
c4BRC = gameMat2(2,2) - gameMat2(2,1);
if showDEBUG
    disp(['Original Constraints']);
    disp(['Player 1 C1 = (', num2str(c1TLC), ' * piTL) + (', ...
          num2str(c1TRC), ' * piTR) >= 0']);
    disp(['Player 1 C2 = (', num2str(c2BLC), ' * piBL) + (', ...
          num2str(c2BRC), ' * piBR) >= 0']);
    disp(['Player 2 C1 = (', num2str(c3TLC), ' * piTL) + (', ...
          num2str(c3BLC), ' * piBL) >= 0']);
    disp(['Player 2 C2 = (', num2str(c4TRC), ' * piTR) + (', ...
          num2str(c4BRC), ' * piBR) >= 0']);
    disp([' ']);
end

%F = zeros(4,1);
%A = zeros(5,4);
%F = [gameMat1(1,1) + gameMat2(1,1); ...
%     gameMat1(1,2) + gameMat2(1,2); ...
%     gameMat1(2,1) + gameMat2(2,1); ...
%     gameMat1(2,2) + gameMat2(2,2)];
%A = [c1TLC, c1TRC, 0, 0;   ...
%     0, 0, c2BLC, c2BRC;   ...
%     c3TLC, 0, c3BLC, 0;      ...
%     0, c4TRC, 0, c4BRC;   ...
%     1,1,1,1];
%B = [0; 0; 0; 0; 1];
%E = [ones(4,1); 0];
%lb = zeros(1,4);
%ub = ones(1,4);
%colInt = zeros(1, 4);
%[v, policy, duals] = lp_solve(F, A, B, E, lb, ub, colInt);
%v
%policy



% utilitarian CE (for now!!!)
% ignore the constant factor in the maximization
% argmax_{pi} jr(TL) * pi(TL) + jr(TR) * pi(TR) + jr(BL) * pi(BL) + jr(BR) * pi(BR)
% = argmax_pi 
%      [jr(TL)-jr(BR)] * pi(TL) + [jr(TR)-jr(BR)] * pi(TR) + [jr(BL)-jr(BR)] * pi(BL)
F = zeros(3,1);
A = zeros(5,3);
jointBR = gameMat1(2,2) + gameMat2(2,2);
F = [gameMat1(1,1) + gameMat2(1,1) - jointBR; ...
     gameMat1(1,2) + gameMat2(1,2) - jointBR; ...
     gameMat1(2,1) + gameMat2(2,1) - jointBR];

% CE constraints (reduce to three variables)
A = [c1TLC, c1TRC, 0;                  ...
     -c2BRC, -c2BRC, (c2BLC - c2BRC);   ...
     c3TLC, 0, c3BLC;                   ...
     -c4BRC, (c4TRC - c4BRC), -c4BRC;   ...
     1,1,1];
if showDEBUG
    disp(['New Constraints']);
    disp(['Player 1 C1 = (', num2str(c1TLC), ' * piTL) + (', ...
          num2str(c1TRC), ' * piTR) >= 0']);
    disp(['Player 1 C2 = (', num2str(-c2BRC), ' * piTL) + (', ...
          num2str(-c2BRC), ' * piTR) + (', ...
          num2str(c2BLC-c2BRC), ' * piBL) >= ', num2str(-c2BRC)]);
    disp(['Player 2 C1 = (', num2str(c3TLC), ' * piTL) + (', ...
          num2str(c3BLC), ' * piBL) >= 0']);
    disp(['Player 2 C2 = (', num2str(-c4BRC), ' * piTL) + (', ...
          num2str(c4TRC-c4BRC), ' * piTR) + (', ...
          num2str(-c4BRC), ' * piBL) >= ', num2str(-c4BRC)]);
    disp([' ']);
end
B = [0; -c2BRC; 0; -c4BRC; 1];
E = [ones(4,1); -1];
lb = zeros(1,3);
ub = ones(1,3);
colInt = zeros(1, 3);

[v, policy, duals] = lp_solve(F, A, B, E, lb, ub, colInt);

if showDEBUG
    disp(['Policy: ',num2str(policy(1)),', ',num2str(policy(2)),', ',num2str(policy(3))]);
    disp(['Policy: pi(BR) = 1 - (pi(TL) + pi(TR) + pi(BL)): ', ...
         num2str(1 - policy(1) - policy(2) - policy(3))]);
end
