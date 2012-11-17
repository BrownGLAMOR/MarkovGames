%-----------------------------------------------------------------------
% Funciton: runExp
%       [teams, game, outFile] = runExp(gameType, teamType, numIter, debugLevel, ...
%                              alpha, epsilon, gamma, valIter, normGamma,
%                              policyHist, perturbEps)
%
%   - normGamma uses (gamma*X + (1-gamma)*newX)
%   - policyHist stores policy values in the qhist tables (Nash,C-EQ, etc)
%   - perturbEps - epsilon value controls how often to use a random
%                  policy to compute Value (only works for cEQ)
%-----------------------------------------------------------------------
function [teams, game, outputFileName] = runExp(gameType, teamType, numIter, ...
                        debugLevel, alpha, epsilon, gamma, valIter, normGamma, policyHist, ...
                        perturbEps)

addpath ../adaptive
addpath ../adaptive/Strats

if nargin < 7
    gamma = .9;
end
if nargin < 5
    alpha = [.1, .001];
end
if nargin < 4
    debugLevel = 2;
end
if nargin < 8
    valIter = 0
end
if nargin < 9
    normGamma = 0;
end
if nargin < 10
    policyHist = 'none';
end
if nargin < 11
    perturbEps = 0;
end

nTeams = 2;
switch gameType
    case 'grid1'
        outputFileName = 'experiments/grid/grid1-';
        gameString = 'gridgame(1)';
    case 'grid2'
        outputFileName = 'experiments/grid/grid2-';
        gameString = 'gridgame(2)';
    case 'grid3'
        outputFileName = 'experiments/grid/grid3-';
        gameString = 'gridgame(3)';
    case 'soccer22ns'
        outputFileName = 'experiments/soccer/soccer22ns-';
        gameString = 'soccer(2,2,1,0)';
    case 'soccer22'
        outputFileName = 'experiments/soccer/soccer22-';
        gameString = 'soccer(2,2,1,1)';
    case 'soccer22+'
        outputFileName = 'experiments/soccer/soccer+22-';
        gameString = 'soccer(2,2,0,1)';
    case 'soccer43'
        outputFileName = 'experiments/soccer/soccer43-';
        gameString = 'soccer(4,3,1,1)';
    case 'soccer45'
        outputFileName = 'experiments/soccer/soccer45-';
        gameString = 'soccer(4,5,1,1)';
    case 'soccer45+'
        outputFileName = 'experiments/soccer/soccer+45-';
        gameString = 'soccer(4,5,0,1)';
    case 'SFBP'
        outputFileName = 'experiments/SFBP/SFBP-';
        gameString = 'SFBP(100,60)';
        nTeams = 100;
    case 'SFBP5'
        outputFileName = 'experiments/SFBP/SFBP5-';
        gameString = 'SFBP(5,3)';
        nTeams = 5;
    case 'SFBP10'
        outputFileName = 'experiments/SFBP/SFBP10-';
        gameString = 'SFBP(10,6)';
        nTeams = 10;
    case 'SFBPi'
        outputFileName = 'experiments/SFBP/SFBPi-';
        gameString = 'SFBP(100,60,1)';
        nTeams = 100;
    case 'SFBPi5'
        outputFileName = 'experiments/SFBP/SFBPi5-';
        gameString = 'SFBP(5,3,1)';
        nTeams = 5;
    case 'SFBPw'
        outputFileName = 'experiments/SFBP/SFBPw-';
        gameString = 'SFBP(100,60,1,''waiting'')';
        nTeams = 100;
    case 'SFBPw5'
        outputFileName = 'experiments/SFBP/SFBPw5-';
        gameString = 'SFBP(5,3,1,''waiting'')';
        nTeams = 5;
    case 'SFBPc'
        outputFileName = 'experiments/SFBP/SFBPc-';
        gameString = 'SFBP(100,60,0,''crowdMarkov'')';
        nTeams = 100;
    case 'SFBPc5'
        outputFileName = 'experiments/SFBP/SFBPc5-';
        gameString = 'SFBP(5,3,0,''crowdMarkov'')';
        nTeams = 5;
    case 'SFBPf'
        outputFileName = 'experiments/SFBP/SFBPf-';
        gameString = 'SFBP(100,60,0,''standard'', .4)';
        nTeams = 100;
    case 'SFBPf5'
        outputFileName = 'experiments/SFBP/SFBPf5-';
        gameString = 'SFBP(5,3,0,''standard'', .4)';
        nTeams = 5;
    case 'Exist'
        outputFileName = 'experiments/Exist/Exist-';
        gameString = 'Exist(''original'')';
    case 'UExist'
        outputFileName = 'experiments/Exist/UExist-';
        gameString = 'Exist(''uniqueEQ'')';
    case 'Chicken'
        outputFileName = 'experiments/Repeated/Chicken-';
        gameString = 'Repeated(''Chicken'',''repeated'')';
    case 'SChicken'
        outputFileName = 'experiments/Repeated/SChicken-';
        gameString = 'Repeated(''Chicken'',''single'')';
    case 'Coordination'
        outputFileName = 'experiments/Repeated/Coordination-';
        gameString = 'Repeated(''Coordination'',''repeated'')';
    case 'Sexes'
        outputFileName = 'experiments/Repeated/Sexes-';
        gameString = 'Repeated(''Sexes'',''repeated'')';
    case 'Pennies'
        outputFileName = 'experiments/Repeated/Pennies-';
        gameString = 'Repeated(''Pennies'',''repeated'')';
    otherwise
        error(['Unknown game type: ', gameType]);
end
outputFileName = [outputFileName, teamType, '-', int2str(numIter)];
if valIter
    outputFileName = [outputFileName, '-VI'];
end
if normGamma
    outputFileName = [outputFileName '-NG'];
else
    normGamma = 0;
end
if nargin > 4
    if isempty(alpha)
        outputFileName = [outputFileName, '-uniformAlpha'];
    else
        outputFileName = [outputFileName, '-alpha', num2str(alpha(1))];
        if length(alpha) > 1
            outputFileName = [outputFileName, num2str(alpha(2))];
            if length(alpha) > 2
                outputFileName = [outputFileName, '-', num2str(alpha(3))];
            end
        end
    end
end
if nargin > 5
    if isempty(epsilon)
        outputFileName = [outputFileName, '-uniformEps'];
    else
        outputFileName = [outputFileName, '-eps', num2str(epsilon(1))];
        if length(epsilon) > 1
            outputFileName = [outputFileName, num2str(epsilon(2))];
        end
        if perturbEps > 0
            outputFileName = [outputFileName, '-pturb', num2str(perturbEps)];
        end
    end
end
%outputFileName = [outputFileName, '-gamma', num2str(gamma)];
outputFileName = strrep(outputFileName, '0.','_');
if nargin < 6
    if strcmp('QQ', teamType) == 1
        epsilon = .01;
    elseif ((strcmp(teamType,'NHNH')) == 1) | ...
      ((strcmp(teamType,'NH')) == 1) | ...
      ((strcmp(teamType,'NPEACE')) == 1) | ...
      ((strcmp(teamType,'NWAR')) == 1) | ...
      ((strcmp(teamType,'NHMC')) == 1) | ...
      ((strcmp(teamType,'EPS2')) == 1) | ...
      ((strcmp(teamType,'EPS1')) == 1) | ...
      ((strcmp(teamType,'ONIH')) == 1) |...
      ((strcmp(teamType,'ONIHMC')) == 1) |...
      ((strcmp(teamType,'ONIWAR')) == 1) |...
      ((strcmp(teamType,'ONIPEACE')) == 1) 
        epsilon = 0;
    elseif strcmp(teamType,'HH') == 1 | strcmp(teamType, 'HMS') == 1
        epsilon = .01;
    else
        epsilon = 1;
    end
end
if strcmp('QQ', teamType) == 1
    teamType = 'QQNB';
end
if length(epsilon) > 1
    epsStr = ['[',num2str(epsilon(1)), ',', num2str(epsilon(2)), ']'];
else
    epsStr = num2str(epsilon);
end

runString = ['simul = Simulation(', gameString, ', ''', teamType, ''', params(', int2str(numIter), ', ', epsStr, ','];
if isempty(alpha)
    runString = [runString,'[]'];
else
    runString = [runString,'[', num2str(alpha(1))];
    if length(alpha) > 1
        runString = [runString, ',', num2str(alpha(2))];
        if length(alpha) > 2
            runString = [runString, ',', num2str(alpha(3))];
        end
    end
    runString = [runString, ']'];
end
runString = [runString, ',',  num2str(gamma), ',', num2str(perturbEps), '), [], ', ...
             num2str(debugLevel), ', ''', outputFileName, '-'', ''train'', ', ...
             num2str(nTeams), ', ',num2str(normGamma), ', ''', policyHist, ''');'];
runString
outputFileName;

eval(runString);

if valIter
    simul = olvaliter(simul);
else
    simul = simulate(simul);
end
% save after simulation has run...
saveStr = ['save ', outputFileName];
eval(saveStr);

teams = get(simul, 'Teams');
game = get(simul, 'Game');
