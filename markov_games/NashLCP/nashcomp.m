%-----------------------------------------------------------------------
% File: nashcomp.m
%
% Description:
%   compute a nash equilibrium using the 
%   Lemke-Howson algoirhtm (from R. Cottle 1992 Academic Press)
%   adapted from java implimentation provided by Junling Hu 2002.
%
%   player 1 has m actions
%   player 2 has n actions
%   A and B are mXn payoff matricies for pl. 1 & 2
%-----------------------------------------------------------------------
function Z = nashcomp(A,B)

% player 1 has m actions
% player 2 has n actions
% A and B are mXn payoff matricies for pl. 1 & 2
		
rows = size(A,1);
cols = size(A,2);
dimM = rows + cols;

% pre-allocate
LZ = zeros(rows,dimM);
WList = zeros(dimM,2);
ZList = zeros(dimM,2);
Q = zeros(1,dimM);

% Turn payoff matricies into cost matricies
LA = -A;
LB = -B;

% A and B need to be positive valued
% *** Junling added max absoute value.  could have subtracted min value
%abmaxA = max(max(abs(LA)));
%abmaxB = max(max(abs(LB)));
negminA = max(0,- min(min(LA)));
negminB = max(0,- min(min(LB)));

%M0 = [zeros(rows,rows) LA+abmaxA+1; (LB+abmaxB+1)' zeros(cols,cols)];
M0 = [zeros(rows,rows) LA+negminA+1; (LB+negminB+1)' zeros(cols,cols)];
for k = 1:rows
    for i =1:dimM 
        WList(i,2) = i;
        WList(i,1) =1;
        ZList(i,2) = i;
        ZList(i,1) =2;
    end
    Q = - ones(1,dimM);
    M = M0;

    % get one nash solution
    [LZ,WList,ZList] = getOneNash(M,Q,WList,ZList,k,LA,LB,LZ, rows, cols, dimM); 

    Z(k,:) = LZ(k,:);
end
