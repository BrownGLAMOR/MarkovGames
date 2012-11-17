%-----------------------------------------------------------------------
% funciton: runPlotTest.m
%       run and plot testing results
%
%-----------------------------------------------------------------------
function runPlotTest(dataset, location, testNumIter, withRegret, withQ)
% loadExp     % preloads all the classes

if nargin < 3
    testNumIter = 10000;
end
if nargin < 4
    withRegret = 1;
end
if nargin < 5
    withQ = 1;
end

for i = 1:length(dataset)
    dashpos = strfind(dataset{i},'-');
    gtype = dataset{i}(1:dashpos(1)-1);
    load([location,dataset{i},'.mat']);
    [t,g,oName,gameVals] = runTest(simul,testNumIter,4,gtype);
    scores = get(g,'Score');
    nGames = get(g,'GamesPlayed');
    oFID = fopen([oName '.scores'], 'w+');
    if (nGames == 0)
        fprintf(oFID, '<1:   %15f/1     %15f/1\n', gameVals(1),gameVals(2));
    else
        fprintf(oFID, '%d:   %15f     %15f\n', nGames, gameVals(1)/nGames,gameVals(2)/nGames);
    end
    fclose(oFID);
    dashpos = strfind(oName,'/');
    plotSet{1} = oName(dashpos(end)+1:end);
    if (strncmp(gtype, 'grid', 4) == 1)
        type = 'grid';
    elseif (strncmp(gtype, 'soccer', 6) == 1)
        type = 'soccer';
    else
        type = 'other';
    end
    %plotRes(plotSet,type, withRegret, withQ);
end
