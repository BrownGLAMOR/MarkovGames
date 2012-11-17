%-----------------------------------------------------------------------
% File: getOneNash.m
%
% Description:
%   compute a nash EQM using the Lemke-Howson algorithm
%
%-----------------------------------------------------------------------

function [LZ, WList, ZList] = getOneNash(M,Q,WList,ZList,k,LA,LB,LZ,rows,cols,dimM)

% find c be the best action agent 2 can take
[mval, c] = min(LB(k,:));

% Pivot get new q, M and exchange-elements
[Q,M] = pivot(Q,M,c+rows,k,dimM);
[WList,ZList] = exchange_elm(WList,ZList,c+rows,k);
    

% find r is the best action agent 1 can take against c
[mval, r] = min(LA(:,c));

% Pivot get new q, M and exchange-elements
[Q,M] = pivot(Q,M,r,c+rows, dimM); 
[WList,ZList] = exchange_elm(WList,ZList,r,c+rows);
j1 = 0;

if r == k
    % we have the solution
    [LZ] = getfinalZ(WList,Q,LZ,k,dimM);
else
    j1 = findMinRatio(Q,M,r);
    if j1 == -1 
        [LZ] = getfinalZ(WList,Q,LZ,k,dimM);
    else
        % // get to original step 
        [Q,M] = pivot(Q,M,j1,r,dimM);

        %if k == 2 
        %    QMprint(M,dimM,dimM);
        %end
        cnt = 0;
        while j1 ~= -1 & WList(j1,2) ~= k
            cnt = cnt + 1;
            if cnt > 10000
                keyboard;
            end
            % copy Wlist to oldWlist
            oldWList = WList;
            [WList,ZList] = exchange_elm(WList,ZList,j1,r);
            r = findComp(j1,oldWList,ZList,dimM);

            % go back to step 1. r is the new driving variable
            j1 = findMinRatio(Q,M,r); 
            if j1 ~= -1 
                [Q,M] = pivot(Q,M,j1,r,dimM);
            end
        end
        if j1 ~= -1 
            [WList, ZList] = exchange_elm(WList,ZList,j1,r);
        end
        [LZ] = getfinalZ(WList,Q,LZ,k,dimM);
    end
end
	
% normalize
sum1 = sum(abs(LZ(k,1:rows)));
LZ(k,1:rows) = LZ(k,1:rows)/sum1;
sum2 = sum(abs(LZ(k,rows+1:dimM)));
LZ(k,rows+1:dimM) = LZ(k,rows+1:dimM)/sum2;
