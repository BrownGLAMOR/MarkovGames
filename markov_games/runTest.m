%-----------------------------------------------------------------------
% Funciton: runTest
%       run Testing for previously trained run algorithms 
%       (uses train mode with alpha = 0)
%
%-----------------------------------------------------------------------
function [teams, game, outputFileName, totalGameVals] = runTest(trainSimul, numIter, debugLevel, gameType)

%function [teams, game, outputFileName] = runExp(gameType, teamType, numIter, ...
%                        debugLevel, alpha, epsilon, gamma, valIter, normGamma, policyHist, ...
%                        perturbEps)
addpath ../adaptive
addpath ../adaptive/Strats

if nargin < 3
    debugLevel = 3;
end
if nargin < 4
    gameType = 'SAVEDGAME';
end

alpha = 0;
epsilon = 0;
valIter = 0;    % never test with value-iteration
perturbEps = 0;

% Retrieve setting from training phase
teamType        = get(trainSimul,'TeamType');
normGammaStr    = get(trainSimul,'NormGamma');
policyHist      = get(trainSimul,'PolicyHist');
trainParams     = get(trainSimul,'ParamSet');
gamma           = get(trainParams,'Gamma');
trainGame       = get(trainSimul,'Game');
trainTeams      = get(trainSimul,'Teams');
isAdaptive      = get(trainSimul,'IsAdaptiveAlg');

switch normGammaStr
case 'NoGammaNorm'
    normGamma = 0;
case 'GammaNorm'
    normGamma = 1;
end

% perturbEps = get(trainParams,'PerturbEps');

nTeams = 2;
switch gameType
    case {'SAVEDGAME','savedgame','saved','train'}
        oldHistFile = get(trainSimul,'HistFile');
        outputFileName = oldHistFile(1:strfind(oldHistFile, teamType) - 1);
        gameString = 'trainGame';
    case 'grid1'
        outputFileName = 'experiments/grid/grid1-';
        gameString = 'gridgame(1,0)';
    case 'grid2'
        outputFileName = 'experiments/grid/grid2-';
        gameString = 'gridgame(2,0)';
    case 'grid3'
        outputFileName = 'experiments/grid/grid3-';
        gameString = 'gridgame(3,0)';
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
if normGamma
    outputFileName = [outputFileName '-NG'];
else
    normGamma = 0;
end
outputFileName = [outputFileName '-TEST'];
outputFileName = strrep(outputFileName, '0.','_');

if strcmp('QQ', teamType) == 1
    teamType = 'QQNB';
end
switch teamType
case {'QQNB','QQND','MM','FF'}
    policyHist = 'short';
otherwise
    policyHist = 'long';
end

if isAdaptive
    runString = ['simul = Simulation(', gameString, ', ''', teamType, ''', params(', int2str(numIter), ', 0, 0, ', ...
                 num2str(gamma), ',', num2str(perturbEps), '), trainTeams, ', ...
                 num2str(debugLevel), ', ''', outputFileName, '-'', ''train'', ', ...
                 num2str(nTeams), ', ',num2str(normGamma), ', ''', policyHist, ''', ', num2str(isAdaptive),');'];
else
    runString = ['simul = Simulation(', gameString, ', ''', teamType, ''', params(', int2str(numIter), ', 0, 0, ', ...
                 num2str(gamma), ',', num2str(perturbEps), '), trainTeams, ', ...
                 num2str(debugLevel), ', ''', outputFileName, '-'', ''test'', ', ...
                 num2str(nTeams), ', ',num2str(normGamma), ', ''', policyHist, ''', ', num2str(isAdaptive),');'];
end
runString
% outputFileName;

%evalin('base',runString);
eval(runString);

[simul, totalGameVals] = simulate(simul);

% save after simulation has run...
saveStr = ['save ', outputFileName];
eval(saveStr);

teams = get(simul, 'Teams');
game = get(simul, 'Game');
