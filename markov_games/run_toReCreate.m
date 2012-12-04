
% THE following blocks of commands will generate the values in Table
% of the Hall, Greenwald CEQ paper
% NOTES: 
% - Q, Friend and Foe aren't working yet, I have not confirmed that
% CC is the same as uCE, but I think it is.
% - There is a command for value iteration at the bottom of the file
% For somereason...VI seems to be working, or at least getting the same
% values as Q learning. I need to check the rest of them..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(4,1) Value iteration, maybe?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gametype = 'grid1';
gamma = .9;
normgamma = 1;
teamtype = 'CCr';
valiter = 1;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid1-CC-10000-VI-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(1,1) Q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(1,2) Q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(1,3) Q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(2,1) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(2,2) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(2,3) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(3,1) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(3,2) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(3,3) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(4,1) uCE-Q GG1 Commands -MAYBE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gametype = 'grid1';
gamma = .9;
normgamma = 1;
teamtype = 'CC';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid1-CC-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(4,2) uCE-Q GG2 Commands -MAYBE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gametype = 'grid2';
gamma = .9;
normgamma = 1;
teamtype = 'CC';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid2-CC-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid2');
experiments/grid/grid3-CCl-10000-VI-NG-alpha1-eps1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(4,3) uCE-Q G3  Commands -MAYBE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gametype = 'grid3';
gamma = .9;
normgamma = 1;
teamtype = 'CC';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid3-CC-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(5,1) eCE-Q GG1 Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gametype = 'grid1';
gamma = .9;
normgamma = 1;
teamtype = 'CCe';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid1-CCe-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simul = Simulation(gridgame(1), 'CCe', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid1-CCe-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 1 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Random position at restart
Number of CCe teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid1-CCe-10000-NG-alpha1-eps1-
Iteration 1000:   Games(135): Player 1 (3, 2),  Player  2 (1, 3): 67 to 75
Iteration 2000:   Games(278): Player 1 (2, 2),  Player  2 (2, 3): 143 to 147
Iteration 3000:   Games(400): Player 1 (2, 3),  Player  2 (1, 2): 204 to 213
Iteration 4000:   Games(531): Player 1 (3, 1),  Player  2 (1, 2): 272 to 280
Iteration 5000:   Games(643): Player 1 (3, 1),  Player  2 (2, 2): 326 to 340
Iteration 6000:   Games(765): Player 1 (2, 1),  Player  2 (2, 3): 391 to 402
Iteration 7000:   Games(887): Player 1 (2, 2),  Player  2 (1, 3): 462 to 457
Iteration 8000:   Games(1012): Player 1 (3, 1),  Player  2 (1, 2): 526 to 521
Iteration 9000:   Games(1131): Player 1 (2, 1),  Player  2 (2, 2): 584 to 588
Iteration 10000:   Games(1257): Player 1 (3, 2),  Player  2 (2, 1): 644 to 659
testmode
Total number of games completed: 1257
Final score: Player 1 (644) Player 2 (659)
Total game vals: Player 1 (635.37)  Player 2 (650.37)

%%%%%
simul = Simulation(gridgame(1,0), 'CCe', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid1-CCe-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 1 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid1-CCe-10000-NG-TEST-
Iteration 1000:   Games(250): Player 1 (3, 1),  Player  2 (1, 1): 250 to 250
Iteration 2000:   Games(500): Player 1 (3, 1),  Player  2 (1, 1): 500 to 500
Iteration 3000:   Games(750): Player 1 (3, 1),  Player  2 (1, 1): 750 to 750
Iteration 4000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 1000 to 1000
Iteration 5000:   Games(1250): Player 1 (3, 1),  Player  2 (1, 1): 1250 to 1250
Iteration 6000:   Games(1500): Player 1 (3, 1),  Player  2 (1, 1): 1500 to 1500
Iteration 7000:   Games(1750): Player 1 (3, 1),  Player  2 (1, 1): 1750 to 1750
Iteration 8000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 2000 to 2000
Iteration 9000:   Games(2250): Player 1 (3, 1),  Player  2 (1, 1): 2250 to 2250
Iteration 10000:   Games(2500): Player 1 (3, 1),  Player  2 (1, 1): 2500 to 2500
testmode
Total number of games completed: 2500
Final score: Player 1 (2500) Player 2 (2500)
Total game vals: Player 1 (2500)  Player 2 (2500)

%%%%%%
100,100 2500
%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(5,2) eCE-Q GG2 Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gametype = 'grid2';
gamma = .9;
normgamma = 1;
teamtype = 'CCe';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid2-CCe-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simul = Simulation(gridgame(2), 'CCe', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid2-CCe-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Random position at restart
Number of CCe teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid2-CCe-10000-NG-alpha1-eps1-
Iteration 1000:   Games(183): Player 1 (1, 1),  Player  2 (1, 3): 96 to 94
Iteration 2000:   Games(393): Player 1 (3, 1),  Player  2 (2, 2): 199 to 212
Iteration 3000:   Games(605): Player 1 (3, 2),  Player  2 (1, 1): 307 to 323
Iteration 4000:   Games(795): Player 1 (1, 2),  Player  2 (2, 2): 409 to 417
Iteration 5000:   Games(980): Player 1 (2, 1),  Player  2 (2, 2): 510 to 512
Iteration 6000:   Games(1191): Player 1 (3, 3),  Player  2 (1, 1): 602 to 641
Iteration 7000:   Games(1400): Player 1 (3, 3),  Player  2 (2, 1): 708 to 749
Iteration 8000:   Games(1619): Player 1 (3, 1),  Player  2 (1, 1): 815 to 869
Iteration 9000:   Games(1800): Player 1 (1, 1),  Player  2 (3, 3): 908 to 962
Iteration 10000:   Games(1972): Player 1 (3, 2),  Player  2 (1, 2): 990 to 1059
testmode
Total number of games completed: 1972
Final score: Player 1 (990) Player 2 (1059)
Total game vals: Player 1 (981.34)  Player 2 (1050.34)

%%%%%%

simul = Simulation(gridgame(2,0), 'CCe', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid2-CCe-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid2-CCe-10000-NG-TEST-
Iteration 1000:   Games(333): Player 1 (2, 1),  Player  2 (1, 2): 333 to 160
Iteration 2000:   Games(666): Player 1 (2, 2),  Player  2 (1, 3): 666 to 315
Iteration 3000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 1000 to 505
Iteration 4000:   Games(1333): Player 1 (2, 1),  Player  2 (1, 2): 1333 to 678
Iteration 5000:   Games(1666): Player 1 (2, 2),  Player  2 (1, 3): 1666 to 843
Iteration 6000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 2000 to 1005
Iteration 7000:   Games(2333): Player 1 (2, 1),  Player  2 (1, 1): 2333 to 1183
Iteration 8000:   Games(2666): Player 1 (2, 2),  Player  2 (1, 3): 2666 to 1340
Iteration 9000:   Games(3000): Player 1 (3, 1),  Player  2 (1, 1): 3000 to 1506
Iteration 10000:   Games(3333): Player 1 (2, 1),  Player  2 (1, 1): 3333 to 1669
testmode
Total number of games completed: 3333
Final score: Player 1 (3333) Player 2 (1669)
Total game vals: Player 1 (3333)  Player 2 (1669)
%%%%
100,50 3333
%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(5,3) eCE-Q GG3 Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gametype = 'grid3';
gamma = .9;
normgamma = 1;
teamtype = 'CCe';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid3-CCe-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid3');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simul = Simulation(gridgame(3), 'CCe', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid3-CCe-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 3 Rewards: collision (-0.5), barrier (0        0.25), barrier tie (0.2)
--- Random position at restart
Number of CCe teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid3-CCe-10000-NG-alpha1-eps1-
Iteration 1000:   Games(202): Player 1 (3, 1),  Player  2 (2, 2): 113 to 95
Iteration 2000:   Games(431): Player 1 (2, 1),  Player  2 (2, 2): 230 to 214
Iteration 3000:   Games(648): Player 1 (2, 1),  Player  2 (1, 3): 342 to 328
Iteration 4000:   Games(857): Player 1 (3, 2),  Player  2 (1, 2): 436 to 453
Iteration 5000:   Games(1061): Player 1 (2, 2),  Player  2 (2, 1): 542 to 556
Iteration 6000:   Games(1271): Player 1 (1, 2),  Player  2 (1, 1): 639 to 677
Iteration 7000:   Games(1486): Player 1 (3, 2),  Player  2 (1, 2): 751 to 796
Iteration 8000:   Games(1695): Player 1 (3, 2),  Player  2 (2, 1): 861 to 899
Iteration 9000:   Games(1909): Player 1 (1, 2),  Player  2 (3, 2): 963 to 1020
Iteration 10000:   Games(2147): Player 1 (2, 1),  Player  2 (1, 3): 1094 to 1137
testmode
Total number of games completed: 2147
Final score: Player 1 (1094) Player 2 (1137)
Total game vals: Player 1 (903.85)  Player 2 (941.35)
%%%

simul = Simulation(gridgame(3,0), 'CCe', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid3-CCe-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 3 Rewards: collision (-0.5), barrier (0        0.25), barrier tie (0.2)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid3-CCe-10000-NG-TEST-
Iteration 1000:   Games(333): Player 1 (3, 2),  Player  2 (1, 2): 333 to 333
Iteration 2000:   Games(666): Player 1 (2, 2),  Player  2 (1, 3): 666 to 666
Iteration 3000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 1000 to 1000
Iteration 4000:   Games(1333): Player 1 (3, 2),  Player  2 (1, 2): 1333 to 1333
Iteration 5000:   Games(1666): Player 1 (2, 2),  Player  2 (1, 3): 1666 to 1666
Iteration 6000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 2000 to 2000
Iteration 7000:   Games(2333): Player 1 (3, 2),  Player  2 (1, 2): 2333 to 2333
Iteration 8000:   Games(2666): Player 1 (2, 2),  Player  2 (1, 3): 2666 to 2666
Iteration 9000:   Games(3000): Player 1 (3, 1),  Player  2 (1, 1): 3000 to 3000
Iteration 10000:   Games(3333): Player 1 (2, 1),  Player  2 (1, 2): 3333 to 3333
testmode
Total number of games completed: 3333
Final score: Player 1 (3333) Player 2 (3333)
Total game vals: Player 1 (3910.3)  Player 2 (3907.05)

%%%
117, 117 3333
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(6,1) rCE-Q GG1 Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gametype = 'grid1';
gamma = .9;
normgamma = 1;
teamtype = 'CCr';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid1-CCr-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simul = Simulation(gridgame(1), 'CCr', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid1-CCr-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 1 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Random position at restart
Number of CCr teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid1-CCr-10000-NG-alpha1-eps1-
Iteration 1000:   Games(122): Player 1 (3, 2),  Player  2 (2, 3): 62 to 63
Iteration 2000:   Games(253): Player 1 (2, 2),  Player  2 (3, 2): 129 to 133
Iteration 3000:   Games(376): Player 1 (2, 2),  Player  2 (1, 3): 198 to 191
Iteration 4000:   Games(499): Player 1 (1, 2),  Player  2 (2, 2): 257 to 260
Iteration 5000:   Games(622): Player 1 (2, 1),  Player  2 (2, 3): 313 to 329
Iteration 6000:   Games(742): Player 1 (2, 2),  Player  2 (1, 1): 376 to 393
Iteration 7000:   Games(866): Player 1 (3, 1),  Player  2 (1, 3): 444 to 454
Iteration 8000:   Games(1001): Player 1 (2, 2),  Player  2 (3, 2): 512 to 526
Iteration 9000:   Games(1131): Player 1 (2, 2),  Player  2 (1, 2): 571 to 600
Iteration 10000:   Games(1243): Player 1 (3, 1),  Player  2 (1, 3): 632 to 653
testmode
Total number of games completed: 1243
Final score: Player 1 (632) Player 2 (653)
Total game vals: Player 1 (623.82)  Player 2 (644.82)

%%%

simul = Simulation(gridgame(1,0), 'CCr', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid1-CCr-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 1 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid1-CCr-10000-NG-TEST-
Iteration 1000:   Games(250): Player 1 (3, 1),  Player  2 (1, 1): 250 to 250
Iteration 2000:   Games(500): Player 1 (3, 1),  Player  2 (1, 1): 500 to 500
Iteration 3000:   Games(750): Player 1 (3, 1),  Player  2 (1, 1): 750 to 750
Iteration 4000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 1000 to 1000
Iteration 5000:   Games(1250): Player 1 (3, 1),  Player  2 (1, 1): 1250 to 1250
Iteration 6000:   Games(1500): Player 1 (3, 1),  Player  2 (1, 1): 1500 to 1500
Iteration 7000:   Games(1750): Player 1 (3, 1),  Player  2 (1, 1): 1750 to 1750
Iteration 8000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 2000 to 2000
Iteration 9000:   Games(2250): Player 1 (3, 1),  Player  2 (1, 1): 2250 to 2250
Iteration 10000:   Games(2500): Player 1 (3, 1),  Player  2 (1, 1): 2500 to 2500
testmode
Total number of games completed: 2500
Final score: Player 1 (2500) Player 2 (2500)
Total game vals: Player 1 (2500)  Player 2 (2500)

%%%
100,100 2500
%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(6,2) rCE-Q GG2 Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gametype = 'grid2';
gamma = .9;
normgamma = 1;
teamtype = 'CCr';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid2-CCr-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid2');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simul = Simulation(gridgame(2), 'CCr', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid2-CCr-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Random position at restart
Number of CCr teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid2-CCr-10000-NG-alpha1-eps1-
Iteration 1000:   Games(212): Player 1 (2, 1),  Player  2 (3, 2): 116 to 104
Iteration 2000:   Games(394): Player 1 (3, 2),  Player  2 (2, 2): 215 to 191
Iteration 3000:   Games(554): Player 1 (3, 3),  Player  2 (1, 3): 288 to 283
Iteration 4000:   Games(767): Player 1 (2, 2),  Player  2 (1, 1): 412 to 387
Iteration 5000:   Games(943): Player 1 (1, 2),  Player  2 (2, 1): 498 to 481
Iteration 6000:   Games(1131): Player 1 (3, 2),  Player  2 (2, 1): 594 to 580
Iteration 7000:   Games(1354): Player 1 (1, 3),  Player  2 (3, 2): 703 to 700
Iteration 8000:   Games(1572): Player 1 (2, 1),  Player  2 (1, 1): 819 to 813
Iteration 9000:   Games(1777): Player 1 (3, 1),  Player  2 (2, 2): 923 to 919
Iteration 10000:   Games(1992): Player 1 (1, 1),  Player  2 (2, 1): 1026 to 1043
testmode
Total number of games completed: 1992
Final score: Player 1 (1026) Player 2 (1043)
Total game vals: Player 1 (1017.48)  Player 2 (1034.48)


simul = Simulation(gridgame(2,0), 'CCr', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid2-CCr-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid2-CCr-10000-NG-TEST-
Iteration 1000:   Games(333): Player 1 (2, 1),  Player  2 (1, 2): 165 to 168
Iteration 2000:   Games(666): Player 1 (3, 1),  Player  2 (2, 2): 347 to 319
Iteration 3000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 529 to 471
Iteration 4000:   Games(1333): Player 1 (2, 1),  Player  2 (1, 1): 689 to 644
Iteration 5000:   Games(1666): Player 1 (3, 1),  Player  2 (2, 2): 881 to 785
Iteration 6000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 1049 to 951
Iteration 7000:   Games(2333): Player 1 (2, 1),  Player  2 (1, 2): 1227 to 1106
Iteration 8000:   Games(2666): Player 1 (3, 1),  Player  2 (2, 2): 1398 to 1268
Iteration 9000:   Games(3000): Player 1 (3, 1),  Player  2 (1, 1): 1566 to 1434
Iteration 10000:   Games(3333): Player 1 (2, 1),  Player  2 (1, 2): 1726 to 1607
testmode
Total number of games completed: 3333
Final score: Player 1 (1726) Player 2 (1607)
Total game vals: Player 1 (1726)  Player 2 (1607)

%%%
51.785, 48.215 3333
%%%

%%%%%
ALT
gametype = 'grid2';
gamma = .9;
normgamma = 1;
teamtype = 'CCr';
valiter = 0;
numiter = 100000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid2-CCr-100000-NG-alpha1-eps1.mat');
runTest(simul,100000, 3,'grid2');

%%%%%%%%%%%%%%%%%
simul = Simulation(gridgame(2), 'CCr', params(100000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid2-CCr-100000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Random position at restart
Number of CCr teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 100000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid2-CCr-100000-NG-alpha1-eps1-
Iteration 1000:   Games(195): Player 1 (1, 1),  Player  2 (3, 1): 102 to 102
Iteration 2000:   Games(384): Player 1 (2, 1),  Player  2 (1, 2): 206 to 197
Iteration 3000:   Games(578): Player 1 (1, 1),  Player  2 (1, 2): 318 to 291
Iteration 4000:   Games(787): Player 1 (2, 2),  Player  2 (2, 1): 442 to 388
Iteration 5000:   Games(998): Player 1 (1, 1),  Player  2 (3, 1): 543 to 507
Iteration 6000:   Games(1204): Player 1 (1, 1),  Player  2 (1, 3): 660 to 602
Iteration 7000:   Games(1391): Player 1 (3, 1),  Player  2 (3, 2): 762 to 699
Iteration 8000:   Games(1591): Player 1 (2, 2),  Player  2 (1, 1): 869 to 804
Iteration 9000:   Games(1790): Player 1 (1, 3),  Player  2 (1, 1): 975 to 910
Iteration 10000:   Games(2006): Player 1 (3, 3),  Player  2 (3, 2): 1101 to 1012
Iteration 11000:   Games(2195): Player 1 (1, 2),  Player  2 (3, 2): 1198 to 1110
Iteration 12000:   Games(2409): Player 1 (2, 1),  Player  2 (3, 1): 1319 to 1210
Iteration 13000:   Games(2612): Player 1 (3, 1),  Player  2 (2, 2): 1433 to 1304
Iteration 14000:   Games(2830): Player 1 (1, 3),  Player  2 (1, 1): 1548 to 1415
Iteration 15000:   Games(3034): Player 1 (1, 2),  Player  2 (3, 1): 1646 to 1528
Iteration 16000:   Games(3236): Player 1 (2, 1),  Player  2 (3, 2): 1759 to 1627
Iteration 17000:   Games(3460): Player 1 (2, 2),  Player  2 (1, 2): 1870 to 1751
Iteration 18000:   Games(3653): Player 1 (3, 2),  Player  2 (3, 3): 1975 to 1848
Iteration 19000:   Games(3851): Player 1 (3, 2),  Player  2 (1, 2): 2089 to 1943
Iteration 20000:   Games(4051): Player 1 (3, 2),  Player  2 (2, 2): 2199 to 2040
Iteration 21000:   Games(4260): Player 1 (1, 2),  Player  2 (2, 1): 2312 to 2149
Iteration 22000:   Games(4472): Player 1 (1, 1),  Player  2 (3, 2): 2436 to 2245
Iteration 23000:   Games(4681): Player 1 (2, 2),  Player  2 (1, 1): 2546 to 2353
Iteration 24000:   Games(4885): Player 1 (2, 1),  Player  2 (1, 2): 2655 to 2458
Iteration 25000:   Games(5055): Player 1 (3, 3),  Player  2 (3, 2): 2747 to 2544
Iteration 26000:   Games(5243): Player 1 (2, 1),  Player  2 (1, 1): 2848 to 2638
Iteration 27000:   Games(5454): Player 1 (2, 1),  Player  2 (3, 1): 2967 to 2741
Iteration 28000:   Games(5625): Player 1 (3, 1),  Player  2 (2, 2): 3056 to 2825
Iteration 29000:   Games(5822): Player 1 (2, 2),  Player  2 (3, 2): 3168 to 2918
Iteration 30000:   Games(6020): Player 1 (2, 1),  Player  2 (1, 1): 3268 to 3023
Iteration 31000:   Games(6236): Player 1 (1, 2),  Player  2 (1, 1): 3374 to 3143
Iteration 32000:   Games(6433): Player 1 (2, 1),  Player  2 (1, 3): 3478 to 3246
Iteration 33000:   Games(6630): Player 1 (3, 2),  Player  2 (1, 3): 3577 to 3347
Iteration 34000:   Games(6868): Player 1 (2, 1),  Player  2 (1, 1): 3700 to 3475
Iteration 35000:   Games(7044): Player 1 (2, 2),  Player  2 (2, 1): 3793 to 3568
Iteration 36000:   Games(7243): Player 1 (2, 2),  Player  2 (3, 1): 3894 to 3672
Iteration 37000:   Games(7458): Player 1 (1, 2),  Player  2 (3, 1): 4007 to 3786
Iteration 38000:   Games(7654): Player 1 (1, 3),  Player  2 (3, 2): 4110 to 3888
Iteration 39000:   Games(7870): Player 1 (1, 2),  Player  2 (2, 2): 4226 to 3996
Iteration 40000:   Games(8103): Player 1 (1, 1),  Player  2 (1, 2): 4349 to 4117
Iteration 41000:   Games(8295): Player 1 (2, 1),  Player  2 (3, 2): 4453 to 4211
Iteration 42000:   Games(8508): Player 1 (3, 2),  Player  2 (1, 2): 4570 to 4318
Iteration 43000:   Games(8704): Player 1 (3, 1),  Player  2 (2, 2): 4672 to 4421
Iteration 44000:   Games(8911): Player 1 (1, 2),  Player  2 (2, 1): 4798 to 4511
Iteration 45000:   Games(9121): Player 1 (3, 2),  Player  2 (1, 1): 4905 to 4618
Iteration 46000:   Games(9297): Player 1 (2, 1),  Player  2 (2, 2): 5001 to 4704
Iteration 47000:   Games(9535): Player 1 (1, 2),  Player  2 (3, 3): 5129 to 4822
Iteration 48000:   Games(9701): Player 1 (2, 1),  Player  2 (2, 2): 5216 to 4906
Iteration 49000:   Games(9904): Player 1 (3, 3),  Player  2 (2, 2): 5314 to 5016
Iteration 50000:   Games(10110): Player 1 (3, 1),  Player  2 (2, 2): 5410 to 5131
Iteration 51000:   Games(10322): Player 1 (3, 3),  Player  2 (3, 2): 5518 to 5239
Iteration 52000:   Games(10536): Player 1 (1, 1),  Player  2 (2, 1): 5641 to 5339
Iteration 53000:   Games(10715): Player 1 (1, 1),  Player  2 (2, 1): 5746 to 5419
Iteration 54000:   Games(10921): Player 1 (2, 1),  Player  2 (2, 2): 5858 to 5525
Iteration 55000:   Games(11120): Player 1 (3, 1),  Player  2 (2, 1): 5954 to 5633
Iteration 56000:   Games(11294): Player 1 (1, 3),  Player  2 (2, 1): 6039 to 5724
Iteration 57000:   Games(11494): Player 1 (1, 2),  Player  2 (2, 1): 6144 to 5829
Iteration 58000:   Games(11696): Player 1 (3, 1),  Player  2 (1, 3): 6261 to 5920
Iteration 59000:   Games(11910): Player 1 (2, 2),  Player  2 (1, 2): 6374 to 6026
Iteration 60000:   Games(12096): Player 1 (1, 1),  Player  2 (3, 3): 6462 to 6128
Iteration 61000:   Games(12310): Player 1 (1, 3),  Player  2 (1, 2): 6574 to 6240
Iteration 62000:   Games(12519): Player 1 (3, 1),  Player  2 (2, 2): 6689 to 6340
Iteration 63000:   Games(12724): Player 1 (1, 2),  Player  2 (1, 1): 6810 to 6432
Iteration 64000:   Games(12907): Player 1 (3, 1),  Player  2 (2, 1): 6907 to 6523
Iteration 65000:   Games(13110): Player 1 (2, 1),  Player  2 (2, 2): 7010 to 6629
Iteration 66000:   Games(13315): Player 1 (2, 1),  Player  2 (3, 1): 7108 to 6746
Iteration 67000:   Games(13536): Player 1 (1, 3),  Player  2 (2, 1): 7216 to 6871
Iteration 68000:   Games(13733): Player 1 (3, 1),  Player  2 (2, 1): 7316 to 6977
Iteration 69000:   Games(13928): Player 1 (1, 2),  Player  2 (2, 2): 7416 to 7075
Iteration 70000:   Games(14134): Player 1 (2, 1),  Player  2 (1, 1): 7534 to 7182
Iteration 71000:   Games(14333): Player 1 (1, 2),  Player  2 (2, 1): 7645 to 7279
Iteration 72000:   Games(14537): Player 1 (3, 2),  Player  2 (1, 2): 7747 to 7387
Iteration 73000:   Games(14730): Player 1 (2, 2),  Player  2 (3, 2): 7856 to 7481
Iteration 74000:   Games(14932): Player 1 (2, 1),  Player  2 (1, 1): 7968 to 7574
Iteration 75000:   Games(15142): Player 1 (1, 3),  Player  2 (2, 1): 8071 to 7690
Iteration 76000:   Games(15345): Player 1 (3, 1),  Player  2 (3, 2): 8166 to 7808
Iteration 77000:   Games(15566): Player 1 (3, 1),  Player  2 (1, 1): 8292 to 7913
Iteration 78000:   Games(15771): Player 1 (3, 1),  Player  2 (1, 1): 8395 to 8021
Iteration 79000:   Games(15970): Player 1 (3, 3),  Player  2 (2, 2): 8496 to 8128
Iteration 80000:   Games(16164): Player 1 (3, 3),  Player  2 (2, 1): 8604 to 8225
Iteration 81000:   Games(16352): Player 1 (3, 1),  Player  2 (2, 2): 8689 to 8335
Iteration 82000:   Games(16567): Player 1 (1, 1),  Player  2 (3, 2): 8793 to 8454
Iteration 83000:   Games(16771): Player 1 (3, 1),  Player  2 (1, 1): 8898 to 8563
Iteration 84000:   Games(16995): Player 1 (2, 2),  Player  2 (2, 1): 9011 to 8688
Iteration 85000:   Games(17182): Player 1 (1, 2),  Player  2 (3, 1): 9104 to 8790
Iteration 86000:   Games(17393): Player 1 (3, 1),  Player  2 (2, 2): 9219 to 8892
Iteration 87000:   Games(17606): Player 1 (3, 1),  Player  2 (1, 3): 9328 to 9007
Iteration 88000:   Games(17819): Player 1 (3, 3),  Player  2 (3, 2): 9422 to 9133
Iteration 89000:   Games(18008): Player 1 (3, 1),  Player  2 (1, 3): 9520 to 9232
Iteration 90000:   Games(18216): Player 1 (2, 2),  Player  2 (2, 1): 9625 to 9342
Iteration 91000:   Games(18430): Player 1 (1, 1),  Player  2 (1, 2): 9738 to 9449
Iteration 92000:   Games(18619): Player 1 (3, 2),  Player  2 (1, 2): 9841 to 9546
Iteration 93000:   Games(18829): Player 1 (2, 1),  Player  2 (3, 1): 9941 to 9668
Iteration 94000:   Games(19059): Player 1 (1, 1),  Player  2 (2, 1): 10064 to 9783
Iteration 95000:   Games(19263): Player 1 (3, 2),  Player  2 (2, 2): 10168 to 9890
Iteration 96000:   Games(19456): Player 1 (2, 2),  Player  2 (2, 1): 10277 to 9983
Iteration 97000:   Games(19641): Player 1 (2, 2),  Player  2 (1, 2): 10374 to 10078
Iteration 98000:   Games(19850): Player 1 (2, 1),  Player  2 (2, 2): 10483 to 10186
Iteration 99000:   Games(20044): Player 1 (1, 3),  Player  2 (2, 1): 10580 to 10288
Iteration 100000:   Games(20264): Player 1 (3, 2),  Player  2 (1, 2): 10693 to 10400
testmode
Total number of games completed: 20264
Final score: Player 1 (10693) Player 2 (10400)
Total game vals: Player 1 (10608.5)  Player 2 (10315.5)
Warning: Name is nonexistent or not a directory: ../adaptive/Strats. 
> In path at 110
  In addpath at 87
  In runTest at 13 

runString =

simul = Simulation(gridgame(2,0), 'CCr', params(100000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid2-CCr-100000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 100000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid2-CCr-100000-NG-TEST-
Iteration 1000:   Games(333): Player 1 (3, 1),  Player  2 (2, 1): 176 to 333
Iteration 2000:   Games(666): Player 1 (2, 1),  Player  2 (2, 2): 346 to 666
Iteration 3000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 515 to 1000
Iteration 4000:   Games(1333): Player 1 (3, 2),  Player  2 (2, 1): 682 to 1333
Iteration 5000:   Games(1666): Player 1 (3, 3),  Player  2 (2, 2): 858 to 1666
Iteration 6000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 1014 to 2000
Iteration 7000:   Games(2333): Player 1 (3, 1),  Player  2 (2, 1): 1168 to 2333
Iteration 8000:   Games(2666): Player 1 (3, 3),  Player  2 (2, 2): 1324 to 2666
Iteration 9000:   Games(3000): Player 1 (3, 1),  Player  2 (1, 1): 1489 to 3000
Iteration 10000:   Games(3333): Player 1 (3, 1),  Player  2 (2, 1): 1653 to 3333
Iteration 11000:   Games(3666): Player 1 (3, 3),  Player  2 (2, 2): 1816 to 3666
Iteration 12000:   Games(4000): Player 1 (3, 1),  Player  2 (1, 1): 1971 to 4000
Iteration 13000:   Games(4333): Player 1 (3, 2),  Player  2 (2, 1): 2130 to 4333
Iteration 14000:   Games(4666): Player 1 (2, 1),  Player  2 (2, 2): 2288 to 4666
Iteration 15000:   Games(5000): Player 1 (3, 1),  Player  2 (1, 1): 2458 to 5000
Iteration 16000:   Games(5333): Player 1 (3, 2),  Player  2 (2, 1): 2621 to 5333
Iteration 17000:   Games(5666): Player 1 (2, 1),  Player  2 (2, 2): 2779 to 5666
Iteration 18000:   Games(6000): Player 1 (3, 1),  Player  2 (1, 1): 2959 to 6000
Iteration 19000:   Games(6333): Player 1 (3, 2),  Player  2 (2, 1): 3115 to 6333
Iteration 20000:   Games(6666): Player 1 (3, 3),  Player  2 (2, 2): 3291 to 6666
Iteration 21000:   Games(7000): Player 1 (3, 1),  Player  2 (1, 1): 3461 to 7000
Iteration 22000:   Games(7333): Player 1 (3, 1),  Player  2 (2, 1): 3629 to 7333
Iteration 23000:   Games(7666): Player 1 (2, 1),  Player  2 (2, 2): 3795 to 7666
Iteration 24000:   Games(8000): Player 1 (3, 1),  Player  2 (1, 1): 3986 to 8000
Iteration 25000:   Games(8333): Player 1 (3, 1),  Player  2 (2, 1): 4165 to 8333
Iteration 26000:   Games(8666): Player 1 (3, 3),  Player  2 (2, 2): 4333 to 8666
Iteration 27000:   Games(9000): Player 1 (3, 1),  Player  2 (1, 1): 4484 to 9000
Iteration 28000:   Games(9333): Player 1 (3, 1),  Player  2 (2, 1): 4662 to 9333
Iteration 29000:   Games(9666): Player 1 (3, 3),  Player  2 (2, 2): 4840 to 9666
Iteration 30000:   Games(10000): Player 1 (3, 1),  Player  2 (1, 1): 5021 to 10000
Iteration 31000:   Games(10333): Player 1 (3, 1),  Player  2 (2, 1): 5181 to 10333
Iteration 32000:   Games(10666): Player 1 (3, 3),  Player  2 (2, 2): 5347 to 10666
Iteration 33000:   Games(11000): Player 1 (3, 1),  Player  2 (1, 1): 5511 to 11000
Iteration 34000:   Games(11333): Player 1 (3, 2),  Player  2 (2, 1): 5675 to 11333
Iteration 35000:   Games(11666): Player 1 (3, 3),  Player  2 (2, 2): 5836 to 11666
Iteration 36000:   Games(12000): Player 1 (3, 1),  Player  2 (1, 1): 5999 to 12000
Iteration 37000:   Games(12333): Player 1 (3, 1),  Player  2 (2, 1): 6155 to 12333
Iteration 38000:   Games(12666): Player 1 (2, 1),  Player  2 (2, 2): 6330 to 12666
Iteration 39000:   Games(13000): Player 1 (3, 1),  Player  2 (1, 1): 6508 to 13000
Iteration 40000:   Games(13333): Player 1 (3, 1),  Player  2 (2, 1): 6669 to 13333
Iteration 41000:   Games(13666): Player 1 (2, 1),  Player  2 (2, 2): 6836 to 13666
Iteration 42000:   Games(14000): Player 1 (3, 1),  Player  2 (1, 1): 7001 to 14000
Iteration 43000:   Games(14333): Player 1 (3, 2),  Player  2 (2, 1): 7178 to 14333
Iteration 44000:   Games(14666): Player 1 (2, 1),  Player  2 (2, 2): 7352 to 14666
Iteration 45000:   Games(15000): Player 1 (3, 1),  Player  2 (1, 1): 7516 to 15000
Iteration 46000:   Games(15333): Player 1 (3, 1),  Player  2 (2, 1): 7694 to 15333
Iteration 47000:   Games(15666): Player 1 (2, 1),  Player  2 (2, 2): 7848 to 15666
Iteration 48000:   Games(16000): Player 1 (3, 1),  Player  2 (1, 1): 8022 to 16000
Iteration 49000:   Games(16333): Player 1 (3, 1),  Player  2 (2, 1): 8189 to 16333
Iteration 50000:   Games(16666): Player 1 (3, 3),  Player  2 (2, 2): 8355 to 16666
Iteration 51000:   Games(17000): Player 1 (3, 1),  Player  2 (1, 1): 8518 to 17000
Iteration 52000:   Games(17333): Player 1 (3, 1),  Player  2 (2, 1): 8677 to 17333
Iteration 53000:   Games(17666): Player 1 (2, 1),  Player  2 (2, 2): 8828 to 17666
Iteration 54000:   Games(18000): Player 1 (3, 1),  Player  2 (1, 1): 8988 to 18000
Iteration 55000:   Games(18333): Player 1 (3, 1),  Player  2 (2, 1): 9153 to 18333
Iteration 56000:   Games(18666): Player 1 (2, 1),  Player  2 (2, 2): 9325 to 18666
Iteration 57000:   Games(19000): Player 1 (3, 1),  Player  2 (1, 1): 9485 to 19000
Iteration 58000:   Games(19333): Player 1 (3, 2),  Player  2 (2, 1): 9658 to 19333
Iteration 59000:   Games(19666): Player 1 (3, 3),  Player  2 (2, 2): 9820 to 19666
Iteration 60000:   Games(20000): Player 1 (3, 1),  Player  2 (1, 1): 9981 to 20000
Iteration 61000:   Games(20333): Player 1 (3, 1),  Player  2 (2, 1): 10155 to 20333
Iteration 62000:   Games(20666): Player 1 (2, 1),  Player  2 (2, 2): 10326 to 20666
Iteration 63000:   Games(21000): Player 1 (3, 1),  Player  2 (1, 1): 10496 to 21000
Iteration 64000:   Games(21333): Player 1 (3, 2),  Player  2 (2, 1): 10674 to 21333
Iteration 65000:   Games(21666): Player 1 (3, 3),  Player  2 (2, 2): 10840 to 21666
Iteration 66000:   Games(22000): Player 1 (3, 1),  Player  2 (1, 1): 11002 to 22000
Iteration 67000:   Games(22333): Player 1 (3, 1),  Player  2 (2, 1): 11181 to 22333
Iteration 68000:   Games(22666): Player 1 (3, 3),  Player  2 (2, 2): 11355 to 22666
Iteration 69000:   Games(23000): Player 1 (3, 1),  Player  2 (1, 1): 11513 to 23000
Iteration 70000:   Games(23333): Player 1 (3, 1),  Player  2 (2, 1): 11690 to 23333
Iteration 71000:   Games(23666): Player 1 (3, 3),  Player  2 (2, 2): 11853 to 23666
Iteration 72000:   Games(24000): Player 1 (3, 1),  Player  2 (1, 1): 12013 to 24000
Iteration 73000:   Games(24333): Player 1 (3, 1),  Player  2 (2, 1): 12207 to 24333
Iteration 74000:   Games(24666): Player 1 (2, 1),  Player  2 (2, 2): 12370 to 24666
Iteration 75000:   Games(25000): Player 1 (3, 1),  Player  2 (1, 1): 12547 to 25000
Iteration 76000:   Games(25333): Player 1 (3, 2),  Player  2 (2, 1): 12730 to 25333
Iteration 77000:   Games(25666): Player 1 (3, 3),  Player  2 (2, 2): 12907 to 25666
Iteration 78000:   Games(26000): Player 1 (3, 1),  Player  2 (1, 1): 13070 to 26000
Iteration 79000:   Games(26333): Player 1 (3, 1),  Player  2 (2, 1): 13259 to 26333
Iteration 80000:   Games(26666): Player 1 (2, 1),  Player  2 (2, 2): 13414 to 26666
Iteration 81000:   Games(27000): Player 1 (3, 1),  Player  2 (1, 1): 13599 to 27000
Iteration 82000:   Games(27333): Player 1 (3, 1),  Player  2 (2, 1): 13766 to 27333
Iteration 83000:   Games(27666): Player 1 (2, 1),  Player  2 (2, 2): 13929 to 27666
Iteration 84000:   Games(28000): Player 1 (3, 1),  Player  2 (1, 1): 14089 to 28000
Iteration 85000:   Games(28333): Player 1 (3, 1),  Player  2 (2, 1): 14262 to 28333
Iteration 86000:   Games(28666): Player 1 (3, 3),  Player  2 (2, 2): 14439 to 28666
Iteration 87000:   Games(29000): Player 1 (3, 1),  Player  2 (1, 1): 14610 to 29000
Iteration 88000:   Games(29333): Player 1 (3, 1),  Player  2 (2, 1): 14769 to 29333
Iteration 89000:   Games(29666): Player 1 (2, 1),  Player  2 (2, 2): 14934 to 29666
Iteration 90000:   Games(30000): Player 1 (3, 1),  Player  2 (1, 1): 15083 to 30000
Iteration 91000:   Games(30333): Player 1 (3, 1),  Player  2 (2, 1): 15249 to 30333
Iteration 92000:   Games(30666): Player 1 (3, 3),  Player  2 (2, 2): 15406 to 30666
Iteration 93000:   Games(31000): Player 1 (3, 1),  Player  2 (1, 1): 15567 to 31000
Iteration 94000:   Games(31333): Player 1 (3, 2),  Player  2 (2, 1): 15731 to 31333
Iteration 95000:   Games(31666): Player 1 (2, 1),  Player  2 (2, 2): 15888 to 31666
Iteration 96000:   Games(32000): Player 1 (3, 1),  Player  2 (1, 1): 16040 to 32000
Iteration 97000:   Games(32333): Player 1 (3, 1),  Player  2 (2, 1): 16218 to 32333
Iteration 98000:   Games(32666): Player 1 (3, 3),  Player  2 (2, 2): 16375 to 32666
Iteration 99000:   Games(33000): Player 1 (3, 1),  Player  2 (1, 1): 16544 to 33000
Iteration 100000:   Games(33333): Player 1 (3, 1),  Player  2 (2, 1): 16720 to 33333
testmode
Total number of games completed: 33333
Final score: Player 1 (16720) Player 2 (33333)
Total game vals: Player 1 (16720)  Player 2 (33333)

%%%%%
%CORRECT command runTest(simul,10000, 3,'grid2');
%%%%%

simul = Simulation(gridgame(2,0), 'CCr', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid2-CCr-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid2-CCr-10000-NG-TEST-
Iteration 1000:   Games(333): Player 1 (3, 2),  Player  2 (2, 1): 156 to 333
Iteration 2000:   Games(666): Player 1 (2, 1),  Player  2 (2, 2): 302 to 666
Iteration 3000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 484 to 1000
Iteration 4000:   Games(1333): Player 1 (3, 2),  Player  2 (2, 1): 642 to 1333
Iteration 5000:   Games(1666): Player 1 (3, 3),  Player  2 (2, 2): 784 to 1666
Iteration 6000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 958 to 2000
Iteration 7000:   Games(2333): Player 1 (3, 1),  Player  2 (2, 1): 1116 to 2333
Iteration 8000:   Games(2666): Player 1 (2, 1),  Player  2 (2, 2): 1287 to 2666
Iteration 9000:   Games(3000): Player 1 (3, 1),  Player  2 (1, 1): 1459 to 3000
Iteration 10000:   Games(3333): Player 1 (3, 2),  Player  2 (2, 1): 1628 to 3333
testmode
Total number of games completed: 3333
Final score: Player 1 (1628) Player 2 (3333)
Total game vals: Player 1 (1628)  Player 2 (3333)
%%%%
49, 100 3333
%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(6,3) rCE-Q GG3 Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gametype = 'grid3';
gamma = .9;
normgamma = 1;
teamtype = 'CCr';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid3-CCr-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simul = Simulation(gridgame(3), 'CCr', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid3-CCr-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 3 Rewards: collision (-0.5), barrier (0        0.25), barrier tie (0.2)
--- Random position at restart
Number of CCr teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid3-CCr-10000-NG-alpha1-eps1-
Iteration 1000:   Games(233): Player 1 (2, 2),  Player  2 (1, 1): 121 to 117
Iteration 2000:   Games(440): Player 1 (3, 2),  Player  2 (3, 3): 229 to 222
Iteration 3000:   Games(681): Player 1 (1, 1),  Player  2 (1, 3): 369 to 333
Iteration 4000:   Games(902): Player 1 (1, 2),  Player  2 (3, 2): 480 to 457
Iteration 5000:   Games(1107): Player 1 (2, 1),  Player  2 (1, 3): 582 to 568
Iteration 6000:   Games(1310): Player 1 (3, 2),  Player  2 (1, 2): 679 to 684
Iteration 7000:   Games(1539): Player 1 (1, 2),  Player  2 (2, 2): 801 to 801
Iteration 8000:   Games(1776): Player 1 (2, 2),  Player  2 (1, 3): 925 to 924
Iteration 9000:   Games(1974): Player 1 (3, 3),  Player  2 (2, 2): 1029 to 1025
Iteration 10000:   Games(2189): Player 1 (1, 3),  Player  2 (2, 2): 1152 to 1131
testmode
Total number of games completed: 2189
Final score: Player 1 (1152) Player 2 (1131)
Total game vals: Player 1 (961.1)  Player 2 (928.85)


simul = Simulation(gridgame(3,0), 'CCr', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid3-CCr-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 3 Rewards: collision (-0.5), barrier (0        0.25), barrier tie (0.2)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid3-CCr-10000-NG-TEST-
Iteration 1000:   Games(333): Player 1 (3, 2),  Player  2 (2, 1): 333 to 333
Iteration 2000:   Games(666): Player 1 (3, 3),  Player  2 (2, 2): 666 to 666
Iteration 3000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 1000 to 1000
Iteration 4000:   Games(1333): Player 1 (3, 2),  Player  2 (2, 1): 1333 to 1333
Iteration 5000:   Games(1666): Player 1 (3, 3),  Player  2 (2, 2): 1666 to 1666
Iteration 6000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 2000 to 2000
Iteration 7000:   Games(2333): Player 1 (3, 2),  Player  2 (2, 1): 2333 to 2333
Iteration 8000:   Games(2666): Player 1 (3, 3),  Player  2 (2, 2): 2666 to 2666
Iteration 9000:   Games(3000): Player 1 (3, 1),  Player  2 (1, 1): 3000 to 3000
Iteration 10000:   Games(3333): Player 1 (3, 2),  Player  2 (2, 1): 3333 to 3333
testmode
Total number of games completed: 3333
Final score: Player 1 (3333) Player 2 (3333)
Total game vals: Player 1 (3333)  Player 2 (4166.5)

%%%%
% 100, 125 3333
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(7,1) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gametype = 'grid1';
gamma = .9;
normgamma = 1;
teamtype = 'CCl';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid1-CCr-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid1');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simul = Simulation(gridgame(1), 'CCl', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid1-CCl-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 1 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Random position at restart
Number of CCl teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid1-CCl-10000-NG-alpha1-eps1-
Iteration 1000:   Games(151): Player 1 (2, 2),  Player  2 (2, 1): 73 to 81
Iteration 2000:   Games(285): Player 1 (2, 3),  Player  2 (3, 1): 142 to 152
Iteration 3000:   Games(418): Player 1 (2, 1),  Player  2 (3, 2): 208 to 224
Iteration 4000:   Games(542): Player 1 (3, 2),  Player  2 (3, 1): 266 to 292
Iteration 5000:   Games(673): Player 1 (2, 3),  Player  2 (2, 2): 328 to 366
Iteration 6000:   Games(795): Player 1 (3, 2),  Player  2 (1, 1): 393 to 423
Iteration 7000:   Games(911): Player 1 (1, 1),  Player  2 (3, 2): 456 to 478
Iteration 8000:   Games(1037): Player 1 (3, 2),  Player  2 (1, 3): 517 to 547
Iteration 9000:   Games(1172): Player 1 (3, 1),  Player  2 (2, 1): 580 to 622
Iteration 10000:   Games(1319): Player 1 (1, 1),  Player  2 (2, 2): 654 to 700
testmode
Total number of games completed: 1319
Final score: Player 1 (654) Player 2 (700)
Total game vals: Player 1 (645.25)  Player 2 (691.25)


simul = Simulation(gridgame(1,0), 'CCr', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid1-CCr-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 1 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid1-CCr-10000-NG-TEST-
Iteration 1000:   Games(250): Player 1 (3, 1),  Player  2 (1, 1): 250 to 250
Iteration 2000:   Games(500): Player 1 (3, 1),  Player  2 (1, 1): 500 to 500
Iteration 3000:   Games(750): Player 1 (3, 1),  Player  2 (1, 1): 750 to 750
Iteration 4000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 1000 to 1000
Iteration 5000:   Games(1250): Player 1 (3, 1),  Player  2 (1, 1): 1250 to 1250
Iteration 6000:   Games(1500): Player 1 (3, 1),  Player  2 (1, 1): 1500 to 1500
Iteration 7000:   Games(1750): Player 1 (3, 1),  Player  2 (1, 1): 1750 to 1750
Iteration 8000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 2000 to 2000
Iteration 9000:   Games(2250): Player 1 (3, 1),  Player  2 (1, 1): 2250 to 2250
Iteration 10000:   Games(2500): Player 1 (3, 1),  Player  2 (1, 1): 2500 to 2500
testmode
Total number of games completed: 2500
Final score: Player 1 (2500) Player 2 (2500)
Total game vals: Player 1 (2500)  Player 2 (2500)


%%%%
% 100, 100 2500
%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(7,2) lCE-Q GG2 Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gametype = 'grid2';
gamma = .9;
normgamma = 1;
teamtype = 'CCl';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid2-CCl-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

simul = Simulation(gridgame(2), 'CCl', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid2-CCl-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Random position at restart
Number of CCl teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid2-CCl-10000-NG-alpha1-eps1-
Iteration 1000:   Games(207): Player 1 (1, 3),  Player  2 (2, 2): 105 to 104
Iteration 2000:   Games(417): Player 1 (2, 1),  Player  2 (2, 2): 208 to 220
Iteration 3000:   Games(614): Player 1 (1, 2),  Player  2 (3, 2): 312 to 320
Iteration 4000:   Games(821): Player 1 (3, 3),  Player  2 (3, 1): 406 to 438
Iteration 5000:   Games(1039): Player 1 (3, 1),  Player  2 (1, 2): 508 to 562
Iteration 6000:   Games(1245): Player 1 (2, 2),  Player  2 (2, 1): 620 to 663
Iteration 7000:   Games(1441): Player 1 (1, 2),  Player  2 (2, 2): 727 to 764
Iteration 8000:   Games(1658): Player 1 (2, 1),  Player  2 (1, 1): 830 to 887
Iteration 9000:   Games(1868): Player 1 (1, 3),  Player  2 (2, 1): 939 to 995
Iteration 10000:   Games(2073): Player 1 (2, 2),  Player  2 (1, 2): 1047 to 1100
testmode
Total number of games completed: 2073
Final score: Player 1 (1047) Player 2 (1100)
Total game vals: Player 1 (1038.82)  Player 2 (1091.82)
Warning: Name is nonexistent or not a directory: ../adaptive/Strats. 
> In path at 110
  In addpath at 87
  In runTest at 13 

runString =

simul = Simulation(gridgame(2,0), 'CCr', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid2-CCr-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid2-CCr-10000-NG-TEST-
Iteration 1000:   Games(333): Player 1 (2, 1),  Player  2 (1, 2): 170 to 163
Iteration 2000:   Games(666): Player 1 (3, 1),  Player  2 (2, 2): 353 to 313
Iteration 3000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 536 to 464
Iteration 4000:   Games(1333): Player 1 (2, 1),  Player  2 (1, 1): 708 to 625
Iteration 5000:   Games(1666): Player 1 (2, 2),  Player  2 (2, 1): 862 to 804
Iteration 6000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 1035 to 965
Iteration 7000:   Games(2333): Player 1 (2, 1),  Player  2 (1, 1): 1194 to 1139
Iteration 8000:   Games(2666): Player 1 (2, 2),  Player  2 (2, 1): 1365 to 1301
Iteration 9000:   Games(3000): Player 1 (3, 1),  Player  2 (1, 1): 1539 to 1461
Iteration 10000:   Games(3333): Player 1 (2, 1),  Player  2 (1, 2): 1710 to 1623
testmode
Total number of games completed: 3333
Final score: Player 1 (1710) Player 2 (1623)
Total game vals: Player 1 (1710)  Player 2 (1623)

%%%%
%ALT
%%%%
gametype = 'grid2';
gamma = .9;
normgamma = 1;
teamtype = 'CCl';
valiter = 0;
numiter = 100000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid2-CCl-100000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid2');

%%%RESULTS of Alt

simul = Simulation(gridgame(2,0), 'CCr', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid2-CCr-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 2 Rewards: collision (-0.01), barrier (0  0), barrier tie (0)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid2-CCr-10000-NG-TEST-
Iteration 1000:   Games(333): Player 1 (3, 1),  Player  2 (2, 1): 158 to 333
Iteration 2000:   Games(666): Player 1 (3, 3),  Player  2 (2, 2): 344 to 666
Iteration 3000:   Games(1000): Player 1 (3, 1),  Player  2 (1, 1): 530 to 1000
Iteration 4000:   Games(1333): Player 1 (3, 2),  Player  2 (2, 1): 710 to 1333
Iteration 5000:   Games(1666): Player 1 (2, 1),  Player  2 (2, 2): 896 to 1666
Iteration 6000:   Games(2000): Player 1 (3, 1),  Player  2 (1, 1): 1064 to 2000
Iteration 7000:   Games(2333): Player 1 (3, 2),  Player  2 (2, 1): 1223 to 2333
Iteration 8000:   Games(2666): Player 1 (3, 3),  Player  2 (2, 2): 1383 to 2666
Iteration 9000:   Games(3000): Player 1 (3, 1),  Player  2 (1, 1): 1547 to 3000
Iteration 10000:   Games(3333): Player 1 (3, 1),  Player  2 (2, 1): 1725 to 3333
testmode
Total number of games completed: 3333
Final score: Player 1 (1725) Player 2 (3333)
Total game vals: Player 1 (1725)  Player 2 (3333)

%%%%
%51, 100 3333
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(7,3) lCE-Q GG3 Commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gametype = 'grid3';
gamma = .9;
normgamma = 1;
teamtype = 'CCl';
valiter = 0;
numiter = 10000;
[teams,game,oName] = runExp(gametype,teamtype,numiter,3,1,1,gamma,valiter,normgamma,'long');
load('experiments/grid/grid3-CCl-10000-NG-alpha1-eps1.mat');
runTest(simul,10000, 3,'grid3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

simul = Simulation(gridgame(3), 'CCl', params(10000, 1,[1],0.9,0), [], 3, 'experiments/grid/grid3-CCl-10000-NG-alpha1-eps1-', 'train', 2, 1, 'long');

Grid game 3 Rewards: collision (-0.5), barrier (0        0.25), barrier tie (0.2)
--- Random position at restart
Number of CCl teams = 2
AlphaType: Fixed value (1)
ExploreType: Fixed value (1)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
CorrEQ gamma setting: GammaNorm
DEBUG set to 3
Q-learning simulation
Exploration is random
Simulation history file: experiments/grid/grid3-CCl-10000-NG-alpha1-eps1-
Iteration 1000:   Games(214): Player 1 (2, 2),  Player  2 (3, 2): 100 to 119
Iteration 2000:   Games(410): Player 1 (1, 2),  Player  2 (3, 2): 198 to 225
Iteration 3000:   Games(631): Player 1 (2, 1),  Player  2 (3, 1): 301 to 352
Iteration 4000:   Games(865): Player 1 (1, 2),  Player  2 (3, 2): 433 to 462
Iteration 5000:   Games(1093): Player 1 (3, 2),  Player  2 (2, 2): 553 to 584
Iteration 6000:   Games(1291): Player 1 (2, 1),  Player  2 (1, 3): 657 to 685
Iteration 7000:   Games(1520): Player 1 (3, 2),  Player  2 (3, 3): 772 to 807
Iteration 8000:   Games(1729): Player 1 (2, 1),  Player  2 (1, 2): 894 to 900
Iteration 9000:   Games(1935): Player 1 (2, 2),  Player  2 (3, 1): 1002 to 1005
Iteration 10000:   Games(2148): Player 1 (3, 1),  Player  2 (2, 1): 1103 to 1123
testmode
Total number of games completed: 2148
Final score: Player 1 (1103) Player 2 (1123)
Total game vals: Player 1 (880.95)  Player 2 (899.7)
Warning: Name is nonexistent or not a directory: ../adaptive/Strats. 
> In path at 110
  In addpath at 87
  In runTest at 13 

runString =

simul = Simulation(gridgame(3,0), 'CCl', params(10000, 0, 0, 0.9,0), trainTeams, 3, 'experiments/grid/grid3-CCl-10000-NG-TEST-', 'test', 2, 1, 'long', 0);

Grid game 3 Rewards: collision (-0.5), barrier (0        0.25), barrier tie (0.2)
--- Fixed start position at restart
Number of CorrEQ teams = 2
AlphaType: Fixed value (0)
ExploreType: Fixed value (0)
PerturbEps: 0
Gamma: 0.9
Playing game for 10000 iterations
Testing
DEBUG set to 3
Q-learning simulation
Simulation history file: experiments/grid/grid3-CCl-10000-NG-TEST-
Iteration 1000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 2000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 3000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 4000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 5000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 6000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 7000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 8000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 9000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
Iteration 10000:   Games(0): Player 1 (3, 1),  Player  2 (1, 1): 0 to 0
testmode
Total number of games completed: 0
Final score: Player 1 (0) Player 2 (0)
Total game vals: Player 1 (-2500)  Player 2 (-2500)
