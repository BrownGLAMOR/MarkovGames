%-----------------------------------------------------------------------
% File:
%
% Description:
%
%-----------------------------------------------------------------------
function rmsvec = rms(qHist, numIter, colid, numIntervals)

interval = numIter / numIntervals;
rmsvec = zeros(1,numIntervals);

for i = 1:numIntervals
%    cvec(i) = max(abs(qHist(interval * i:end, colid)));
%    cvec(i) = std(qHist((interval * (i-1))+1:interval * i, colid));
    ival = qHist((interval * (i - 1)) + 1: end, colid);
    rmsvec(i) = sum(ival.^2) / length(ival);
end
