%-----------------------------------------------------------------------
% File:
%
% Description:
%
%-----------------------------------------------------------------------
function cvec = maxconvinfo(qHist, numIter, colid, numIntervals)

interval = numIter / numIntervals;
cvec = zeros(1,numIntervals);
for i = 1:numIntervals
    cvec(i) = max(abs(qHist((interval * (i-1)) + 1 :end, colid)));
end
