%-----------------------------------------------------------------------
% funciton: gentables
%       generations q-values table for grid or soccer games at an interesting state 
%       grid games - use the start state 3,1,1,1
%       soccer 2x2 - use 2,3,2,2,2
%
%-----------------------------------------------------------------------
function gentables(location, gameList, teamList, numIter, theGameType, gammaType, pEps, expStr)

if nargin < 4
    numIter = 1000;
end
if nargin < 5
    theGameType = 'grid';
end
if nargin < 6
    gammaType = 'regular';
end
if nargin < 7
    pEps = 0;
end
if nargin < 8
    expStr = '-alpha1-eps1';
end

disp(['game type: ' theGameType]);

valiter_str = '';
numAction = 2;

switch gammaType
case {'regular','nonormgamma','noNormGamma'}
    ngStr = '';
case {'normgamma','normGamma','norm'}
    ngStr = '-NG'
end

switch theGameType
case {'grid', 'Grid', 'grrr'}
    disp(['Getting data for GRID game']);
    stateToFind = {3,1,1,1};
case {'soccer','Soccer','soc'}
    disp(['Getting data for SOCCER game']);
    stateToFind = {2,3,2,2,1};
    %stateToFind = {1,3,1,2,2};
otherwise
    disp(['Getting data for REPEATED game']);
    stateToFind = {1};
end


valiter = 0;
for g = 1:size(gameList,2);
    curGameType = gameList{g};
    for t = 1:size(teamList,2);
        curTeamType = teamList{t};
        disp([' ']);
        disp(['Game: ', curGameType, '  Team: ',curTeamType]);
        runExp(curGameType,curTeamType,1,1,1,1,1,0,1,'none');
        oName = [curGameType,'-',curTeamType,valiter_str,'-',num2str(numIter),ngStr,expStr];
        if pEps > 0
            oName = [oName, '-pturb', num2str(pEps)];
            oName = strrep(oName, '0.','_');
        end
        load([location, oName]);
        teams = get(simul,'Teams');
        qtbl1 = get(teams{1},'QTable');
        qtbl2 = get(teams{2},'QTable');
        fname = [location, 'tables/', oName];
        fname = [fname, '.txt'];

        oFID = fopen(fname, 'w+');
        switch theGameType
        case {'soccer','Soccer','soc'}
            disp(['printing data for soccer']);
            fprintf(oFID, '              North                East                 West                 Stick\n');
            state = stateToFind;
            state{6} = ':';
            state{7} = ':';
            qt1 = squeeze(qtbl1(state{:}))';
            qt2 = squeeze(qtbl2(state{:}));
            fprintf(oFID, 'North    (%8.5f,%8.5f) (%8.5f,%8.5f) (%8.5f,%8.5f) (%8.5f,%8.5f)\n',...
                    qt1(1,1),qt2(1,1), qt1(1,3), qt2(1,3), qt1(1,4),qt2(1,4), qt1(1,5), qt2(1,5));
            fprintf(oFID, 'East     (%8.5f,%8.5f) (%8.5f,%8.5f) (%8.5f,%8.5f) (%8.5f,%8.5f)\n',...
                    qt1(3,1),qt2(3,1), qt1(3,3), qt2(3,3), qt1(3,4),qt2(3,4), qt1(3,5), qt2(3,5));
            fprintf(oFID, 'West     (%8.5f,%8.5f) (%8.5f,%8.5f) (%8.5f,%8.5f) (%8.5f,%8.5f)\n',...
                    qt1(4,1),qt2(4,1), qt1(4,3), qt2(4,3), qt1(4,4),qt2(4,4), qt1(4,5), qt2(4,5));
            fprintf(oFID, 'Stick    (%8.5f,%8.5f) (%8.5f,%8.5f) (%8.5f,%8.5f) (%8.5f,%8.5f)\n',...
                    qt1(5,1),qt2(5,1), qt1(5,3), qt2(5,3), qt1(5,4),qt2(5,4), qt1(5,5), qt2(5,5));
        case {'grid', 'Grid', 'grrr'}
            disp(['printing data for grid']);
            fprintf(oFID, '             Center                  Side\n');
            state = stateToFind;
            state{5} = ':';
            if (strncmp(curTeamType, 'QQ',2) == 1)
                qt1 = squeeze(qtbl1(state{:}));
                qt2 = squeeze(qtbl2(state{:}));
                fprintf(oFID, 'Center   (%8.5f,%8.5f )    (%8.5f,%8.5f )\n',qt1(2),qt2(1), qt1(2), qt2(3));
                fprintf(oFID, 'Side     (%8.5f,%8.5f )    (%8.5f,%8.5f )\n',qt1(3),qt2(1), qt1(3), qt2(3));
            else
                state{6} = ':';
                qt1 = squeeze(qtbl1(state{:}))';
                qt2 = squeeze(qtbl2(state{:}));
                fprintf(oFID, 'Center   (%8.5f,%8.5f )    (%8.5f,%8.5f )\n',qt1(2,1),qt2(2,1), qt1(2,3), qt2(2,3));
                fprintf(oFID, 'Side     (%8.5f,%8.5f )    (%8.5f,%8.5f )\n',qt1(3,1),qt2(3,1), qt1(3,3), qt2(3,3));
            end
        otherwise
            disp(['printing data for repeated']);
            fprintf(oFID, '             Left                    Right\n');
            qt1 = squeeze(qtbl1(1,:,:))';
            qt2 = squeeze(qtbl2(1,:,:));
            fprintf(oFID, 'Top      (%8.5f,%8.5f )    (%8.5f,%8.5f )\n',qt1(1,1),qt2(1,1), qt1(1,2), qt2(1,2));
            fprintf(oFID, 'Bottom   (%8.5f,%8.5f )    (%8.5f,%8.5f )\n',qt1(2,1),qt2(2,1), qt1(2,2), qt2(2,2));
        end
        fclose(oFID);
    end
end
