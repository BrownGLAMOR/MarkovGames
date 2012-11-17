%-----------------------------------------------------------------------
%
% 
% function cvec = convinfo(qHist, numIter, colid, numIntervals, style, numSubInts)
%
%-----------------------------------------------------------------------
function cvec = convinfo(qHist, numIter, colid, numIntervals, style, numSubInts)

interval = numIter / numIntervals;
if nargin < 6
    numSubInts = 4; % for sliding windows
end
increment = interval / numSubInts; % sliding windows
cvec = zeros(1,numIntervals);
switch style
case 'mean'
    for i = 1:numIntervals
        cvec(i) = mean(abs(qHist((interval * (i-1)) + 1 :end, colid)));
    end
case 'std'
    for i = 1:numIntervals
        cvec(i) = std(qHist((interval * (i-1)) + 1 :end, colid));
    end
case 'rms'
    for i = 1:numIntervals
        cvec(i) = sqrt(sum((qHist((interval * (i-1)) + 1 :end, colid)).^2)/...
                       interval);
    end
case 'max'
    for i = 1:numIntervals
        cvec(i) = max(abs(qHist((interval * (i-1)) + 1 :end, colid)));
    end
case 'meanback'
    for i = 1:numIntervals
        cvec(i) = mean(abs(qHist(1:(interval * i), colid)));
    end
case 'stdback'
    for i = 1:numIntervals
        cvec(i) = std(qHist(1:(interval * i), colid));
    end
case 'rmsback'
    for i = 1:numIntervals
        cvec(i) = sqrt(sum((qHist(1:(interval * i), colid)).^2)/interval);
    end
case 'maxback'
    for i = 1:numIntervals
        cvec(i) = max(abs(qHist(1:(interval * i), colid)));
    end
case 'maxmax'
    maxVal = 0;
    for i = 1:numIntervals
        if max(abs(qHist(((i-1) * interval + 1):(i * interval), colid))) > maxVal
            maxVal = qHist(i, colid);
        end
        cvec(i) = maxVal;
    end
case 'meanslide'
    numIter = numIntervals * numSubInts - numSubInts;
    cvec = zeros(1,numIntervals * numSubInts);
    for i = 1:numIter
        startInt = increment * (i - 1) + 1;
        endInt = startInt + interval - 1;
        cvec(i) = mean(abs(qHist(startInt:endInt, colid)));
    end
case 'stdslide'
    numIter = numIntervals * numSubInts - numSubInts;
    cvec = zeros(1,numIntervals * numSubInts);
    for i = 1:numIter
        startInt = increment * (i - 1) + 1;
        endInt = startInt + interval - 1;
        cvec(i) = std(qHist(startInt:endInt, colid));
    end
case 'rmsslide'
    numIter = numIntervals * numSubInts - numSubInts;
    cvec = zeros(1,numIntervals * numSubInts);
    for i = 1:numIter
        startInt = increment * (i - 1) + 1;
        endInt = startInt + interval - 1;
        cvec(i) = sqrt(sum((qHist(startInt:endInt, colid)).^2)/interval);
    end
case 'maxslide'
    numIter = numIntervals * numSubInts - numSubInts;
    cvec = zeros(1,numIntervals * numSubInts);
    for i = 1:numIter
        startInt = increment * (i - 1) + 1;
        endInt = startInt + interval - 1;
        cvec(i) = max(abs(qHist(startInt:endInt, colid)));
    end
otherwise
    error(['invalid style: ', style]);
end
