function genvtables(location, games, teams, teamlabels, numIter, isGrid, pEps, expStr)

if nargin < 5
    numIter = 1000;
end
if nargin < 6
    isGrid = 0;
end
if nargin < 7
    pEps = 0;
end
if nargin < 8
    expStr = '-NG-alpha1-eps1';
end

numAction = 2;
if isGrid
    statelen = 4;
else
    statelen = 1;
end
valiter = 0;
valiter_str = '';

for g = 1:size(games,2);
    gametype = games{g};
    fname = [location, 'tables/',gametype,'-Values'];
    texname = [location, 'tables/',gametype,'-Values'];
    if pEps > 0
        fname = [fname, '-pturb', num2str(pEps)];
        fname = strrep(fname, '0.','_');
        texname = [texname, '-pturb', num2str(pEps)];
        texname = strrep(texname, '0.','_');
    end
    fname = [fname, '.txt'];
    texname = [texname, '.tex'];
    oFID = fopen(fname, 'w+');
    tFID = fopen(texname, 'w+');
    fprintf(oFID, '%15s  %5s     %5s\n','Algorithm','P1','P2');
    fprintf(tFID, '\\documentclass{article}\n');
    fprintf(tFID, '\\begin{document}\n\n\n');
    fprintf(tFID, '\\begin{table}[th!]\n');
    fprintf(tFID, '\\begin{minipage}[t]{\\textwidth}\n');
    fprintf(tFID, '\\begin{center}\n');
    fprintf(tFID, '\\begin{tabular}{||l||c|c||}\n');
    fprintf(tFID, '\\hline\n');
    fprintf(tFID, '%15s & %5s & %5s\\\\ \n','Algorithm','P1','P2');
    fprintf(tFID, '\\hline\n');
    for t = 1:size(teams,2);
        teamtype = teams{t};
        disp([' ']);
        disp(['Game: ', gametype, '  Team: ',teamtype]);
        oName = [gametype,'-',teamtype,valiter_str,'-',num2str(numIter),expStr];
        if pEps > 0
            oName = [oName, '-pturb', num2str(pEps)];
            oName = strrep(oName, '0.','_');
        end
        qh1 = load([location, oName,'-qhist1.txt']);
        qh2 = load([location, oName,'-qhist2.txt']);
        if isGrid
            qh1 = filterHist(qh1,[3,1,1,1],4);
            qh2 = filterHist(qh2,[3,1,1,1],4);
        end
        qlist1 = accumQvals(qh1, numAction, statelen, valiter);
        qlist2 = accumQvals(qh2, numAction, statelen, valiter);
        fprintf(oFID, '%15s  %8.5f  %8.5f\n',teamlabels{t},qlist1(end,9), qlist2(end,9));
        fprintf(tFID, '%15s & %8.5f & %8.5f\\\\\n',teamlabels{t},qlist1(end,9), qlist2(end,9));
    end
    fprintf(tFID, '\\hline\n');
    fprintf(tFID, '\\end{tabular}\n\\end{center}\n\\end{minipage}\n');
    fprintf(tFID, '\\caption{%s values}\n', gametype);
    fprintf(tFID, '\\label{tab:%s}\n',gametype);
    fprintf(tFID, '\\end{table}\n');
    fprintf(tFID, '\n\n\n\\end{document}\n');
    fclose(oFID);
    fclose(tFID);
end
